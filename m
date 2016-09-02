From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: [PATCH] made consistent displayed help and manpage with options
 acepted by bcache
Date: Fri, 2 Sep 2016 14:24:44 +0200
Message-ID: <822ea882-4c6c-2fe0-2434-91be528df726@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:64702 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752507AbcIBMZM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 2 Sep 2016 08:25:12 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi!

This patch fix misleading in name of options in manpage and displayed
help. But still remains in manpage unimplemented options like "stats" or
"status". I don't kno how to handle it, remove?

diff --git a/bcache-format.c b/bcache-format.c
index 1b20b55..d71ae68 100644
--- a/bcache-format.c
+++ b/bcache-format.c
@@ -75,16 +75,16 @@ static void usage(void)
             "Usage: bcache format [OPTION]... <devices>\n"
             "\n"
             "Options:\n"
-            "  -b, --block=size\n"
-            "      --btree_node=size       Btree node size, default 256k\n"
+            "  -b, --block=size      default 4k\n"
+            "      --btree_node_size=size       Btree node size,
default 256k\n"
             "      --metadata_checksum_type=(none|crc32c|crc64)\n"
             "      --data_checksum_type=(none|crc32c|crc64)\n"
             "      --compression_type=(none|lz4|gzip)\n"
             "      --encrypted\n"
             "      --error_action=(continue|readonly|panic)\n"
             "                              Action to take on filesystem
error\n"
-            "  -l, --label=label\n"
-            "      --uuid=uuid\n"
+            "  -L, --label=label\n"
+            "  -U, --uuid=uuid\n"
             "  -f, --force\n"
             "\n"
             "Device specific options:\n"
diff --git a/bcache.8 b/bcache.8
index 7671cf3..5092f00 100644
--- a/bcache.8
+++ b/bcache.8
@@ -64,9 +64,9 @@ List the bcache commands
 .SH Global options:
 .TP
 .BR \-w,\ --block=
-block size, in bytes (e.g. 4k)
+block size, in bytes (e.g. 4096) - default 4k
 .TP
-.BR \-w,\ --btree_node_size=
+.BR \--btree_node_size=
 btree node size in bytes - default 256k
 .TP
 .BR \--metadata_checksum_type=TYPE
@@ -83,10 +83,10 @@ Enable encryption; passphrase will be prompted for
 .BR \--error_action=TYPE
 where TYPE is one of continue, readonly (default) or panic
 .TP
-.BR \-l\ --label=LABEL
+.BR \-L\ --label=LABEL
 Create the filesystem with the specified label
 .TP
-.BR \--uuid=UUID
+.BR \-U\ --uuid=UUID
 Create the filesystem with the specified UUID
 .TP
 .BR \--force
@@ -98,7 +98,7 @@ filesystem
 .BR \--fs_size=SIZE
 Create the filesystem using SIZE bytes on the subsequent device
 .TP
-.BR \-b\ --bucket-size=SIZE
+.BR \--bucket-size=SIZE
 Specifies the bucket size - must be greater than the btree node size
 .TP
 .BR \-t,\ --tier=INDEX
