From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: xfs on bcache: metadata I/O error: block
 0x575b6d70,("xfs_trans_read_buf_map") error 4 numblks 16
Date: Fri, 4 Aug 2017 08:46:28 +0200
Message-ID: <b439f476-be06-4749-f4cd-70cfb46d7c29@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:42332 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751282AbdHDGv4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Aug 2017 02:51:56 -0400
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Eric Wheeler <bcache@lists.ewheeler.net>

Hello,

under very high load i'm getting the following error on bcache devices
since upgrading from opensuse 42.2 to 42.3.

David Chinner and others pointed me that this must be an bcache problem
not an XFS one.

Is this an error or problem you know and just a patch is missing in
opensuse?

XFS (bcache1): metadata I/O error: block 0x575b6d70
("xfs_trans_read_buf_map") error 4 numblks 16
XFS (bcache1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -4.
XFS (bcache1): xfs_do_force_shutdown(0x8) called from line 3519 of file
fs/xfs/xfs_inode.c. Return address = 0xffffffff993441ff
XFS (bcache1): Corruption of in-memory data detected. Shutting down
filesystem
XFS (bcache1): Please umount the filesystem and rectify the problem(s)
XFS (bcache1): xfs_log_force: error -5 returned.
XFS (bcache1): xfs_log_force: error -5 returned.
XFS (bcache1): xfs_log_force: error -5 returned.

Thanks!

Greets,
Stefan
