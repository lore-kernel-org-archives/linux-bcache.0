From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Bcache on btrfs: the perfect setup or the perfect storm?
Date: Wed, 8 Apr 2015 08:59:52 +0200
Message-ID: <CAK1hC9v9ADdguR+frFPix02U2u-+fuJgaV-cJi0F55fOfeECtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36563 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbDHG7y (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 8 Apr 2015 02:59:54 -0400
Received: by lbbqq2 with SMTP id qq2so51180153lbb.3
        for <linux-bcache@vger.kernel.org>; Tue, 07 Apr 2015 23:59:52 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I plan to setup Bcache on  Btrfs SSD/HD caching/backing device. The
box will be a server, but not a production one.

I know this scheme is not recommended and can be a cause of filesystem
corruption. But as I like living on the edge, I want to give a try,
with a tight backup policy.

Any advice? Any settings that could be worth to avoid future drama?

Thank you

-- 

google.com/+arnaudgabourygabx
