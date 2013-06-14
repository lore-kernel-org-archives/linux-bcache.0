From: John Clark <jwclark-w6MC0wo7I7wAvxtiuMwx3w@public.gmane.org>
Subject: Possible bug? bcache: error opening /dev/md126: Not enough buckets
Date: Fri, 14 Jun 2013 15:34:02 +1000
Message-ID: <CABBemb1tZhTC3SreiGHSB4t7GyfMsyhfA4yPYPk8s8u7iOycLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi there,

I'm new to kernel mailing lists so beg your pardon if I'm asking this
question in the wrong place or in the wrong way.

Anyway, I'm tantalisingly close to getting my bcache-enabled system
up-and-running, but I've hit a brick wall which seems might be a bug
or undocumented performance limit of some kind. I'm hoping Kent or
others on this fine list can help.

I have successfully created the following two RAID1 block devices, as
shown per /proc/mdstat:

Personalities : [raid1]
md126 : active raid1 sdb[0] sdc[1]
      1953383360 blocks super 1.2 [2/2] [UU]

md127 : active raid1 sdd[0] sde[1]
      117155200 blocks super 1.2 [2/2] [UU]

/dev/md126 comprises two 2.0TB spinning HDD's which I'm intending to
use as a bcache backing device
/dev/md127 comprises two 60GB SSD's which I'm intending to use as a
bcache cache device

So far so good.

Creating the bcache superblock on the md127 appears to go smoothly:

root@bigdata:~# make-bcache -C /dev/md127
UUID:                   1736b20f-6b85-4fee-a801-4cf7c1bba009
Set UUID:               b2c9e8e2-0606-4d51-bf9a-e9b8a6f150b3
version:                0
nbuckets:               228818
block_size:             8
bucket_size:            1024
nr_in_set:              1
nr_this_dev:            0
first_bucket:           1


Creating the bcache superblock on md126 *appears* to succeed also:

root@bigdata:~# make-bcache -B /dev/md/spinning

UUID:                   9e2bd59a-a413-4ad2-a07b-6998dfa3e049
Set UUID:               8c70baad-6941-4550-9fc8-b009e016b00d
version:                1
block_size:             8
data_offset:            16

However, the following is output on syslog when executing the above command:
Jun 14 14:21:37 bigdata kernel: [ 1602.102646] bcache: error opening
/dev/md126: Not enough buckets

Indeed, although I can register the cache device (and the UUID shows
up in /sys/fs/bcache), all attempts to register the backing device
fails as follows:

root@bigdata:~# echo /dev/md126 >/sys/fs/bcache/register
-bash: echo: write error: Invalid argument

And, sure enough, the backing device UUID doesn't appear in
/sys/fs/bcache nor at /dev/bcacheN

I've tried using the make-bcache -b parameter to specify a different
bucket size but I still get the same failure (unless I choose
ridiculously high or low bucket sizes, which results in bucket size
errors to be emitted on syslog).

As I was just finishing up writing this and was about to hit SEND, I
noticed something that I wish I had noticed earlier - specifically
that the "bcache-3.2" section of the bcache git repo was last updated
6 months ago.

The kernel I'm running is built from that tree. I had assumed that it
was the version 3.2 kernel patched with a relatively current version
of bcache, but now I think I may be seriously mistaken and my problems
could be due to the possibility that I'm running an old and buggy
version of bcache. I don't want to get ahead of myself, but it seems a
decent guess that my problems might be stemming from the fact that the
'bcache-3.2' tree uses old version of bcache.

At the risk of getting seriously ahead of myself, assuming that my
problem is due to 'bcache-3.2' being out of date and buggy, I'll ask
this: what is the recommended way to get a current and stable version
of bcache running on a stable linux kernel? I'm wanting to use bcache
on a production system and so I'm a little wary of building the
'bcache-for-3.10' tree. Ideally, I'd like to use bcache on a 3.2
kernel, because that's the kernel version readily available presently
in debian stable/wheezy so I will be less likely to encounter kernel
version incompatibilities with my debian wheezy system.

Many thanks in advance if anyone can help me along here.

John
