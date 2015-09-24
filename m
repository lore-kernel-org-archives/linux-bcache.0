From: Christopher James Halse Rogers <raof@ubuntu.com>
Subject: [PATCH] md: also update raid5 for bio changes.
Date: Thu, 24 Sep 2015 10:03:28 +1000
Message-ID: <1443053008-16672-1-git-send-email-raof@ubuntu.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.cooperteam.net ([150.101.105.211]:40196 "EHLO
	mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbbIXAJP (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 23 Sep 2015 20:09:15 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Christopher James Halse Rogers <raof@ubuntu.com>

This should be squashed with 2dc77339620123a838f41f1ad21b81cd6473f9b1 in the next rebase
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 15ef2c6..ff230b3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4851,7 +4851,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 		unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
 
 		if (sectors < bio_sectors(raid_bio)) {
-			split = bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);
+			split = bio_split(raid_bio, sectors, GFP_NOIO, &fs_bio_set);
 			bio_chain(split, raid_bio);
 		} else
 			split = raid_bio;
-- 
2.5.0
