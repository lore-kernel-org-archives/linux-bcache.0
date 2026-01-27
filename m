Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AB4253F11;
	Tue, 27 Jan 2026 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769502138; cv=none; b=YLOKw9StG5NsIKVwmgyP6DUBq6/3G/lMz+mOUHi78qpe3p13eZgmUzJMDK3ZolMsGJ/XPi5WAaz3XoGg2ZCcrnQb/GYDi24ZiBTg0jTE11fBjcns5CPekNENThwf0UHQbqBQxe5yjCZ2yYqtglJyUBssGREZSYj3BYFzMu9xKCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769502138; c=relaxed/simple;
	bh=ii7k+yFRQA5XVmrgDWli8t0vbgib669xUbv2uR82EU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dv3dn/Y2DjY4FGIVvvdwMyebMYMvGpgLghyKkPv/6szZPDsDYVa3G6QfxtxOGL+ugBMP0fGtZevygwYa5XFNzhIUE7BbqZWYISS1DxVEZ/FRPru4PhAzU6UkBzSkT+BIHfatbDswE+ffTPYdcV5KeUgyBqEviLOZ+urxENq07Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=YUYtDZKX; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="YUYtDZKX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ta
	DxY4ABIuPT9P92qKp0GFjidC5G/11g07EqR2xd3ao=; b=YUYtDZKXiWtp2HMXWV
	RC1wSSOv6oRFi8fCQsX3fKeP2dR9fOp+gTFFj7WUlXaWPy+rzOncvR8lqqkZqHqa
	w9jN3bORQ8nFdcF4WhvfnfIAshve522TPHu0ZEucNA3irT4KjNx8SU9i4qKgTcHu
	sNI2wmBXpnsVZwwTfqROWJPU8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXP3iHdXhpOByCHw--.7542S3;
	Tue, 27 Jan 2026 16:21:35 +0800 (CST)
From: zhangshida2026@163.com
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	hch@infradead.org,
	axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 1/2] bcache: remove dead code in detached_dev_do_request
Date: Tue, 27 Jan 2026 16:21:11 +0800
Message-Id: <20260127082112.1114158-2-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260127082112.1114158-1-zhangshida2026@163.com>
References: <20260127082112.1114158-1-zhangshida2026@163.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXP3iHdXhpOByCHw--.7542S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFW3Aw1rtFWkGF4DWrWUtwb_yoWfuwb_ua
	1rZFn7W398Gw1ruFsFyr18ArWj93WqgF90qr4DtFyft343uwn7WryFvr15t3yrur4xCF4x
	Jw15Gw15CryvkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYYzutUUUUU==
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbCvw-4BWl4dY9ClgAA3y

From: Shida Zhang <zhangshida@kylinos.cn>

bio_alloc_clone() with GFP_NOIO and a mempool will not return NULL.
Remove the unnecessary NULL check.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/md/bcache/request.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index a02aecac05c..c2f38907a2a 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1113,11 +1113,6 @@ static void detached_dev_do_request(struct bcache_device *d,
 
 	clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
 				    &d->bio_detached);
-	if (!clone_bio) {
-		orig_bio->bi_status = BLK_STS_RESOURCE;
-		bio_endio(orig_bio);
-		return;
-	}
 
 	ddip = container_of(clone_bio, struct detached_dev_io_private, bio);
 	/* Count on the bcache device */
-- 
2.34.1

