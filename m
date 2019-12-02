From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback
 mode
Date: Mon, 2 Dec 2019 19:34:12 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1912021932570.11561@mx.ewheeler.net>
References: <20191202102409.3980-1-wings.wyang@gmail.com> <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-844282404-2137853158-1575315263=:11561"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: kungf <wings.wyang@gmail.com>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---844282404-2137853158-1575315263=:11561
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 2 Dec 2019, Coly Li wrote:
> On 2019/12/2 6:24 下午, kungf wrote:
> > data may lost when in the follow scene of writeback mode:
> > 1. client write data1 to bcache
> > 2. client fdatasync
> > 3. bcache flush cache set and backing device
> > if now data1 was not writed back to backing, it was only guaranteed safe in cache.
> > 4.then cache writeback data1 to backing with only REQ_OP_WRITE
> > So data1 was not guaranteed in non-volatile storage,  it may lost if  power interruption 
> > 
> 
> Hi,
> 
> Do you encounter such problem in real work load ? With bcache journal, I
> don't see the possibility of data lost with your description.
> 
> Correct me if I am wrong.
> 
> Coly Li

If this does become necessary, then we should have a sysfs or superblock 
flag to disable FUA for those with RAID BBUs.

--
Eric Wheeler




> > Signed-off-by: kungf <wings.wyang@gmail.com>
> > ---
> >  drivers/md/bcache/writeback.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index 4a40f9eadeaf..e5cecb60569e 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
> >  	 */
> >  	if (KEY_DIRTY(&w->key)) {
> >  		dirty_init(w);
> > -		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> > +		bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
> >  		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
> >  		bio_set_dev(&io->bio, io->dc->bdev);
> >  		io->bio.bi_end_io	= dirty_endio;
> > 
> 
> 
---844282404-2137853158-1575315263=:11561--
