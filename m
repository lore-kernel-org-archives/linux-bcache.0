From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: bcache using in case of 5 hdd disks
Date: Thu, 23 Jan 2014 23:26:19 +0400
Message-ID: <CACaajQvHG=Y-ZywBYi6sNbxEDb1wXOWYLsLJGyNLSL84PYHgxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:57021 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaAWT0h (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 23 Jan 2014 14:26:37 -0500
Received: by mail-qa0-f50.google.com with SMTP id cm18so2699858qab.23
        for <linux-bcache@vger.kernel.org>; Thu, 23 Jan 2014 11:26:34 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all.
I'm very happy with bcache on current production system (raid1 with 1
sata hdd + 1 ssd). But now i get new platform with 5 sata hdd and 1
ssd disk.
Each of sata hdd i need to format with some fs (ext4 or btrfs?) to
store data. How can i use bcache in this case? I'm unerstand that i
can create5 partitions on ssd drive and use each partition to each
drive. But does it possible to use whole ssd disk to cache in this
case?

Thanks!

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
