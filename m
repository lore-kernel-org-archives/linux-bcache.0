From: Coly Li <colyli@suse.de>
Subject: Input requirement for persistent configuration items in bcache
Date: Mon, 22 Jun 2020 16:01:22 +0800
Message-ID: <fed4334c-6521-7f6f-712c-495975e9b1b7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729484AbgFVO0r (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jun 2020 10:26:47 -0400
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73B58C1C7
        for <linux-bcache@vger.kernel.org>; Mon, 22 Jun 2020 14:26:43 +0000 (UTC)
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi folks,

Recently I start to look at the bcache on-disk superblock extension. I
still remember years ago people discussed adding some persistent
configuration itesm on disk, to avoid setting them via sysfs interface
every time after reboot.

While I am thinking about this, I do appreciate your help about the
input on which configuration item should be stored in the on-disk
superblock.

Although I am probably not able to make every required input being
persistent in the on-disk superblock, I believe your help may help me to
decide a reasonable option set.

Thank you all in advance.

Coly Li
