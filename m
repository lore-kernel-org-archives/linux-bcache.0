From: Thomas Rosenstein <thomas@ccs.at>
Subject: Bcache file corruption
Date: Tue, 7 Feb 2017 12:17:16 +0100
Message-ID: <93B8FFF8-6FC1-4DE6-AD80-EDC7180C670F@ccs.at>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ve1eur01on0124.outbound.protection.outlook.com ([104.47.1.124]:65324
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753268AbdBGLRY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Feb 2017 06:17:24 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I'm trying to run bcache on a Hyper-V VM, following setup:

caching device 50GB fixed disk on a Samsung 850 Pro 1 TB Raid 1

backing device 700GB dynamic disk on a 8x 4 TB RAID6


The bcache device is formatted as LVM with 1 volume XFS. The writeback 
mode is activated.

When I try to restore a 600 GB Postgresql backup, I get a file 
corruption error.

I have tried 3 times, and the file corruption is each time at a 
different (file) location,
additionally the corruption is not present when restoring the same 
backup on a non-bcache disk.

Based on that info, I assume that bcache has got some issue.

Are there any known issues with maybe XFS, or file corruption? Does 
anyone have an idea on how to figure out what the issue is?


Kernel:

Linux host 3.10.0-514.6.1.el7.x86_64 #1 SMP Wed Jan 18 13:06:36 UTC 2017 
x86_64 x86_64 x86_64 GNU/Linux

I compiled bcache as a module according to: 
http://10sa.com/sql_stories/?p=1052

BR
Thomas
