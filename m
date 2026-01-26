Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29840548EE;
	Mon, 26 Jan 2026 01:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769391788; cv=none; b=Sjw1fagNDcUNj9r69F07REM39+QZuY0FUhdNj8GR6QN8OnxlK3a2ZdAVfdokilQwtB9LuOSFIDguy4xjuyG8EXF7lZ2aGygVKaZSPaieYRS8heBBFx63Q5L7yNi7YuATSNYw5q8DyK4Z1V5eWjXxb2MaXPrh88zDit7LBsL8dNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769391788; c=relaxed/simple;
	bh=TRIGx+YKua++c0XIAiTTqCJBRmND9zl7+Gk51A29Qwg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=D4q9PlsYoPn/Gs+KQZoQQX5kEz1xuHrdeiP1BHqxrBvxdzsSBg8dINAoleI426Jv4DbPot+BCd0RiNca8k/8HF8MI5nzq+QtQvWPV9YzC0kz6D0pjy2sgua8q8PppWfoqT7RZl9sCAe9RgUV821UVMzkKpK1JlRqKCiBVcqgXA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BP8zddBI; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BP8zddBI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=pVXMEdptMg0BDo4t965tTwv2ot7VEA+h0HjCIKSOk2I=;
	b=BP8zddBIrsNM7NK9jsG+T4GRi+DDPJUdeZJBuNW6YaKC+KZYj5eJUwlQZkBGce
	RZ3OFuIwkdNWkOtPFAf9/5+A09CyXa38TrJQdzxXWd025bgkxdAbW9qpUdb+iR4g
	Oue6fhjOF5ZafiasiQVxxDQ0qOWwE8EZSjAEnn4UARi4Q=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wAnZNp7xnZpJLbpIQ--.831S2;
	Mon, 26 Jan 2026 09:42:21 +0800 (CST)
From: zhangshida2026@163.com
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	hch@infradead.org,
	axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH] bcache: fix I/O accounting leak in detached_dev_do_request
Date: Mon, 26 Jan 2026 09:42:09 +0800
Message-Id: <20260126014209.909491-1-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnZNp7xnZpJLbpIQ--.831S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cry5JF1kGF1fKr18Zry7Wrg_yoW8WF4Upr
	4kurWYkrZYqa10qrWxCa1UGF1rtws7try3Xr48tw4Uurs5JFZ0ywsIga45Xr17WFZ7CFZ7
	AFnYqrZrua15tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b8pnQUUUUU=
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbCvx3I1Gl2xn2VVgAA3Z

From: Shida Zhang <zhangshida@kylinos.cn>

When a bcache device is in a detached state, iostat can show 100%
utilization even after I/O workload completion.

This happens because the caller, cached_dev_submit_bio(), calls
bio_start_io_acct() to begin accounting. However, if the bio hits an
early exit path in detached_dev_do_request()—either due to an
unsupported discard request or a bio_alloc_clone() failure—the
corresponding bio_end_io_acct() is never called. This leaves the
in-flight counter permanently incremented, causing the kernel to
report the device as 100% busy.

Add the missing bio_end_io_acct() calls to these error/early-exit
paths to ensure proper I/O accounting.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/md/bcache/request.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index a02aecac05c..7d855e66a10 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,6 +1107,7 @@ static void detached_dev_do_request(struct bcache_device *d,
 
 	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
 	    !bdev_max_discard_sectors(dc->bdev)) {
+		bio_end_io_acct(orig_bio, start_time);
 		bio_endio(orig_bio);
 		return;
 	}
@@ -1114,6 +1115,7 @@ static void detached_dev_do_request(struct bcache_device *d,
 	clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
 				    &d->bio_detached);
 	if (!clone_bio) {
+		bio_end_io_acct(orig_bio, start_time);
 		orig_bio->bi_status = BLK_STS_RESOURCE;
 		bio_endio(orig_bio);
 		return;
-- 
2.34.1

