From: Thomas Fjellstrom <thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org>
Subject: Re: recomended bcache setup
Date: Mon, 24 Dec 2012 01:20:34 -0700
Message-ID: <201212240120.34879.thomas@fjellstrom.ca>
References: <201212212006.41906.thomas@fjellstrom.ca>
Reply-To: thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201212212006.41906.thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri Dec 21, 2012, Thomas Fjellstrom wrote:
> I'm setting up a little home NAS here, and I've been thinking about using
> bcache to speed up the random access bits on the "big" raid6 array (7x2TB).
> 
> How does one get started using bcache (custom patched kernel?), and what is
> the recommended setup for use with mdraid? I remember reading ages ago that
> it was recommended that each component device was attached directly to the
> cache, and then mdraid put on top, but a quick google suggests putting the
> cache on top of the raid instead.
> 
> Also, is it possible to add a cache to an existing volume yet? I have a
> smaller array (7x1TB) that I wouldn't mind adding the cache layer to.

I just tried a basic setup with the cache ontop of the raid6. I ran a quick
iozone test with the default debian sid (3.2.35) kernel, the bcache (3.2.28)
kernel without bcache enabled, and with bcache enabled (See below).

Here's a little information:

system info:
	Intel  S1200KP Motherboard
	Intel Core i3 2120 CPU
	16GB DDR3 1333 ECC
	IBM M1015 in IT mode
	7 x 2TB Seagate Barracuda HDDs
	1 x 240 GB Samsung 470 SSD


kernel: fresh git checkout of the bcache repo, 3.2.28



Raid Info:
/dev/md0:
        Version : 1.2
  Creation Time : Sat Dec 22 03:38:05 2012
     Raid Level : raid6
     Array Size : 9766914560 (9314.46 GiB 10001.32 GB)
  Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Mon Dec 24 00:22:28 2012
          State : clean 
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : mrbig:0  (local to host mrbig)
           UUID : 547c30d1:3af4b2ec:14712d0b:88e4337a
         Events : 10591

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh




Fs info:
root@mrbig:~/build/bcache-tools# xfs_info /dev/bcache0 
meta-data=/dev/bcache0  isize=256    agcount=10, agsize=268435328 blks
         =               sectsz=512   attr=2
data     =               bsize=4096   blocks=2441728638, imaxpct=5
         =               sunit=128    swidth=640 blks
naming   =version 2      bsize=4096   ascii-ci=0
log      =internal       bsize=4096   blocks=521728, version=2
         =               sectsz=512   sunit=8 blks, lazy-count=1
realtime =none           extsz=4096   blocks=0, rtextents=0




iozone -a -s 32G -r 8M
                                                     random  random    bkwd   record   stride                                   
       KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
w/o cache (debian kernel 3.2.35-1)
33554432    8192  212507  210382   630327   630852  372807  161710  388319  4922757   617347   210642   217122  717279   716150
w/ cache  (bcache git kernel 3.2.28):
33554432    8192  248376  231717   268560   269966  123718  132210  148030  4888983   152240   230099   238223  276254   282441
w/o cache (bcache git kernel 3.2.28):
33554432    8192  277607  259159   709837   702192  399889  151629  399779  4846688   655210   251297   245953  783930   778595

Note: I disabled the cache before the last test, unregistered the device and
"stop"ed the cache. I also changed the config slightly for the bcache kernel,
I started out with the debian config, and then switched the preemption option
to server, which may be the reason for the performance difference between the
two non cached tests.

I probably messed up the setup somehow. If anyone has some tips or suggestions
I'd appreciate some input.

-- 
Thomas Fjellstrom
thomas-T/OQ2aoscs6U4IzBdx3r/Q@public.gmane.org
