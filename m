From: Joseph Yasi <joe.yasi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Writethrough data corruption
Date: Thu, 29 Aug 2013 10:51:28 -0400
Message-ID: <CADzA9o=5a1CMrNF-c9+Z+SmAZ8tNpiRTKY8gbUyL5hnb9iq_eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

On 3.11-rc7 with the bcache-for-3.11 patches applied, I saw this on reboot:

[   16.040622] EXT4-fs error (device bcache0): ext4_lookup:1437: inode
#121897269: comm kde4-config: deleted inode referenced: 121904425
[   16.040624] Aborting journal on device bcache0-8.
[   16.040875] EXT4-fs (bcache0): Remounting filesystem read-only
[   16.041269] EXT4-fs error (device bcache0): ext4_lookup:1437: inode
#121897269: comm kde4-config: deleted inode referenced: 121904425
[   16.073612] EXT4-fs error (device bcache0): ext4_lookup:1437: inode
#121897269: comm kdostartupconfi: deleted inode referenced: 121904425

Bcache is on /home in writethrough mode with /dev/sda3 as the cache
device on an ssd, and /dev/md0 (two WD red drives in RAID-10,f2 mode)
as the backing device. I detached the cache and ran fsck on
/dev/bcache0 to fix the filesystem. I am running the cache device with
discard enabled, and corruption appears on reboot after being up for a
while.

$ bcache-super-show /dev/sda3
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 5EDD6F02BD768B91 [match]
sb.version              3 [cache device]

dev.uuid                37009b03-dad3-463a-8d92-434793f950a6
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 225614848
dev.cache.total_sectors 225615872
dev.cache.discard       yes
dev.cache.pos           0

cset.uuid               5082562f-3f3a-48a7-9059-457e7276a59f

Thanks,
Joe Yasi
