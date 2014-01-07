From: Josep Lladonosa <jlladono@gmail.com>
Subject: About physically swapping backing and cache device
Date: Tue, 7 Jan 2014 09:52:50 +0100
Message-ID: <CAPBO7TYjki0s4-cMxS1ztvO=WT-8+ScH6mfZrE+YkTLuFcBqAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57673 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaAGIwv (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 7 Jan 2014 03:52:51 -0500
Received: by mail-oa0-f43.google.com with SMTP id m1so2374496oag.2
        for <linux-bcache@vger.kernel.org>; Tue, 07 Jan 2014 00:52:50 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hello,


I have been using bcache for some months. Now I am with 3.12.6 kernel
(stable! :)
Thanks and congratulations for the good work.

I have in the laptop this configuration:

/dev/sda7 as backing device (hard drive partition)
/dev/sdb as cache device (SSD)

1) I would like to physically swap sda and sdb (a matter of different
bus speeds) in order to improve ata speed for SSD. The fact is that in
a case of this, would I have to "reregister" anything in bcache, or it
will run referenced to UUIDs and so?

2) I think I would have to install GRUB into /dev/sdb (it has no
partitions defined). Would it be safe installing GRUB in a cache
device? Future configuration would be /dev/sda for the cache (SSD) and
/dev/sdb for the backing device (hard drive).



-- 
--
Salutacions...Josep
--
