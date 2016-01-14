From: Miu Vlad-Cosmin <miuvlad@gmail.com>
Subject: writeback: Stability issue (BUG) on 4.4 with =?utf-8?b?d3JpdGViYWNrX3BlcmNlbnQ=?=
Date: Thu, 14 Jan 2016 07:22:23 +0000 (UTC)
Message-ID: <loom.20160114T081429-882@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34561 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbcANHZH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 14 Jan 2016 02:25:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1aJcHI-00071c-Le
	for linux-bcache@vger.kernel.org; Thu, 14 Jan 2016 08:25:04 +0100
Received: from 188-173-3-123.next-gen.ro ([188-173-3-123.next-gen.ro])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 14 Jan 2016 08:25:04 +0100
Received: from miuvlad by 188-173-3-123.next-gen.ro with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Thu, 14 Jan 2016 08:25:04 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

In a rather basic bcache setup (one cache + mdraid backing),
I encounter a kernel problem related to bcache with 4.4.0.

In order to trigger this bug, fill the cache with some dirty data.
When there is some dirty data, wait for the bcache_writeback to 
start writing it to the backing device (0-3 minutes) 
and the BUG triggers.

Please find more info here: https://bugzilla.kernel.org/show_bug.cgi?id=110771

[<ffffffff815822af>] make_request+0x47f/0xca0
[<ffffffff815a5d3d>] md_make_request+0xdd/0x220
[<ffffffff810c53ce>] ? pick_next_task_fair+0x12e/0x450
[<ffffffff81311d2e>] generic_make_request+0xce/0x1b0
[<ffffffff815a1b70>] write_dirty+0x60/0xb0
[<ffffffff810aafa7>] process_one_work+0x147/0x3d0
[<ffffffff810ab546>] worker_thread+0x46/0x440
[<ffffffff810ab500>] ? rescuer_thread+0x2d0/0x2d0
[<ffffffff810ab500>] ? rescuer_thread+0x2d0/0x2d0
[<ffffffff810afeb4>] kthread+0xc4/0xe0
[<ffffffff810afdf0>] ? kthread_park+0x50/0x50
[<ffffffff8170c85f>] ret_from_fork+0x3f/0x70

A bisect shows "[578270bfbd2803dc7b0b03fbc2ac119efbc73195] 
block: fix segment split" as the problem.

Anyone can confirm this ?

Thanks,
Vlad
