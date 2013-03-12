From: Greg Zapp <greg.zapp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Missing /sys/fs/bcache
Date: Tue, 12 Mar 2013 14:36:22 +1300
Message-ID: <CAEHxbC0RoOBHfjBzot2SQ3MNO874vEt3TzGsS0E1gecLZxc_vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello All,

I have decided to just test the bcache-3.2 branch for now without
patching the Ubuntu Kernel.  I've built and installed it successfully
but for some reason /sys/fs/bcache is not present:
root@server:~# uname -a
Linux server.local 3.2.28+ #1 SMP Tue Mar 12 01:28:27 NZDT 2013 x86_64
x86_64 x86_64 GNU/Linux
root@server:~# ls /sys/fs
cgroup  ecryptfs  ext4  fuse

I'm sure I've done something wrong, would anybody be able to point me
in the right direction?

Thanks,
   Greg
