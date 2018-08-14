From: Sean Fu <fxinrong@gmail.com>
Subject: Re: [PATCH] md/bcache: Remove NULL check.
Date: Tue, 14 Aug 2018 10:28:24 +0800
Message-ID: <20180814022824.GA19644@linux-zmni.apac.novell.com>
References: <1534153129-24869-1-git-send-email-fxinrong@gmail.com>
 <d02ab12b-3087-020e-cf51-cbd7940f8efc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d02ab12b-3087-020e-cf51-cbd7940f8efc@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Aug 13, 2018 at 06:00:11PM +0800, Coly Li wrote:
> On 2018/8/13 5:38 PM, Sean Fu wrote:
> > Remove unnessesary NULL check before kmem_cache_destroy() in
> > drivers/md/bcache/request.c
> > 
> > Signed-off-by: Sean Fu <fxinrong@gmail.com>
> 
> Hi Sean,
> 
> A same change is posted in my previous checkpatch fixes series. You may
> find it from,
> https://git.kernel.org/pub/scm/linux/kernel/git/colyli/linux-bcache.git/?h=for-next
> 
> The identical patch is,
> https://git.kernel.org/pub/scm/linux/kernel/git/colyli/linux-bcache.git/commit/?h=for-next&id=26b39d0732955ecb839d0afe8d6211d70f213384
>
Thank you for your reply.

Sean Fu
> Thanks.
> 
> Coly Li
> 
> > ---
> >  drivers/md/bcache/request.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index ae67f5f..0ddee35 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
> > @@ -1306,8 +1306,7 @@ void bch_flash_dev_request_init(struct bcache_device *d)
> >  
> >  void bch_request_exit(void)
> >  {
> > -	if (bch_search_cache)
> > -		kmem_cache_destroy(bch_search_cache);
> > +	kmem_cache_destroy(bch_search_cache);
> >  }
> >  
> >  int __init bch_request_init(void)
> > 
> 
