From: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>
Subject: [PATCH 4/4] Make output message more human friendly
Date: Fri,  9 Sep 2016 15:28:40 +0200
Message-ID: <1473427720-1350-4-git-send-email-marcin@mejor.pl>
References: <20160904043611.6nw2vjhs3j2cnnqm@kmo-pixel>
 <1473427720-1350-1-git-send-email-marcin@mejor.pl>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:7176 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbcIINbA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 09:31:00 -0400
In-Reply-To: <1473427720-1350-1-git-send-email-marcin@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>

---
 libbcache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libbcache.c b/libbcache.c
index f17bd4a..3a915e9 100644
--- a/libbcache.c
+++ b/libbcache.c
@@ -200,16 +200,16 @@ void bcache_format(struct dev_opts *devs, size_t nr_devs,
 		       "Set UUID:		%s\n"
 		       "version:		%u\n"
 		       "nbuckets:		%llu\n"
-		       "block_size:		%u\n"
-		       "bucket_size:		%u\n"
+		       "block_size (bytes):	%u\n"
+		       "bucket_size (bytes):	%u\n"
 		       "nr_in_set:		%u\n"
 		       "nr_this_dev:		%u\n"
 		       "first_bucket:		%u\n",
 		       uuid_str, set_uuid_str,
 		       (unsigned) sb->version,
 		       __le64_to_cpu(m->nbuckets),
-		       __le16_to_cpu(sb->block_size),
-		       __le16_to_cpu(m->bucket_size),
+		       __le16_to_cpu(sb->block_size)*512,
+		       __le16_to_cpu(m->bucket_size)*512,
 		       sb->nr_in_set,
 		       sb->nr_this_dev,
 		       __le16_to_cpu(m->first_bucket));
-- 
2.7.3
