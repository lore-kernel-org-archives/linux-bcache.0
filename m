From: Arne Wiebalck <Arne.Wiebalck@cern.ch>
Subject: [PATCH] bcache: amend writeback_rate documentation
Date: Wed, 18 Jun 2014 12:13:32 +0200
Message-ID: <1403086412-18310-1-git-send-email-Arne.Wiebalck@cern.ch>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cernmx14.cern.ch ([188.184.36.16]:32235 "EHLO CERNMX14.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039AbaFRKSv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Jun 2014 06:18:51 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Arne Wiebalck <Arne.Wiebalck@cern.ch>

From: Arne Wiebalck <Arne.Wiebalck@cern.ch>

The writeback_rate is displayed in bytes per sec, but needs to
be set in sectors per sec. This patch amends the documentation
accordingly.
---
 Documentation/bcache.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
index 32b6c31..5643751 100644
--- a/Documentation/bcache.txt
+++ b/Documentation/bcache.txt
@@ -268,9 +268,9 @@ writeback_percent
   the rate.
 
 writeback_rate
-  Rate in sectors per second - if writeback_percent is nonzero, background
+  Rate in bytes per second - if writeback_percent is nonzero, background
   writeback is throttled to this rate. Continuously adjusted by bcache but may
-  also be set by the user.
+  also be set by the user (in sectors per second).
 
 writeback_running
   If off, writeback of dirty data will not take place at all. Dirty data will
-- 
1.8.3.2.634.g7a3187e
