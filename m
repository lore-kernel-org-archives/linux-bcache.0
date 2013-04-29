From: Leslie Basmid <leslie.basmid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Very poor performances with the bcache-for-upstream branch
Date: Mon, 29 Apr 2013 17:43:54 +0200
Message-ID: <CA+XuAnJO4BCE0yj0i_CZ_iQvDj56FHwFZH302XrisD45P5R3Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi all,

I have chosen to install bcache using the bcache-for-upstream branch
(recompiled this morning for the latest patches). Even though
everything is running smoothly, I am surprised by the very poor
performance I'm obtaining from my setup.

1. Everything is setup on my laptop which has a 500GB HD (sda) and a
16 GB SSD (sdb).
2. I have setup an LVM above bcache, and /dev/sda4 is the only cache
partition. The whole thing was setup with:

make-bcache -B /dev/sda4 -C /dev/sdb

the LVM is "inside" /dev/sda4
3. I am using fio as a benchmark, have setup writeback
# cat /sys/block/bcache0/bcache/writeback_running
1
and I think I have followed every hints I could found about performance tuning.
Yet, when running the ssd fio test suite on a file on partition that
is not "cached", I am obtaining the following figures:
seq-read: iops=29156
rand-read: iops=291
seq-write: iops=22355
rand-write: iops=260

Running it on a cached file system I'm obtaining:
seq-read: iops=22196
rand-read: iops=330
seq-write: iops=15864
rand-write: iops=387

What am I missing ?
The benchmark parameters are:
bs=4k
ioengine=libaio
iodepth=64
size=1g
direct=1

Thanks in advance for your answers,
Leslie.
