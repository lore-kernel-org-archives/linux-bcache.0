From: Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Poor performance with bcache write-back mode
Date: Thu, 16 May 2013 14:51:46 -0700 (PDT)
Message-ID: <1368741106.62060.YahooMailNeo@web162401.mail.bf1.yahoo.com>
Reply-To: Patrick Ng <ppng-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi all,

I have installed Linux kernel 3.9.2 in my Fedora 18. =A0When I ran FIO =
in bcache write-through mode, the performance was good, but running a s=
imilar test in bcache write-back mode, I got very poor performance.
Did I miss any options when setting the write-back mode?

Environment
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
500G backing store at /dev/sdb1
150G SSD at /dev/sdc1

Write-through mode
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
make-bcache -B /dev/sdb1 -C /dev/sdc1
echo /dev/sdb1 > /sys/fs/bcache/register
echo /dev/sdc1 > /sys/fs/bcache/register
mkfs.ext4 /dev/bcache0
mount /dev/bcache0 /mnt/bcache


Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
the result is approx. 65k IOPS


Write-backe mode (setup is almost the same as write-through except the =
extra step at the end "echo writeback ...")
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
make-bcache -B /dev/sdb1 -C /dev/sdc1
echo /dev/sdb1 > /sys/fs/bcache/register
echo /dev/sdc1 > /sys/fs/bcache/register
mkfs.ext4 /dev/bcache0
mount /dev/bcache0 /mnt/bcache
echo writeback > /sys/block/bcache0/bcache/cache_mode

Running FIO with random, 100% read, iosize=3D4096, queue depth=3D16
the result is approx. 12k IOPS

Running FIO with random, 80% read 20% write, iosize=3D4096, queue depth=
=3D16
the result is approx. 2k IOPS

Thanks,
Patrick=A0
