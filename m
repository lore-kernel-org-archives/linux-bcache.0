From: Donald Pearson <donaldwhpearson@gmail.com>
Subject: change/recreate cache device?
Date: Fri, 3 Jul 2015 15:25:17 -0500
Message-ID: <CAC=t97ATr7fd-_4_14vggBVqvprnKWHDMny6TknQ5DdqBeS_xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33337 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbbGCUZh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Jul 2015 16:25:37 -0400
Received: by oiyy130 with SMTP id y130so84298399oiy.0
        for <linux-bcache@vger.kernel.org>; Fri, 03 Jul 2015 13:25:36 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

This is my first crack at bcache and I configured a cache device with
defaults using make-bcache -C /dev/sda

Now I've got better info on my SSD and know what the block and bucket
sizes should be, however I can't run the command again with errors
that the device is busy.

I never did anythign beyond just creating the cache and backing
devices.  I never registered the cache device, never created a
filesystem.
