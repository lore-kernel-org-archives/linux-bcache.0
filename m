From: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Subject: Doubling (?) of writes
Date: Mon, 24 Jun 2013 14:57:48 +0200
Message-ID: <51C8424C.8020709@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hey,

I've been using bcache for quite some time now in production, and after 
the initial problems that I faced with strange hangs on writes (see the 
mailing list history), it seems to run smooth now - I've had no kernel 
panics or hangs for quite some time now.

What I'm starting to notice just now (after having tuned/changed the 
parameters of bcache a bit) is the fact that writes to the SSD seem to 
double in throughput from what's written to the bcache device. The 
following shows an excerpt from a run of iostat, where /dev/sda is the 
SSD caching device (cache set), and /dev/bcache1 builds on /dev/md2 
(which in is a normal md RAID-1 on two partitions of /dev/sdb and /dev/sdc):

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00   320,00   44,50  408,50    22,25   287,85 
1401,95     8,92   19,81   11,69   20,69   2,21 100,00
sdb               0,00     0,00   13,50   47,00     0,05    22,25 
755,08     0,33    5,62    7,70    5,02   1,95  11,80
sdc               2,50     0,00    0,50   46,50     0,01    22,25 
970,12    64,29 1532,64   40,00 1548,69  21,28 100,00
md0               0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
md1               0,00     0,00   16,50    0,50     0,07     0,01 
8,94     0,00    0,00    0,00    0,00   0,00   0,00
md2               0,00     0,00    0,00   44,50     0,00    22,25 
1024,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00   16,00    0,50     0,06     0,01 
8,73     0,93   13,58   14,00    0,00  44,24  73,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-4              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
bcache1           0,00     0,00    0,00  141,00     0,00   141,00 
2048,00     0,00   28,64    0,00   28,64   0,00   0,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00   316,00   49,50  402,50    24,75   283,87 
1398,34     8,96   19,88   12,20   20,83   2,21 100,00
sdb               0,00     7,00    0,00   56,00     0,00    24,81 
907,23     1,06   18,86    0,00   18,86   2,57  14,40
sdc               0,00     7,00    0,00   55,50     0,00    24,80 
915,19    57,11 1048,43    0,00 1048,43  18,02 100,00
md0               0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
md1               0,00     0,00    0,00   11,50     0,00     0,05 
8,35     0,00    0,00    0,00    0,00   0,00   0,00
md2               0,00     0,00    0,00   49,50     0,00    24,75 
1024,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-0              0,00     0,00    0,00   10,50     0,00     0,05 
9,14     7,29  599,43    0,00  599,43  95,24 100,00
dm-1              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-2              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-3              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
dm-4              0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
bcache1           0,00     0,00    0,00  139,00     0,00   139,00 
2048,00     0,00   28,66    0,00   28,66   0,00   0,00

The wMB/s for /dev/sda are always somewhere around double of those for 
/dev/bcache1. I can't explain why that should be expected/sensible.

The bcache1 and cache set devices have all options for congestion 
control and sequential cutoff turned off, i.e., all writes/reads go 
through the SSD.

sequential_cutoff of bcache1 is 0
congested_read_threshold_us of set is 0
congested_write_threshold_us of set is 0

bcache-show-super for /dev/sda:

sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 8C05DE3B7AFC3311 [match]
sb.version              3 [cache device]

dev.uuid                0520cedd-9edd-45d6-83da-4a1e217373f0
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 468860928
dev.cache.total_sectors 468861952
dev.cache.discard       yes
dev.cache.pos           0

cset.uuid               90b61bf3-cd64-4944-a7fd-c1dd14d981ee

and for /dev/md2

sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 2352A11D57CE3D37 [match]
sb.version              1 [backing device]

dev.uuid                1856f759-7022-4279-92c2-2a8546e0aff5
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     1 [writeback]
dev.data.cache_state    2 [dirty]

cset.uuid               90b61bf3-cd64-4944-a7fd-c1dd14d981ee

Is this behaviour expected, and if it is, why? Thanks for any hints!

-- 
--- Heiko.
