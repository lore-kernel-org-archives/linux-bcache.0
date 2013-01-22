From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Not able compile bcache-tools source code
Date: Tue, 22 Jan 2013 13:30:28 -0800
Message-ID: <20130122213028.GE26407@google.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7C6@MYMBX.MY.STEC-INC.AD>
 <CAC7rs0uCU9B1SP4G4P1Di05hF=hZd1JJkipKd2UFrBBqEG2PBw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7C7@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A6257C7C7-AQg6BlXVjylhNUoibfp7lHKnxlUjViKd@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nitin Kshirsagar <nshirsagar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, Jan 22, 2013 at 01:36:52PM +0800, Nitin Kshirsagar wrote:
> Hi,
> 
> make install fails  
> [root@annu bcache-tools]# make install
> install -m0755 make-bcache	/usr/sbin/
> install -m0755 probe-bcache	/sbin/
> install -m0644 61-bcache.rules	/lib/udev/rules.d/
> install -m0755 initramfs/script /etc/initramfs-tools/scripts/init-premount/bcache
> install -m0755 initramfs/hook	/etc/initramfs-tools/hooks/bcache
> install: cannot create regular file `/etc/initramfs-tools/hooks/bcache': No such file or directory
> make: *** [install] Error 1

That's just the initramfs script for bringing up bcache if your root fs
is a bcache device - if your distro isn't using initramfs, that's fine,
it's nothing to worry about.

I just pushed a patch to ignore errors on those two lines.
