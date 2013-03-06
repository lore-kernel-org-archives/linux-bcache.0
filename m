From: Paul Klapperich <paul.klapperich+bcache-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Error building after merging upstream 3.7.7
Date: Wed, 6 Mar 2013 16:00:16 +0000 (UTC)
Message-ID: <loom.20130306T165443-49@post.gmane.org>
References: <kfgm5b$c8k$1@ger.gmane.org> <5120CA22.5010708@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Steven Haigh <netwiz@...> writes:

> 
> I would *really* love to see a single .patch that can be applied to 
> 3.7.x kernels. This would allow me to start producing some kernel RPMs 
> for using bcache on EL6 systems.
> 
> I've tried producing something that works, but haven't had much success 
> in patching bcache into the vanilla kernel. Having a single patch that 
> can be easily refactored as newer 3.7.x releases are done would be heaven.
> 
> --
> Steven Haigh

I'm using bcache on the 3.7.9 kernel. I documented how I made the patch on the
Arch Wiki:
https://wiki.archlinux.org/index.php/Bcache#Create_the_patch_file

--
Paul
