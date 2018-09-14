From: Dongbo Cao <cdbdyx@163.com>
Subject: [PATCH 2/2] add some safety checks for label store interface of flash dev in sysfs
Date: Fri, 14 Sep 2018 18:12:59 +0800
Message-ID: <20180914101259.4169-1-cdbdyx@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: colyli@suse.de
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Dongbo Cao <cdbdyx@163.com>
List-Id: linux-bcache@vger.kernel.org

do some checks on the label's length and ending.

Signed-off-by: Dongbo Cao <cdbdyx@163.com>
---
 drivers/md/bcache/sysfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index e64c718f..cce793ef 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -447,8 +447,15 @@ STORE(__bch_flash_dev)
 	}
 
 	if (attr == &sysfs_label) {
+		if (size > SB_LABEL_SIZE)
+			return -EINVAL;
 		memcpy(u->label, buf, SB_LABEL_SIZE);
-		bch_uuid_write(d->c);
+		if (size < SB_LABEL_SIZE)
+			u->label[size] = '\0';
+		if (size && u->label[size - 1] == '\n')
+			u->label[size - 1] = '\0';
+		if(d->c)
+			bch_uuid_write(d->c);
 	}
 
 	if (attr == &sysfs_unregister) {
-- 
2.17.1
