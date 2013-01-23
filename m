From: Pierre Beck <debian-bugs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Subject: Loosing transactions
Date: Wed, 23 Jan 2013 21:14:09 +0100
Message-ID: <51004490.704@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

something is not working as advertised :-)

I have a test setup for power loss behaviour evaluation. Recently a 
batch of SSDs was of interest and following them, naturally, bcache.

The test is simple: format an ext4 fs on the target device, copy over an 
empty mysql db and server with ACID compliant config (defaults, innodb 
table), then write inserts with a python script and output the latest 
insert id. Watch via SSH, then cut power. I was positively surprised 
that the consumer SSDs obey flushes and don't loose transactions (stored 
transaction was in fact always one or two ahead of output). Intel 
520series, Samsung 840 Pro and Corsair Neutron GTX, all 256 GB, in case 
you're wondering. The Intel 520 was alot faster btw., I think Sandforce 
did a really good job performance-wise. Testing an OCZ Vector failed, 
BIOS hang during detection.

Using an external Ext4 Journal with data=journal yielded SSD-like write 
performance with writebacks to an ST3000DM001 at the same level thanks 
to re-ordering, not loosing transactions as well.

Adding bcache, tests immediately failed, in both writeback and 
writethrough modes. Watching writethrough mode, the performance of the 
HDD looked odd, because waiting for cache flushes it should not exceed 1 
MiB/s, yet I saw 30 MiB/s. So cache flushes are simply eaten somewhere.

dmesg says this at boot time:

Jan 23 19:23:37 dr-nick kernel: [    2.948131] sd 2:0:0:0: [sdb] 
5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
Jan 23 19:23:37 dr-nick kernel: [    2.948135] sd 2:0:0:0: [sdb] 
4096-byte physical blocks
Jan 23 19:23:37 dr-nick kernel: [    2.948185] sd 2:0:0:0: [sdb] Write 
Protect is off
Jan 23 19:23:37 dr-nick kernel: [    2.948189] sd 2:0:0:0: [sdb] Mode 
Sense: 00 3a 00 00
Jan 23 19:23:37 dr-nick kernel: [    2.948212] sd 2:0:0:0: [sdb] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 23 19:23:37 dr-nick kernel: [    2.948914] sd 3:0:0:0: [sdc] 
468862128 512-byte logical blocks: (240 GB/223 GiB)
Jan 23 19:23:37 dr-nick kernel: [    2.948986] sd 3:0:0:0: [sdc] Write 
Protect is off
Jan 23 19:23:37 dr-nick kernel: [    2.948990] sd 3:0:0:0: [sdc] Mode 
Sense: 00 3a 00 00
Jan 23 19:23:37 dr-nick kernel: [    2.949013] sd 3:0:0:0: [sdc] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA

and bcache journal recovery looks like this:

Jan 23 19:24:58 dr-nick kernel: [   96.909115] bcache: 
btree_journal_read() done
Jan 23 19:24:58 dr-nick kernel: [   97.112616] bcache: btree_check() done
Jan 23 19:24:58 dr-nick kernel: [   97.113322] bcache: journal replay 
done, 103 keys in 2 entries, seq 6175-6176
Jan 23 19:24:58 dr-nick kernel: [   97.118998] bcache: Caching sdb as 
bcache0 on set f5f0cd6d-0f77-49d3-ab2d-2203ffff1668
Jan 23 19:24:58 dr-nick kernel: [   97.119125] bcache: registered cache 
device sdc

I wonder if there's some cache flushing method missing in bcache that 
other device mappers use to work around the missing support for FUA 
(queue draining?).

Any ideas where to start debugging?

Greetings,

Pierre Beck
