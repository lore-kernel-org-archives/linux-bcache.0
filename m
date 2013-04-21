From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache hangs with continuous write I/O to SSD device: me too
Date: Sat, 20 Apr 2013 18:12:16 -0700
Message-ID: <20130421011215.GB22470@moria.home.lan>
References: <alpine.DEB.2.02.1304181413360.30807@orbit.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304181413360.30807-pfGh9vBu50j/PtFMR13I2A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Apr 18, 2013 at 02:42:59PM +0300, Juha Aatrokoski wrote:
> I ran into the same bug as Heiko Wundram reported a while back:
> after a few (2-4) days of normal desktop usage, bcache hangs and
> dstat shows continuous 50MB/s write to the cache SSD partition with
> one CPU core maxed out in IO wait. I remembered Kent's answer to the
> later message, and at least echoing 0 to writeback_running did
> nothing in my system. The bcache device consists of an SSD partition
> and two disks in md raid0, and there is dmcrypt on top of bcache.
> 
> The branch was bcache patched to a 3.7.10 (Gentoo) kernel. Is bcache
> the correct branch, or should I be using bcache-for-upstream? (There
> are many branches in the git repo, but I can't find any
> documentation/description on what they are and who should use them.)
> 
> I had to revert back to the previous setup, which was bcache-3.2
> patched to a 3.6.11 kernel and which doesn't have the problem. But
> it looks like bcache-3.2 cannot be trivially (i.e. without more
> detailed knowledge about bcache and the bio subsystem) ported to 3.7
> kernels, so I guess I'll be stuck with 3.6 until the bug is fixed.

So, I'm not having any luck with reproducing it, but I do have a
possible fix in the bcache-testing branch - any chance you can give that
a try and let me know if it works?
