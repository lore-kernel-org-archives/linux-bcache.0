From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH] bcache: Add Michael Lyle to MAINTAINERS
Date: Thu, 12 Oct 2017 19:57:48 -0800
Message-ID: <20171013035748.20703-1-kent.overstreet@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:53627 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753377AbdJMD5y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Oct 2017 23:57:54 -0400
Received: by mail-qk0-f195.google.com with SMTP id y23so3594524qkb.10
        for <linux-bcache@vger.kernel.org>; Thu, 12 Oct 2017 20:57:54 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a74227ad08..2bb834cb9c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2562,6 +2562,7 @@ S:	Maintained
 F:	drivers/net/hamradio/baycom*
 
 BCACHE (BLOCK LAYER CACHE)
+M:	Michael Lyle <mlyle@lyle.org>
 M:	Kent Overstreet <kent.overstreet@gmail.com>
 L:	linux-bcache@vger.kernel.org
 W:	http://bcache.evilpiepirate.org
-- 
2.14.2
