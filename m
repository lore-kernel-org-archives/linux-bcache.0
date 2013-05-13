From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] bcache: drop "select CLOSURES"
Date: Mon, 13 May 2013 10:35:21 +0200
Message-ID: <1368434121.1350.27.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

The Kconfig entry for BCACHE selects CLOSURES. But there's no Kconfig
symbol CLOSURES. That symbol was used in development versions of bcache,
but was removed when the closures code was no longer provided as a
kernel library. It can safely be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Basically untested.

 drivers/md/bcache/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index 05c220d..f950c9d 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -1,7 +1,6 @@
 
 config BCACHE
 	tristate "Block device as cache"
-	select CLOSURES
 	---help---
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.
-- 
1.7.11.7
