Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FED2C08D5;
	Mon, 26 Jan 2026 09:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769419863; cv=none; b=DJq/RKEEtQFrvVk84bQwVWtsm3+bcKDMZVX0u4BGh5xrCuOGGexBpQZAM4u2IYt9eu4A6NDpruCvaEnhFfXTi9CXAkbCm0V56nrv+YioJmzKl27XGKEi7nSX8TmCXKA9XC7ySzNjtgHXMmrfglS2xkOb5662Nz3zhhuuarsSmxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769419863; c=relaxed/simple;
	bh=mzPwNXUV4ZxWLlHZJ2N1AOTqwXswP61wSZorg3if+Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=P/zmNf0YOJpj4cd6TnHDkWJsMMvGxlpNeQ/rCErEmHcR3V7XbcDXZ1YfHWL9EeY6D31E1AEBsQFeArP6UbphiGgYyjeWydnvts/VLa7MOuCLbuVTEAPQUIBlcoycUZb5aU0jKDxkQmS3bJQVWuL4N+v//TvvoLrCUkmfbrJYB0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AjkEfbpC; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AjkEfbpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=fQJjArBs8z4tpzw6q1tGtcVC4Pkq36oY3aaUpPrwt3Q=;
	b=AjkEfbpCfaO460noH9G4mDKqGwgt5cRqozvlx1vqte8Xq/C3rIkNRS/JRUvS0a
	QjwpsqwJkiJiwx8eb2R/LaqYZ3bprxfScJEp9lzyNC0TkeAwKsRI2ek9TjR5h5d1
	UPp/anLzgcmwyCUcIzgDykorCEpXQ5dcibwHu6Aa1mZSI=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3bqzjM3dp5S1NMg--.89S2;
	Mon, 26 Jan 2026 17:29:12 +0800 (CST)
From: zhangshida2026@163.com
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	hch@infradead.org,
	axboe@kernel.dk,
	osandov@fb.com,
	bvanassche@acm.org
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2] bcache: fix I/O accounting leak in detached_dev_do_request
Date: Mon, 26 Jan 2026 17:28:54 +0800
Message-Id: <20260126092854.971870-1-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgD3bqzjM3dp5S1NMg--.89S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cry5JF1kGF1fKr18JF43Jrb_yoW8AF1xpr
	48urWYkrZYqa18JFW8Aa1UJF1rtwsrtry3Xr48tw4UZrs5AFWqvwsIg3W5Xr13uFZ7CFZ2
	yFnYqFWDu3Z8tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bjo7NUUUUU=
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC6Ag-S2l3M+jNVwAA3L

From: Shida Zhang <zhangshida@kylinos.cn>

When a bcache device is in a detached state, iostat can show 100%
utilization even after I/O workload completion.

This happens because the caller, cached_dev_make_request(), calls
bio_start_io_acct() to begin accounting. However, if the bio hits an
early exit path in detached_dev_do_request()—either due to an
unsupported discard request or a bio_alloc_clone() failure—the
corresponding bio_end_io_acct() is never called. This leaves the
in-flight counter permanently incremented, causing the kernel to
report the device as 100% busy.

Add the missing bio_end_io_acct() calls to these error/early-exit
paths to ensure proper I/O accounting.

Fixes: d62e26b3ffd28 ("block: pass in queue to inflight accounting")
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Acked-by: Coly Li <colyli@fnnas.com>
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

