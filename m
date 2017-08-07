From: Coly Li <i@coly.li>
Subject: Re: xfs on bcache: metadata I/O error: block
 0x575b6d70,("xfs_trans_read_buf_map") error 4 numblks 16
Date: Mon, 7 Aug 2017 18:24:52 +0800
Message-ID: <b6064182-7363-c2ac-5f5a-120fe04dcd6b@coly.li>
References: <b439f476-be06-4749-f4cd-70cfb46d7c29@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:51756 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752645AbdHGKY7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Aug 2017 06:24:59 -0400
In-Reply-To: <b439f476-be06-4749-f4cd-70cfb46d7c29@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Eric Wheeler <bcache@lists.ewheeler.net>

On 2017/8/4 下午2:46, Stefan Priebe - Profihost AG wrote:
> Hello,
> 
> under very high load i'm getting the following error on bcache devices
> since upgrading from opensuse 42.2 to 42.3.
> 
> David Chinner and others pointed me that this must be an bcache problem
> not an XFS one.
> 
> Is this an error or problem you know and just a patch is missing in
> opensuse?
> 
> XFS (bcache1): metadata I/O error: block 0x575b6d70
> ("xfs_trans_read_buf_map") error 4 numblks 16
> XFS (bcache1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -4.
> XFS (bcache1): xfs_do_force_shutdown(0x8) called from line 3519 of file
> fs/xfs/xfs_inode.c. Return address = 0xffffffff993441ff
> XFS (bcache1): Corruption of in-memory data detected. Shutting down
> filesystem
> XFS (bcache1): Please umount the filesystem and rectify the problem(s)
> XFS (bcache1): xfs_log_force: error -5 returned.
> XFS (bcache1): xfs_log_force: error -5 returned.
> XFS (bcache1): xfs_log_force: error -5 returned.

Hi Stefan,

In Leap 42.3 there is a patch prevents bcache from recovering I/O error
on cached device for non-writethrough mode. This is to avoid recovering
staled data from backing device. And this patch is not upstream yet (I
am working on a more proper version for upstream at mean time).

So it is possible that bcache encounter I/O error on cache device for
writeback mode, then xfs code receives -EIO (-5) in the above kernel log.

I see on bugzilla.opensuse.org you mentioned after reverting this patch,
no error reported any more. Let's see what happens inside, and for
upstream version patch, there is sysfs option to disable/enable the I/O
recovery behavior.

Thanks.

-- 
Coly Li
