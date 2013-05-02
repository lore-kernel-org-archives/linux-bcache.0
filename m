From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Very poor performances with the bcache-for-upstream branch
Date: Thu, 2 May 2013 05:50:54 +0000 (UTC)
Message-ID: <klsuru$l60$2@ger.gmane.org>
References: <CA+XuAnJO4BCE0yj0i_CZ_iQvDj56FHwFZH302XrisD45P5R3Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> 2. I have setup an LVM above bcache, and /dev/sda4 is the only cache
> partition. The whole thing was setup with:
> 
> make-bcache -B /dev/sda4 -C /dev/sdb
> 
> the LVM is "inside" /dev/sda4
> 3. I am using fio as a benchmark, have setup writeback
> # cat /sys/block/bcache0/bcache/writeback_running
> 1
> and I think I have followed every hints I could found about performance tuning.
> Yet, when running the ssd fio test suite on a file on partition that
> is not "cached", I am obtaining the following figures:
> seq-read: iops=29156
> rand-read: iops=291
> seq-write: iops=22355
> rand-write: iops=260
> 
> Running it on a cached file system I'm obtaining:
> seq-read: iops=22196
> rand-read: iops=330
> seq-write: iops=15864
> rand-write: iops=387
> 
> What am I missing ?

Outside of the make-bcache, none of the commands you give in the thread
prove that the cache is assembled (it's actually possible to have
writeback_running = 1 with a detached bdev, though that's a bug in my
opinion).  What does `ls -d /sys/fs/bcache/*/bdev*` show?
