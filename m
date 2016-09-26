From: Eric Wheeler <git@linux.ewheeler.net>
Subject: [PATCH 2/2] bcache: documentation for ioprio cache hinting
Date: Mon, 26 Sep 2016 16:32:44 -0700
Message-ID: <S1751690AbcIZXgs/20160926233648Z+17414@vger.kernel.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:54920 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753243AbcIZXgq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Sep 2016 19:36:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.ewheeler.net (Postfix) with ESMTP id 1888CA0C52
        for <linux-bcache@vger.kernel.org>; Mon, 26 Sep 2016 16:36:46 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
        by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id SxUMoWYjrpjt for <linux-bcache@vger.kernel.org>;
        Mon, 26 Sep 2016 16:36:45 -0700 (PDT)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id 6DFEFA0C51
        for <linux-bcache@vger.kernel.org>; Mon, 26 Sep 2016 16:36:45 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
---
 Documentation/bcache.txt | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
index a9259b5..c87d73f 100644
--- a/Documentation/bcache.txt
+++ b/Documentation/bcache.txt
@@ -133,6 +133,31 @@ the backing devices to passthrough mode.
    writeback mode). It currently doesn't do anything intelligent if it fails to
    read some of the dirty data, though.
 
+PER-PROCESS CACHE HINTING BY PRIORITY
+-------------------------------------
+
+Processes can be assigned an IO priority using `ionice` and bcache will
+either try to writeback or bypass the cache based on the IO priority
+level assigned to the process.
+
+Cache hinting is configurable by writing 'class,level' pairs to sysfs.
+These are the defaults:
+    echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
+    echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback
+
+By default, Linux assigns processes the best-effort class with a class
+level of 4.  Thus, if you do nothing, your default processes will follow
+the original bcache should_writeback/should_bypass logic.
+
+	(-p) IO Class    (-n) Class level       Action
+	-----------------------------------------------------
+	(1) Realtime      0-7                   Writeback
+	(2) Best-effort     0                   Writeback
+	(2) Best-effort   1-6                   Original bcache logic
+	(2) Best-effort     7                   Bypass cache
+	(3) Idle          n/a                   Bypass cache
+
+See `man ionice` for more detail about process IO priority in Linux.
 
 HOWTO/COOKBOOK
 --------------
-- 
1.8.3.1
