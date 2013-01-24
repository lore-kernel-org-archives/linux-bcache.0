From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Loosing transactions
Date: Thu, 24 Jan 2013 15:35:59 -0800
Message-ID: <20130124233559.GO26407@google.com>
References: <51004490.704@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51004490.704-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pierre Beck <debian-bugs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Jan 23, 2013 at 09:14:09PM +0100, Pierre Beck wrote:
> Hi,
> 
> something is not working as advertised :-)
> 
> I have a test setup for power loss behaviour evaluation. Recently a
> batch of SSDs was of interest and following them, naturally, bcache.
> 
> The test is simple: format an ext4 fs on the target device, copy
> over an empty mysql db and server with ACID compliant config
> (defaults, innodb table), then write inserts with a python script
> and output the latest insert id. Watch via SSH, then cut power. I
> was positively surprised that the consumer SSDs obey flushes and
> don't loose transactions (stored transaction was in fact always one
> or two ahead of output). Intel 520series, Samsung 840 Pro and
> Corsair Neutron GTX, all 256 GB, in case you're wondering. The Intel
> 520 was alot faster btw., I think Sandforce did a really good job
> performance-wise. Testing an OCZ Vector failed, BIOS hang during
> detection.

Ok, sounds reasonable

> Using an external Ext4 Journal with data=journal yielded SSD-like
> write performance with writebacks to an ST3000DM001 at the same
> level thanks to re-ordering, not loosing transactions as well.
> 
> Adding bcache, tests immediately failed, in both writeback and
> writethrough modes. Watching writethrough mode, the performance of
> the HDD looked odd, because waiting for cache flushes it should not
> exceed 1 MiB/s, yet I saw 30 MiB/s. So cache flushes are simply
> eaten somewhere.

Hmm.

So when you say the test failed - were there any inconsistencies after
you rebooted, or was it just that the most recent transactions didn't
amke it down?

> dmesg says this at boot time:
> 
> Jan 23 19:23:37 dr-nick kernel: [    2.948131] sd 2:0:0:0: [sdb]
> 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
> Jan 23 19:23:37 dr-nick kernel: [    2.948135] sd 2:0:0:0: [sdb]
> 4096-byte physical blocks
> Jan 23 19:23:37 dr-nick kernel: [    2.948185] sd 2:0:0:0: [sdb]
> Write Protect is off
> Jan 23 19:23:37 dr-nick kernel: [    2.948189] sd 2:0:0:0: [sdb]
> Mode Sense: 00 3a 00 00
> Jan 23 19:23:37 dr-nick kernel: [    2.948212] sd 2:0:0:0: [sdb]
> Write cache: enabled, read cache: enabled, doesn't support DPO or
> FUA
> Jan 23 19:23:37 dr-nick kernel: [    2.948914] sd 3:0:0:0: [sdc]
> 468862128 512-byte logical blocks: (240 GB/223 GiB)
> Jan 23 19:23:37 dr-nick kernel: [    2.948986] sd 3:0:0:0: [sdc]
> Write Protect is off
> Jan 23 19:23:37 dr-nick kernel: [    2.948990] sd 3:0:0:0: [sdc]
> Mode Sense: 00 3a 00 00
> Jan 23 19:23:37 dr-nick kernel: [    2.949013] sd 3:0:0:0: [sdc]
> Write cache: enabled, read cache: enabled, doesn't support DPO or
> FUA
> 
> and bcache journal recovery looks like this:
> 
> Jan 23 19:24:58 dr-nick kernel: [   96.909115] bcache:
> btree_journal_read() done
> Jan 23 19:24:58 dr-nick kernel: [   97.112616] bcache: btree_check() done
> Jan 23 19:24:58 dr-nick kernel: [   97.113322] bcache: journal
> replay done, 103 keys in 2 entries, seq 6175-6176
> Jan 23 19:24:58 dr-nick kernel: [   97.118998] bcache: Caching sdb
> as bcache0 on set f5f0cd6d-0f77-49d3-ab2d-2203ffff1668
> Jan 23 19:24:58 dr-nick kernel: [   97.119125] bcache: registered
> cache device sdc
> 
> I wonder if there's some cache flushing method missing in bcache
> that other device mappers use to work around the missing support for
> FUA (queue draining?).
> 
> Any ideas where to start debugging?

We probably want to start by simplifying/narrowing it down a bit - we
can eliminate the possibility of the disk having anything to do with it
and just use the SSD by forcing everything to writeback mode:

For that you'll want to disable both sequential bypass (echo 0 >
/sys/block/bcache/bcacheN/sequential_cutoff) and the congested
thresholds -
echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us,
echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us

After that (assuming you're also in writeback mode) all writes will be
writeback writes until the device is more than half full of dirty data.

Can you check if transactions are still getting lost in that setup? If
so (I kind of expect they will be) we may have to do a bit of
blktracing, but that'll really narrow down the possibilities.
