From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: Re: 3.18.3 + latest bcache-dev
Date: Wed, 21 Jan 2015 12:04:00 +0100
Message-ID: <20150121110400.GA14729@cuci.nl>
References: <20150121012424.GB5533@cuci.nl>
 <CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:43735 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbAULED (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 21 Jan 2015 06:04:03 -0500
Content-Disposition: inline
In-Reply-To: <CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Kent Overstreet wrote:
>Try increasing btree_scan_ratelimit?

Well, before I could try this, the 100% CPU usage was gone (after several hours).

However, something else happened:

a. During some heavy traffic mostly writing to the btrfs filesystem
   the kernel halted.  AFAICS inside some btrfs recovery code.
b. Kernel messages show something like this leading up to the freeze:

Jan 21 11:21:40 ip144 kernel: ata11.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Jan 21 11:21:40 ip144 kernel: ata11.00: irq_stat 0x40000008
Jan 21 11:21:40 ip144 kernel: ata11.00: failed command: READ FPDMA QUEUED
Jan 21 11:21:40 ip144 kernel: ata11.00: cmd 60/00:c0:10:d0:d9/04:00:01:00:00/40 tag 24 ncq 524288 in
Jan 21 11:21:40 ip144 kernel:         res 41/40:00:d0:d1:d9/00:00:01:00:00/00 Emask 0x409 (media error) <F>
Jan 21 11:21:40 ip144 kernel: ata11.00: status: { DRDY ERR }
Jan 21 11:21:40 ip144 kernel: ata11.00: error: { UNC }
Jan 21 11:21:40 ip144 kernel: ata11.00: configured for UDMA/133
Jan 21 11:21:40 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 11:21:40 ip144 kernel: Result: hostbyte=0x00 driverbyte=0x08
Jan 21 11:21:40 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 11:21:40 ip144 kernel: Sense Key : 0x3 [current] [descriptor]
Jan 21 11:21:40 ip144 kernel: Descriptor sense data with sense descriptors (in hex):
Jan 21 11:21:40 ip144 kernel:        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jan 21 11:21:40 ip144 kernel:        01 d9 d1 d0 
Jan 21 11:21:40 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 11:21:40 ip144 kernel: ASC=0x11 ASCQ=0x4
Jan 21 11:21:40 ip144 kernel: sd 10:0:0:0: [sdg] CDB: 
Jan 21 11:21:40 ip144 kernel: cdb[0]=0x88: 88 00 00 00 00 00 01 d9 d0 10 00 00 04 00 00 00
Jan 21 11:21:40 ip144 kernel: blk_update_request: I/O error, dev sdg, sector 31052240
Jan 21 11:21:40 ip144 kernel: ata11: EH complete
Jan 21 11:21:40 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
Jan 21 11:21:40 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
Jan 21 11:21:40 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
Jan 21 11:21:40 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 4, flush 0, corrupt 0, gen 0
Jan 21 11:21:40 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 5, flush 0, corrupt 0, gen 0

   The above repeats like 10 times in 4 second intervals (more or less), and then a final:

Jan 21 11:35:32 ip144 kernel: ata11.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
Jan 21 11:35:32 ip144 kernel: ata11.00: irq_stat 0x40000008
Jan 21 11:35:32 ip144 kernel: ata11.00: failed command: READ FPDMA QUEUED
Jan 21 11:35:32 ip144 kernel: ata11.00: cmd 60/80:58:90:f2:da/01:00:01:00:00/40 tag 11 ncq 196608 in
Jan 21 11:35:32 ip144 kernel:         res 41/40:00:90:f2:da/00:00:01:00:00/00 Emask 0x409 (media error) <F>
Jan 21 11:35:32 ip144 kernel: ata11.00: status: { DRDY ERR }
Jan 21 11:35:32 ip144 kernel: ata11.00: error: { UNC }
Jan 21 11:35:32 ip144 kernel: ata11.00: configured for UDMA/133
Jan 21 11:35:32 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 11:35:32 ip144 kernel: Result: hostbyte=0x00 driverbyte=0x08
Jan 21 11:35:32 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 11:35:32 ip144 kernel: Sense Key : 0x3 [current] [descriptor]
Jan 21 11:35:32 ip144 kernel: Descriptor sense data with sense descriptors (in hex):
Jan 21 11:35:32 ip144 kernel:        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jan 21 11:35:32 ip144 kernel:        01 da f2 90 
Jan 21 11:35:32 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 11:35:32 ip144 kernel: ASC=0x11 ASCQ=0x4
Jan 21 11:35:32 ip144 kernel: sd 10:0:0:0: [sdg] CDB: 
Jan 21 11:35:32 ip144 kernel: cdb[0]=0x88: 88 00 00 00 00 00 01 da f2 90 00 00 01 80 00 00
Jan 21 11:35:32 ip144 kernel: blk_update_request: I/O error, dev sdg, sector 31126160
Jan 21 11:35:32 ip144 kernel: ata11: EH complete
Jan 21 11:35:32 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 130, flush 0, corrupt 0, gen 0
Jan 21 11:35:32 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 131, flush 0, corrupt 0, gen 0
Jan 21 11:35:32 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 132, flush 0, corrupt 0, gen 0
Jan 21 11:35:32 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 133, flush 0, corrupt 0, gen 0
Jan 21 11:35:32 ip144 kernel: BTRFS: bdev /dev/bcache2 errs: wr 0, rd 134, flush 0, corrupt 0, gen 0
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131932160 (dev /dev/bcache2 sector 31126160)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131981312 (dev /dev/bcache2 sector 31126256)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131936256 (dev /dev/bcache2 sector 31126168)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131964928 (dev /dev/bcache2 sector 31126224)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131923968 (dev /dev/bcache2 sector 31126144)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131948544 (dev /dev/bcache2 sector 31126192)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131944448 (dev /dev/bcache2 sector 31126184)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 131956736 (dev /dev/bcache2 sector 31126208)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 132001792 (dev /dev/bcache2 sector 31126296)
Jan 21 11:35:33 ip144 kernel: BTRFS: read error corrected: ino 318562 off 132009984 (dev /dev/bcache2 sector 31126312)

   After that the system freezes with a kernel oops in btrfs land.

c. Upon reboot, the kernel reports the following:

Jan 21 11:43:46 ip144 kernel: bcache: register_cache() registered cache device sda3
Jan 21 11:43:46 ip144 kernel: bcache: register_cache() registered cache device sdb3
Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdg
Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdc
Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdf
Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sde
Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdd
Jan 21 11:43:46 ip144 kernel: bcache: error on 04063132-f7e1-4f29-a3aa-675491b426f4: sdb3: bad magic (got 17495323148306469098 expect 5629218783827753365) while reading prios from bucket 16868
Jan 21 11:43:46 ip144 kernel: bcache: register_bcache() error opening /dev/sdb3: error reading priorities
Jan 21 11:43:46 ip144 kernel: bcache: bch_cache_read_only() sda3 read only
Jan 21 11:43:46 ip144 kernel: bcache: bch_cache_read_only() sdb3 read only
Jan 21 11:43:46 ip144 kernel: bcache: cache_set_free() Cache set 04063132-f7e1-4f29-a3aa-675491b426f4 unregistered
Jan 21 11:43:46 ip144 kernel: bcache: bch_cache_release() sda3 removed
Jan 21 11:43:46 ip144 kernel: bcache: bch_cache_release() sdb3 removed

Now, the data on this filesystem is non-critical, so I could either attempt a repair
or wipe and start over.  Any suggestions?
Writeback was on, so simply reformatting sdb3 most likely will result in mayhem.
I should probably take out sdg and replace it with a drive without errors.
-- 
Stephen.
