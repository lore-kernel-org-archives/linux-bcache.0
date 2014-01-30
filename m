From: Jean-Tiare LE BIGOT <jean-tiare.le-bigot@ovh.net>
Subject: Bcache deadlocks on 'git clone' with backing device over NFS
Date: Thu, 30 Jan 2014 10:16:19 +0100
Message-ID: <52EA1863.1000601@ovh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:47858 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751122AbaA3JWb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Jan 2014 04:22:31 -0500
Received: from mail612.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo2.mail-out.ovh.net (Postfix) with SMTP id C68BDFFC712
	for <linux-bcache@vger.kernel.org>; Thu, 30 Jan 2014 10:16:20 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Sorry if you got this message twice. I had no idea where to submit a bug 
report.

When using a loopback device over NFS as backing device (like for a VM), 
Bcache appears to dead-lock. But it works flawlessly when backing device 
is an RBD image.

It appears to occur under heavy I/O load. For example, when cloning 
kernel's git repository:

# /dev/sdc --> 80G local SSD
# /dev/loop0 --> blob over nfs
#            --> (works well with RBD for instance)
$ make-bcache -C /dev/loop0 -B /dev/sdc
$ mkfs.ext4 /dev/bcache0
$ mount /dev/bcache0 /mnt/bcache-test
$ cd /mnt/bcache-test
$ time git clone
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Cloning into 'linux'...
remote: Counting objects: 3408218, done.
remote: Compressing objects: 100% (518044/518044), done.
remote: Total 3408218 (delta 2869505), reused 3399526 (delta 2861017)
Receiving objects: 100% (3408218/3408218), 713.99 MiB | 18.16 MiB/s, done.
Resolving deltas: 100% (2869505/2869505), done.
<git process in 'D' state>

Obviously any further I/O on the device locks too so that 'sync' and 
hence clean reboot locks as well.

Here GIT kernel-side stack-trace in this case:

$ uname -a
Linux webp310.cluster016.ha.ovh.net 3.10.26-mutu-ipv6-64-paas+ #9 SMP
Fri Jan 10 11:16:23 CET 2014 x86_64 GNU/Linux

$ echo t > /proc/sysrq-trigger

git             D 0000000000000000     0 10521  10519 0x00000000
  ffff8805fb6b9c98 0000000000000082 0000000000011b00 ffff8805fc8c6f00
  0000000000011b00 ffff8805fb6b9fd8 ffff8805fb6b8010 0000000000011b00
  ffff8805fb6b9fd8 0000000000011b00 ffff8805fc8c6f00 ffff8805fdef14d0
Call Trace:
  [<ffffffff8112f4c0>] ? __lock_page+0x70/0x70
  [<ffffffff81cc8ec4>] schedule+0x24/0x70
  [<ffffffff81cc8f97>] io_schedule+0x87/0xd0
  [<ffffffff8112f4c9>] sleep_on_page+0x9/0x10
  [<ffffffff81cc74e7>] __wait_on_bit+0x57/0x80
  [<ffffffff8112efec>] ? find_get_pages_tag+0xcc/0x180
  [<ffffffff8112f6de>] wait_on_page_bit+0x6e/0x80
  [<ffffffff810e1db0>] ? autoremove_wake_function+0x40/0x40
  [<ffffffff8113afb0>] ? pagevec_lookup_tag+0x20/0x30
  [<ffffffff8112fb6f>] filemap_fdatawait_range+0x10f/0x1b0
  [<ffffffff8112fd30>] filemap_write_and_wait_range+0x90/0xa0
  [<ffffffff81262bf0>] ext4_sync_file+0x50/0x290
  [<ffffffff811a9193>] vfs_fsync_range+0x23/0x30
  [<ffffffff811a91b7>] vfs_fsync+0x17/0x20
  [<ffffffff811a93ec>] do_fsync+0x3c/0x60
  [<ffffffff811a943b>] SyS_fsync+0xb/0x10
  [<ffffffff81ccae12>] system_call_fastpath+0x16/0x1b


Is it a known bug ? How may I avoid dead-locking ?

-- 
Jean-Tiare, team Mutu
