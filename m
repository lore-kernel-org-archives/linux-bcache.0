From: Pete Eby <relative.prime@gmail.com>
Subject: Unable to create /dev/bcacheN after initial creation
Date: Wed, 11 Dec 2013 14:44:10 +0000
Message-ID: <CAFRtjp_+j2RcsEkmsBLjAse7dP+1jXzEkxRAGGLnD=taaMG6Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48800 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LKOoM (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 Dec 2013 09:44:12 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so10100562pbc.15
        for <linux-bcache@vger.kernel.org>; Wed, 11 Dec 2013 06:44:11 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I'm new to using bcache and am having difficulty assembling and
mounting the /dev/bcache* devices after their initial creation, at
which time I can mount them.

My goal to to have the root file system as as bcache device. Currently
booting fails as it can't find the root device, which makes sense
given I'm unable to create and mount it from a live environment as
well - although agagin I can mount it fine at time of creation.

Following is the process I am using. I'd really love to get this
working and would appreciate any tips on where I'm going wrong.

Thanks in advance!
Pete

== Initial Config ==

Installed Suse 13.1 using normal Suse installer, with /boot, / and
swap. / is btrfs and LVM.

Booted to Ubuntu 13.10 live CD, installed bcache-tools and blocks from
ppa:g2p/storage

Used blocks to convert /dev/mapper/system-root to bcache

Run make-bache on /dev/mapper/system-root, and /dev/sdb (the SSD) and
joined using th cset ID provided. This appears to have succeeded, and
after which I was able to mount /dev/bcache1 and the cache (per stats
is /sys) was working correctly. All appeared good.

However, after rebooting I am unable to mount it again as I am never
able to get the /dev/bcache* devices to appear again.

== Subsequent reboot, no /dev/bcache* devices ==

Here is what I see on the subsequent reboot from Ubuntu 13.10 Live CD:

No /sys/fs/bcache on boot:

root@ubuntu:~# ls /sys/fs/
btrfs/    cgroup/   ecryptfs/ ext4/     fuse/     pstore/

Add bcahce tools (and blocks):

apt-add-repository ppa:g2p/storage
apt-get update
apt-get install bcache-tools python3-blocks

Attempting to make-bcache again results in bcache device appearing in /sys/fs:

root@ubuntu:~# make-bcache -C /dev/sdb
Already a bcache device on /dev/sdb, overwrite with --wipe-bcache

root@ubuntu:~# ls /sys/fs/
bcache/   btrfs/    cgroup/   ecryptfs/ ext4/     fuse/     pstore/

Register the devices:
root@ubuntu:~# echo /dev/mapper/system-root > /sys/fs/bcache/register
root@ubuntu:~# echo /dev/sdb > /sys/fs/bcache/register
bash: echo: write error: Invalid argument

Perhaps /dev/sdb alredy registered from failed make-bcache above?
root@ubuntu:~# dmesg | tail
[  559.438930] bcache: register_bcache() error opening /dev/sdb:
device already registered


Examine backing and cache devices superblocks:

root@ubuntu:~# bcache-super-show /dev/mapper/system-root
sb.magic        ok
sb.first_sector        8 [match]
sb.csum            815BCC6A0F4B43B6 [match]
sb.version        4 [backing device]

dev.label        (empty)
dev.uuid        fef7635a-562d-4493-bc9a-eb56eca00609
dev.sectors_per_block    1
dev.sectors_per_bucket    1024
dev.data.first_sector    8192
dev.data.cache_mode    1 [writeback]
dev.data.cache_state    1 [clean]

cset.uuid        00000000-0000-0000-0000-000000000000

root@ubuntu:~# bcache-super-show /dev/sdb
sb.magic        ok
sb.first_sector        8 [match]
sb.csum            7E3113141FAB5928 [match]
sb.version        3 [cache device]

dev.label        (empty)
dev.uuid        897e3a51-4e38-455c-8989-efffcb707be4
dev.sectors_per_block    1
dev.sectors_per_bucket    1024
dev.cache.first_sector    1024
dev.cache.cache_sectors    234439680
dev.cache.total_sectors    234440704
dev.cache.ordered    yes
dev.cache.discard    no
dev.cache.pos        0
dev.cache.replacement    0 [lru]

cset.uuid        01f294ff-6898-46b1-9c39-dcba3df35a8c


root@ubuntu:~# cat /sys/block/sdb/bcache/
block_size                clear_stats               metadata_written
       written
btree_written             discard                   nbuckets
bucket_size               freelist_percent          priority_stats
cache_replacement_policy  io_errors                 set/

root@ubuntu:~# ls /sys/fs/bcache/
01f294ff-6898-46b1-9c39-dcba3df35a8c/ register
     register_quiet

root@ubuntu:~# ls /sys/fs/bcache/01f294ff-6898-46b1-9c39-dcba3df35a8c/
average_key_size              congested_write_threshold_us  stats_five_minute/
block_size                    dirty_data                    stats_hour/
btree_cache_size              flash_vol_create              stats_total/
bucket_size                   internal/                     stop
cache0/                       io_error_halflife             synchronous
cache_available_percent       io_error_limit                tree_depth
clear_stats                   journal_delay_ms              unregister
congested                     root_usage_percent
congested_read_threshold_us   stats_day/

Although cache0 shows above is /sys/fs/bcache, there still is no /dev/bcache0:

root@ubuntu:~# mount /dev/b
block/         bsg/           btrfs-control  bus/

Try to rejoin? Nope.

root@ubuntu:~# blocks to-bcache /dev/mapper/system-root --join
01f294ff-6898-46b1-9c39-dcba3df35a8c
Device /dev/mapper/system-root already has a bcache super block.

What do I have to do to get /dev/bcache* devices to show again and be
mountable? Hopefully once I figure out manual mounting I can then get
it to be mountable as the root file system by grub2 during.

Thank you again for any help.
