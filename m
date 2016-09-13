From: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>
Subject: [PATCH v2 3/4] Make --help and man more consistent
Date: Tue, 13 Sep 2016 12:55:43 +0200
Message-ID: <1473764144-18993-3-git-send-email-marcin@mejor.pl>
References: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:49854 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755336AbcIMK4g (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Sep 2016 06:56:36 -0400
In-Reply-To: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>

Options displayed by `bcache format --help` wasn't accepted by bcache. Man bcache is a little bit more descriptive
now.

Signed-off-by: Marcin Mirosław <marcin@mejor.pl>
---
 bcache-format.c | 20 ++++++++++----------
 bcache.8        | 13 +++++++------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/bcache-format.c b/bcache-format.c
index 1b20b55..c092344 100644
--- a/bcache-format.c
+++ b/bcache-format.c
@@ -75,23 +75,23 @@ static void usage(void)
 	     "Usage: bcache format [OPTION]... <devices>\n"
 	     "\n"
 	     "Options:\n"
-	     "  -b, --block=size\n"
-	     "      --btree_node=size       Btree node size, default 256k\n"
-	     "      --metadata_checksum_type=(none|crc32c|crc64)\n"
-	     "      --data_checksum_type=(none|crc32c|crc64)\n"
-	     "      --compression_type=(none|lz4|gzip)\n"
+	     "  -b, --block=size in bytes               default is highest block size from all formated devices\n"
+	     "      --btree_node_size=size in bytes     Btree node size, default and max supported 256k\n"
+	     "      --metadata_checksum_type=           (none|crc32c [default]|crc64)\n"
+	     "      --data_checksum_type=               (none|crc32c [default]|crc64)\n"
+	     "      --compression_type=                 (none [default]|lz4|gzip)\n"
 	     "      --encrypted\n"
-	     "      --error_action=(continue|readonly|panic)\n"
-	     "                              Action to take on filesystem error\n"
-	     "  -l, --label=label\n"
-	     "      --uuid=uuid\n"
+	     "      --error_action=                     (continue|readonly [default]|panic)\n"
+	     "                                    Action to take on filesystem error\n"
+	     "  -L, --label=label\n"
+	     "  -U, --uuid=uuid\n"
 	     "  -f, --force\n"
 	     "\n"
 	     "Device specific options:\n"
 	     "      --fs_size=size          Size of filesystem on device\n"
 	     "      --bucket=size           bucket size\n"
 	     "      --discard               Enable discards\n"
-	     "  -t, --tier=#                tier of subsequent devices\n"
+	     "  -t, --tier=#                tier level of subsequent devices\n"
 	     "\n"
 	     "  -h, --help                  display this help and exit\n"
 	     "\n"
diff --git a/bcache.8 b/bcache.8
index 7671cf3..14aae3e 100644
--- a/bcache.8
+++ b/bcache.8
@@ -64,12 +64,13 @@ List the bcache commands
 .SH Global options:
 .TP
 .BR \-w,\ --block=
-block size, in bytes (e.g. 4k)
+block size, in bytes (e.g. 4096) - default is highest block size from all formated devices
 .TP
-.BR \-w,\ --btree_node_size=
-btree node size in bytes - default 256k
+.BR \--btree_node_size=
+btree node size in bytes - default and maximum is 256k
 .TP
 .BR \--metadata_checksum_type=TYPE
+where TYPE is one of none, crc32c (default), or crc64
 .TP
 .BR \--data_checksum_type=TYPE
 where TYPE is one of none, crc32c (default), or crc64
@@ -83,10 +84,10 @@ Enable encryption; passphrase will be prompted for
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
@@ -98,7 +99,7 @@ filesystem
 .BR \--fs_size=SIZE
 Create the filesystem using SIZE bytes on the subsequent device
 .TP
-.BR \-b\ --bucket-size=SIZE
+.BR \--bucket-size=SIZE
 Specifies the bucket size - must be greater than the btree node size
 .TP
 .BR \-t,\ --tier=INDEX
-- 
2.7.3
