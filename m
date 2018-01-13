From: Pavel Vazharov <freakpv@gmail.com>
Subject: Re: [PATCH] bcache: io.c: Fix check against error_limit in case of
 io errors
Date: Sat, 13 Jan 2018 06:22:24 +0200
Message-ID: <20180113062224.3e72adb5152ac52e0e3f9d2e@gmail.com>
References: <1515766051-13380-1-git-send-email-freakpv@gmail.com>
        <fe58efbf-a859-e9a3-ba86-ed86232cc51f@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:39619 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965407AbeAMEW1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Jan 2018 23:22:27 -0500
In-Reply-To: <fe58efbf-a859-e9a3-ba86-ed86232cc51f@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: mlyle@lyle.org, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 13 Jan 2018 11:40:54 +0800
Coly Li <i@coly.li> wrote:

> On 12/01/2018 10:07 PM, Pavel Vazharov wrote:
> > The actual sysfs io_error_limit value is left shifted IO_ERROR_SHIFT
> > times before it is stored in the error_limit.
> > This fixes the un-registering of the cache set when the io_errors reach
> > the error_limit value.
> > 
> > Signed-off-by: Pavel Vazharov <freakpv@gmail.com>
> > ---
> >  drivers/md/bcache/io.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> > index fac97ec..1ef6ae2 100644
> > --- a/drivers/md/bcache/io.c
> > +++ b/drivers/md/bcache/io.c
> > @@ -93,7 +93,7 @@ void bch_count_io_errors(struct cache *ca, blk_status_t error, const char *m)
> >  						    &ca->io_errors);
> >  		errors >>= IO_ERROR_SHIFT;
> >  
> > -		if (errors < ca->set->error_limit)
> > +		if (errors < (ca->set->error_limit >> IO_ERROR_SHIFT))
> >  			pr_err("%s: IO error on %s, recovering",
> >  			       bdevname(ca->bdev, buf), m);
> >  		else
> > 
> 
> Hi Pavel,
> 
> A similar fix is also in my device failure patch set, its name is,
>     bcache: set error_limit correctly
> The difference is, I remove the bit shift of error_limit.
> 
> -- 
> Coly Li

Hi Coly,

I see your patch. I think it's better solution.
Originally, I was wondering why the shifting of error_limit is needed
when it's set via sysfs just to shift it back here.

-- 
Pavel Vazharov <freakpv@gmail.com>
