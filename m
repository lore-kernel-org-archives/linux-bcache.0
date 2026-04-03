Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C62D3ED2
	for <linux-bcache@vger.kernel.org>; Fri,  3 Apr 2026 04:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775190101; cv=none; b=Gm6hdc0S4QOtCXi2cyX+u05yXDCuo/eD0g/0ES14pbzKxN5/T2XfXOWoUnNngVlLP92LGoOrengi5R/h84HIpYZrjkjfYNlNyrO+BUl47aJMxRto0mIIlOd5Ly+91BQJWh+0UU8fAXWTBz//CHpOF8yhz7FA932rCqheajhRqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775190101; c=relaxed/simple;
	bh=31vkg1U43IWqyJCYrxzrgFLEKvEfIyOt55RETjjjAb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UD97lY7etDpQULcdXQPLBvdL7XwLy04MmvlmVdOd2srIwEaD4aqqzDXogVpFKhRzZ9EXvDe+rutvqksngKIZy63D9xFY3F9yJz6RedW2fiDWYQ1k3AaoFeWgCrzZdylbt3awj4sytQtw1J/Iok13wPi0l0dSENDegU0igkQG1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAC6C4CEF7;
	Fri,  3 Apr 2026 04:21:39 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-block@vger.kerenl.org,
	linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH] bcache: fix uninitialized closure object
Date: Fri,  3 Apr 2026 12:21:35 +0800
Message-ID: <20260403042135.2221247-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
crash"), we adopted a simple modification suggestion from AI to fix the
use-after-free.

But in actual testing, we found an extreme case where the device is
stopped before calling bch_write_bdev_super().

At this point, struct closure sb_write has not been initialized yet.
For this patch, we ensure that sb_bio has been completed via
sb_write_mutex.

(Coly Li refines the commit log.)

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 5005a26af363..5380a44ef721 100644
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
2.47.3

