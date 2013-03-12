From: "David H. Rhodes Clymer" <david-LEGOU7lN1jbY0TyS/+Ba5Q@public.gmane.org>
Subject: Re: Missing /sys/fs/bcache
Date: Mon, 11 Mar 2013 21:57:00 -0400
Message-ID: <20130312015700.GA30795@mandarb.home.zettazebra.com>
References: <CAEHxbC0RoOBHfjBzot2SQ3MNO874vEt3TzGsS0E1gecLZxc_vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAEHxbC0RoOBHfjBzot2SQ3MNO874vEt3TzGsS0E1gecLZxc_vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Zapp <greg.zapp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Mar 12, 2013 at 02:36:22PM +1300, Greg Zapp wrote:
> Hello All,
> 
> I have decided to just test the bcache-3.2 branch for now without
> patching the Ubuntu Kernel.  I've built and installed it successfully
> but for some reason /sys/fs/bcache is not present:
> root@server:~# uname -a
> Linux server.local 3.2.28+ #1 SMP Tue Mar 12 01:28:27 NZDT 2013 x86_64
> x86_64 x86_64 GNU/Linux
> root@server:~# ls /sys/fs
> cgroup  ecryptfs  ext4  fuse
> 
> I'm sure I've done something wrong, would anybody be able to point me
> in the right direction?

It's likely that either the bcache module is not loaded:

  lsmod |grep -q bcache || modprobe bcache

Or you didn't compile the kernel with bcache support. Using:

  make menuconfig

In your bcache source tree, Navigate to "Device drivers" --> "Multiple
devices driver support (RAID and LVM)" --> "Block device as cache" and
ensure that it is either built-in <*> or as a module <M>. If it is not
enabled, you'll need to recompile with one of these options.

-davidc
