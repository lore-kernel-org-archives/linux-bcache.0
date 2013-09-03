From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux 3.11-rc4 Writeback Cache Corruption
Date: Tue, 3 Sep 2013 21:38:38 +0000 (UTC)
Message-ID: <l05ksu$cgc$1@ger.gmane.org>
References: <52265410.4010000@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, 03 Sep 2013 17:26:40 -0400, Zachary Palmer wrote:
> So here's the question: how would I best go about testing this patch?  
> In looking through the git history, it doesn't seem as if the 
> bcache-for-3.11 branch has been synced against the Linux git since 
> 3.10-rc7 (on June 22nd).  I was thinking I could
> 
>      * Pull the Linux kernel source
>      * Add the bcache git as an origin
>      * Merge the bcache-for-3.11 branch into the Linux 3.11 mainline 
> branch myself and
>      * Assuming that this works, compile and boot the resulting kernel 
> using my Debian kernel .config
> 
> Does this sound reasonable?  Or is there a better way to do this? I'm 
> pretty happy with whatever gives me at least the behavior of my mainline 
> 3.10 kernel and I'm looking forward to getting bcache and laptop power 
> modes on the same machine.  :)

Yeah, it'll merge cleanly.  You can reuse the .config and build with
`make deb-pkg -j -l6`, which is slowly replacing make-kpkg functionality.
