From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Fri, 17 Nov 2017 14:01:36 +0800
Message-ID: <dc6f513b-cca3-a37d-3379-2e12df21e825@suse.de>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Rui Hua <huarui.dev@gmail.com>, Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 17/11/2017 11:51 AM, Rui Hua wrote:
> When we send a read request and hit the clean data in cache device, there
> is a situation called cache read race in bcache(see the commit in the tail
> of cache_look_up(), the following explaination just copy from there):
> The bucket we're reading from might be reused while our bio is in flight,
> and we could then end up reading the wrong data. We guard against this
> by checking (in bch_cache_read_endio()) if the pointer is stale again;
> if so, we treat it as an error (s->iop.error = -EINTR) and reread from
> the backing device (but we don't pass that error up anywhere)
> 

Hi Rui Hua,

I see the point, and agree with you this should be fixed.
Indeed return -EINTR to upper layer makes sense. A read request may
cover several keys, and when a key encounters read race, bcache may
return result of previous keys before read race encountered, and tells
upper layer code this is not full completed by returnning -EINTR. This
is a defined behavior by POSIX.

The reason why I still agree to fix it is, most of upper layer code just
check if bio->bi_status is 0 or not, they don't check whether
bio->bi_status is -EAGAIN or -EINTR.

> It should be noted that cache read race happened under normal
> circumstances, not the circumstance when SSD failed, it was counted
> and shown in  /sys/fs/bcache/XXX/internal/cache_read_races.
> 

Yes, this is not for real I/O error on cache device, the I/O error code
is set by bcache code. I didn't notice this case, and my test didn't
cover such situation. Thank for point out this !

> Without this patch, when we use writeback mode, we will never reread from
> the backing device when cache read race happend, until the whole cache
> device is clean, because the condition

I assume this is a race condition, that means after the race window, the
KEY associated to the reused bucket will be invalided too. So a second
read will trigger a cache miss, and re-read the data back into cache
device. So it won't be "never". The problem is, if upper layer code
treats it as a failed I/O, and it happens to be metadata of upper layer
code, then some negative result may happens. For example file system
turns into read-only mode.

> (s->recoverable && (dc && !atomic_read(&dc->has_dirty))) is false in
> cached_dev_read_error(). In this situation, the s->iop.error(= -EINTR)
> will be passed up, at last, user will receive -EINTR when it's bio end,
> this is not suitable, and wield to up-application.

As I said, most of upper layer code only checks whether bio->bi_status
is 0, otherwise that's error. We need to give such error a second try.

> 
> In this patch, we use s->read_dirty_data to judge whether the read
> request hit dirty data in cache device, it is safe to reread data from
> the backing device when the read request hit clean data. This can not
> only handle cache read race, but also recover data when failed read
> request from cache device.

In your another reply to Michael, you mentioned if bcache internal node
I/O failed, cached_dev_read_error() won't be called. I check the code
with your hint, it seems make sense. Also I am not sure whether the
internal node I/O failure is handled properly or not, I feel for leaf
node, your modification works for both writeback mode, and a
writethrough mode changed from a writeback mode with dirty data.

It seems my previous patch neglects the internal btree node I/O failure,
because I mistakenly thought both internal and leaf node I/O failure
will go into cached_dev_read_error(). Thanks for correct me and provide
a comprehensive fix.

A positive side effect is, Eric, Kent and Michael they all want to
permit data recovery from backing device is the failed data is clean on
cache device. Your patch permits more read request to be served, and
fixs a read race at same time, cool :-)

For users want aggressive I/O error notifying of cache device (SSD), I
think it can be solved some other error accounting methods. We don't
discuss in this thread.

> 
> Signed-off-by: Hua Rui <huarui.dev@gmail.com>

Reviewed-by: Coly Li <colyli@suse.de>

P.S could you please also take a look on btree internal node I/O failure
? Thanks in advance.

Coly Li

> ---
>  drivers/md/bcache/request.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 3a7aed7..f02fefb 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -708,16 +708,15 @@ static void cached_dev_read_error(struct closure *cl)
>  {
>         struct search *s = container_of(cl, struct search, cl);
>         struct bio *bio = &s->bio.bio;
> -       struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
> 
>         /*
> -        * If cache device is dirty (dc->has_dirty is non-zero), then
> -        * recovery a failed read request from cached device may get a
> -        * stale data back. So read failure recovery is only permitted
> -        * when cache device is clean.
> +        * If read request hit dirty data (s->read_dirty_data is true),
> +        * then recovery a failed read request from cached device may
> +        * get a stale data back. So read failure recovery is only
> +        * permitted when read request hit clean data in cache device,
> +        * or when cache read race happend.
>          */
> -       if (s->recoverable &&
> -           (dc && !atomic_read(&dc->has_dirty))) {
> +       if (s->recoverable && !s->read_dirty_data) {
>                 /* Retry from the backing device: */
>                 trace_bcache_read_retry(s->orig_bio);
> 
