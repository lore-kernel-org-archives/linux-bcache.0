From: Pradeep Jindal <praddyjindal@gmail.com>
Subject: 84% -> 60% cache hit ratio for same workflow, different conf
Date: Mon, 28 Mar 2016 23:47:08 +0530
Message-ID: <CANEjr_S08oB9=3zcmBJktKTHH=NQwad95o2mfsxAeTPTgmL2YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37983 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbcC1SRK (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 28 Mar 2016 14:17:10 -0400
Received: by mail-ig0-f172.google.com with SMTP id a1so24187564igb.1
        for <linux-bcache@vger.kernel.org>; Mon, 28 Mar 2016 11:17:09 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I am facing a weird problem, I earlier had a configuration wherein my
backing device was a logical volume (LVM) backed by 3 software RAID0
arrays having 2x1TB disks each, so totally 6TB of storage for backing
device and 300GB logical volume (LVM) backed by SSD as a caching
device. Both were configured as a cache set and I was getting around
84% cache hit ratio.

Now, I have changed the backing device to a bare (no LVM, no raid) 6TB
disk while everything else stays same (caching device on LVM, 300GB)
and for exactly same workload I am only getting 58-60% cache hit
ratio.

I am confused, what could be the reason?

- Pradeep Jindal
