Received: from mail-m1973185.qiye.163.com (mail-m1973185.qiye.163.com [220.197.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F652F60CC
	for <linux-bcache@vger.kernel.org>; Thu,  2 Apr 2026 13:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775135055; cv=none; b=ir8CjPyPm98RlKnBkpTKD5tGROWMUXP4D0yToIpuGl/nDSYi3DAo7BB0P1PXk0SfyUfY74LpP47MY3hfP1bYRFZPw7e990tF2jT5wXL+wP6Cep/QUnuUgzfM7yKp5g+2FmHsnXmpCi3ttm8LbxiS8SxjGzO8B5pa6Ijtu1J5mBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775135055; c=relaxed/simple;
	bh=IGhmG1XpML9nElhg8tnXX9c1OHS7sAvOMl5HP8KAuFo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e2GZLFbJMB8VWpq7qXx9IAEfoYQ2PRnSwy9GM8TYHBTHMUbS8Irp5C7PN+dXvVq0CnJYG+r9it0v0uXDzh+U/Oi7J0WAMbQGult7at4xNZNWVvftC9AlwOb254VQ0ElDLOYdU84DLiHEVRwTh9+qyDvOUaMqxWXszsu8NUNQ8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=220.197.31.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 186f4c1e6;
	Thu, 2 Apr 2026 21:03:58 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@kernel.org,
	colyli@fnnas.com
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com,
	zoumingzhe@outlook.com,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: [PATCH] bcache: fix uninitialized closure object
Date: Thu,  2 Apr 2026 21:03:53 +0800
Message-Id: <20260402130353.1099802-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d4e4b1c3e022bkunma7e266f08c55af
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDHRlPVkwZGUJKQxkaSRhMTVYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+

From: Mingzhe Zou <zoumingzhe@qq.com>

In the previous patch(bcache: fix cached_dev.sb_bio use-after-free and crash),
we adopted a simple modification suggestion from AI to fix the use-after-free.

But in actual testing, we found an extreme case where the device is stopped
before calling bch_write_bdev_super().

At this point, struct closure sb_write has not been initialized yet.

For this patch, we ensure that sb_bio has been completed via sb_write_mutex.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 6627a381f65a..97d9adb0bf96 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1378,7 +1378,8 @@ static CLOSURE_CALLBACK(cached_dev_free)
 	 * The sb_bio is embedded in struct cached_dev, so we must
 	 * ensure no I/O is in progress.
 	 */
-	closure_sync(&dc->sb_write);
+	down(&dc->sb_write_mutex);
+	up(&dc->sb_write_mutex);
 
 	if (dc->sb_disk)
 		folio_put(virt_to_folio(dc->sb_disk));
-- 
2.34.1

