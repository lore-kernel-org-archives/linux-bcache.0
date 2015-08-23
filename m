From: Mike Krinkin <krinkin.m.u@gmail.com>
Subject: bcache-tools build errors
Date: Sun, 23 Aug 2015 21:38:56 +0300
Message-ID: <20150823183856.GA3212@kmu-tp-x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34000 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbHWSjB (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 23 Aug 2015 14:39:01 -0400
Received: by lbbtg9 with SMTP id tg9so68561748lbb.1
        for <linux-bcache@vger.kernel.org>; Sun, 23 Aug 2015 11:38:59 -0700 (PDT)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com
Cc: linux-bcache@vger.kernel.org

Hi,

after bcachefs announce i decided to try it and downloaded
bcache-tools dev branch as explained here
http://bcache.evilpiepirate.org/, and failed to build it with
gcc 4.9.2 (Ubuntu 4.9.2-0ubuntu1~14.04), the following fix solved
problem for me:

diff --git a/bcacheadm-query.c b/bcacheadm-query.c
index e11b98d..6e3499c 100644
--- a/bcacheadm-query.c
+++ b/bcacheadm-query.c
@@ -303,7 +303,7 @@ int cmd_status(NihCommand *command, char *const *args)
 
 			buf[len] = '\0';
 			dev_names[dev_count] = dev_name(buf);
-			snprintf(dev_path, MAX_PATH, "%s/%s", "/dev",
+			snprintf(dev_path, sizeof(dev_path), "%s/%s", "/dev",
 					dev_names[dev_count]);
 			sb = query_dev(dev_path, false, false,
 					true, dev_uuid);
@@ -331,7 +331,7 @@ int cmd_status(NihCommand *command, char *const *args)
 		int j;
 
 		uuid_unparse(m->uuid.b, uuid_str);
-		snprintf(dev_state, MAX_PATH, "%s",
+		snprintf(dev_state, sizeof(dev_state), "%s",
                          cache_state[CACHE_STATE(m)]);
 
 		for (j = 0; j < dev_count; j++) {
@@ -339,7 +339,7 @@ int cmd_status(NihCommand *command, char *const *args)
 				break;
 			} else if (j == dev_count - 1) {
 				if (!strcmp(cache_state[CACHE_STATE(m)], "active"))
-					snprintf(dev_state, MAX_PATH, "%s", "missing");
+					snprintf(dev_state, sizeof(dev_state), "%s", "missing");
 				break;
 			}
 		}
diff --git a/probe-bcache.c b/probe-bcache.c
index 1b85c4a..cc04f53 100644
--- a/probe-bcache.c
+++ b/probe-bcache.c
@@ -8,7 +8,7 @@
 #define __USE_FILE_OFFSET64
 #define _XOPEN_SOURCE 500
 
-#include <blkid.h>
+#include <blkid/blkid.h>
 #include <fcntl.h>
 #include <linux/fs.h>
 #include <stdbool.h>

I don't know what the problem is with blkid headers, but MAX_PATH
is 256 while dev_path and dev_state only 32 bytes long. Although
it would scarcely cause any problems, with -Werror flag gcc turns
warning into error.

I hope bcache mailing list is right place to report things like
this.
