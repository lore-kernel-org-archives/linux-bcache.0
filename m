From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] bcache: Make sure to pass GFP_WAIT to mempool_alloc()
Date: Thu, 15 Jan 2015 10:35:37 -0800
Message-ID: <20150115183537.GA23990@kroah.com>
References: <54B7EA3D.7050203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54B7EA3D.7050203@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: stable@vger.kernel.org, bcache <linux-bcache@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Thu, Jan 15, 2015 at 05:26:37PM +0100, Gabriel de Perthuis wrote:
> this was very wrong - mempool_alloc() only guarantees success with GFP_WAIT.
> bcache uses GFP_NOWAIT in various other places where we have a fallback,
> circuits must've gotten crossed when writing this code or something.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> ---
> 
> The bug was introduced in v3.11, fixed in v3.17.
> 
> Jens mentioned bcache has many stable@ candidates previously:
> https://lkml.org/lkml/2014/9/5/360
> 
> I'm cherry-picking this fix because I was getting crashes.
> 
> ---
>  drivers/md/bcache/btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What exactly is the commit id for this in Linus's tree?

thanks,

greg k-h
