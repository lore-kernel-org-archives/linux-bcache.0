From: Eric Wheeler <git@linux.ewheeler.net>
Subject: [PATCH 3/3] bcache: dmesg: meaningful error message when nr_stripes
 is invalid
Date: Tue, 5 Apr 2016 20:47:49 -0700
Message-ID: <S1754334AbcFPR0i/20160616172639Z+53@vger.kernel.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:37785 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966AbcFPR0i (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 16 Jun 2016 13:26:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id A0BEAA0F4A
	for <linux-bcache@vger.kernel.org>; Thu, 16 Jun 2016 10:21:12 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id rbwkvkDDp_eQ for <linux-bcache@vger.kernel.org>;
	Thu, 16 Jun 2016 10:21:12 -0700 (PDT)
Received: from 23-95-35-21-host.colocrossing.com (unknown [23.95.35.21])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id E7D54A0F4C
	for <linux-bcache@vger.kernel.org>; Thu, 16 Jun 2016 10:21:11 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a296425..de6c492 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -759,7 +759,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	if (!d->nr_stripes ||
 	    d->nr_stripes > INT_MAX ||
 	    d->nr_stripes > SIZE_MAX / sizeof(atomic_t)) {
-		pr_err("nr_stripes too large");
+		pr_err("nr_stripes invalid: %u (start sector beyond end of disk?)",
+			(unsigned)d->nr_stripes);
 		return -ENOMEM;
 	}
 
-- 
1.8.3.1
