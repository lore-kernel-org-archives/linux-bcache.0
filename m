From: Michael Lyle <mlyle@lyle.org>
Subject: [PATCH 15/15] bcache: MAINTAINERS: set bcache to MAINTAINED
Date: Fri, 13 Oct 2017 16:35:42 -0700
Message-ID: <20171013233542.20938-16-mlyle@lyle.org>
References: <20171013233542.20938-1-mlyle@lyle.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171013233542.20938-1-mlyle@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com, Michael Lyle <mlyle@lyle.org>
List-Id: linux-bcache@vger.kernel.org

Also add URL for IRC channel.

Signed-off-by: Michael Lyle <mlyle@lyle.org>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 73213039bdb7..b3203e082a1e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2568,7 +2568,8 @@ M:	Michael Lyle <mlyle@lyle.org>
 M:	Kent Overstreet <kent.overstreet@gmail.com>
 L:	linux-bcache@vger.kernel.org
 W:	http://bcache.evilpiepirate.org
-S:	Orphan
+C:	irc://irc.oftc.net/bcache
+S:	Maintained
 F:	drivers/md/bcache/
 
 BDISP ST MEDIA DRIVER
-- 
2.11.0
