From: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>
Subject: [PATCH v2 4/4] Remove unimplemented options from manpage
Date: Tue, 13 Sep 2016 12:55:44 +0200
Message-ID: <1473764144-18993-4-git-send-email-marcin@mejor.pl>
References: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:49854 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755668AbcIMK4i (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Sep 2016 06:56:38 -0400
In-Reply-To: <1473764144-18993-1-git-send-email-marcin@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: =?UTF-8?q?Marcin=20Miros=C5=82aw?= <marcin@mejor.pl>

I'm removing remainders from bcache - block device cache.

Signed-off-by: Marcin Mirosław <marcin@mejor.pl>
---
 bcache.8 | 43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/bcache.8 b/bcache.8
index 14aae3e..ddb41cd 100644
--- a/bcache.8
+++ b/bcache.8
@@ -109,46 +109,3 @@ two tiers are supported.
 .TP
 .BR \--discard
 Enable discards on subsequent devices
-
-.SH Options for register
-
-.SH Options for list-cachesets
-.TP
-.BR \-d,\ --dir=
-Provide a directory other than /sys/fs/bcache
-
-.SH Options for query-devs
-.TP
-.BR \-f,\ --force-csum
-Enables bcache to going even if the superblock crc is invalid
-
-.SH Options for status
-
-.SH Options for stats
-.TP
-.BR \-a,\ --all
-List all stats and their values for the given device.
-.TP
-.BR \-l,\ --list
-List the names of the different stats for the given device.
-.TP
-.BR \-u,\ --set=
-UUID for the cacheset
-.TP
-.BR \-d,\ --dev=
-UUID for a device within the cacheset. Must pass in the cacheset UUID in order to search for a dev.
-.TP
-.BR \-c,\ --cache=
-Cache number, starts from 0
-.TP
-.BR \--five-min-stats
-stats accumulated in the last 5 minutes
-.TP
-.BR \--hour-stats
-stats accumulated in the last hour
-.TP
-.BR \--day-stats
-stats accumulated in the last day
-.TP
-.BR \--total-stats
-stats accumulated in total
-- 
2.7.3
