From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache (device?) failure
Date: Tue, 29 Jan 2013 11:11:26 -0800
Message-ID: <20130129191126.GN26407@google.com>
References: <1359131422.8441.0.camel@professorx.vistashare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1359131422.8441.0.camel-BhfXqN+OCyH0JUkrLwYuUYegIDNd2VA9XqFh9Ls21Oc@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David H. Rhodes Clymer" <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Fri, Jan 25, 2013 at 11:30:22AM -0500, David H. Rhodes Clymer wrote:
> Speaking of bcache integrity...This morning, bcache started indicating
> that it was encountering errors writing to the drive. 
> 
> For some stupid reason, I rebooted, and on boot, it cannot find the
> volume group (I was running LVM on bcache) that my root fs is on,
> finally dropping to the initramfs shell.
> 
> I then find that attempting to register my bcache component devices
> fails:
> 
> (initramfs) echo /dev/sdb1 > /sys/fs/bcache/register
> sh: write error: invalid argument
> (initramfs) ls /sys/fs/bcache/
> register         register_quiet
> 
> This happens for both the cache device and the backing store. I realize
> that collecting information prior to a reboot would have been much more
> useful...sorry. 
> 
> Is there any simple reason why I would be seeing this behavior? I assume
> that either both devices are corrupt, and no longer seen as bcache
> formatted devices. Does that seem likely?

Yeah... you'd have to check the dmesg log to be sure, but the most
likely cause for that is bcache isn't finding a bcache superblock :/
