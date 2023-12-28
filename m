Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB226129;
	Thu, 28 Dec 2023 07:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y49WPhuj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hX9CA1F/gZTSSUEPUcjUUVKeYYM6YHvLgIrnJbMOHpQ=; b=Y49WPhujPsQGPIbmImVmP4ADcj
	XUgG243FeVpoCRp4PjZTzFz24B2O5wIWK5OaUdIid+1L9JR2bbYN4+p+1ItqSmNzh0OCgyY8vzEDn
	AG59xDdyNMk4ypzuhlbgDKkwRRh9gSbxLp8lvslLyEHsParQEm5H4z/q7fF6qFqmnqZonRfmFR4O/
	JdUU8txaV0hQtfEvgLTH1mL/1Bzm1KaHW8zHJxVmVFcOpu3oiDTUraHRcQdPXcykxwzfycRuKHSPU
	OUHbY5nAZ6Hdlh9p5l1o8oVw18ZuOujrPCOkbYfcE5SuQ5VP8aDc8r8WFmF5B3amXbgWZLqu+1SGV
	CEPqSkMQ==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlFj-00GN0p-2v;
	Thu, 28 Dec 2023 07:56:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	linux-bcache@vger.kernel.org,
	linux-mtd@lists.infradead.org
Subject: [PATCH 7/9] zram: use the default discard granularity
Date: Thu, 28 Dec 2023 07:55:43 +0000
Message-Id: <20231228075545.362768-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231228075545.362768-1-hch@lst.de>
References: <20231228075545.362768-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The discard granularity now defaults to a single sector, so don't set
that value explicitly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d77d3664ca0805..e1dec0483a012b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2227,7 +2227,6 @@ static int zram_add(void)
 					ZRAM_LOGICAL_BLOCK_SIZE);
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
-	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
 	blk_queue_max_discard_sectors(zram->disk->queue, UINT_MAX);
 
 	/*
-- 
2.39.2

