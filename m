From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [PATCH] Don't register if a non-bcache superblock is found as
 well
Date: Sun, 21 Jul 2013 18:59:38 -0700
Message-ID: <20130722015938.GD7272@kmo-pixel>
References: <ksh1nq$dvp$1@ger.gmane.org>
 <1374430637-12954-1-git-send-email-g2p.code@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1374430637-12954-1-git-send-email-g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Cyril B ." <cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Sun, Jul 21, 2013 at 08:17:17PM +0200, Gabriel wrote:
> ---
> This should fix it.
> 
> Because the raid superblock is at the end of the device, bcache's
> udev rules could detect a bcache device on the unassembled raid
> member.  A better fix would be to merge probe-bcache into
> util-linux's blkid.

Thanks, applied.
