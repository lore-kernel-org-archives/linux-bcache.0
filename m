Return-Path: <SRS0=TEko=7J=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880D4C433E0
	for <linux-bcache@archiver.kernel.org>; Wed, 27 May 2020 05:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67167207ED
	for <linux-bcache@archiver.kernel.org>; Wed, 27 May 2020 05:25:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qEEJ85Hr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgE0FZf (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 27 May 2020 01:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729018AbgE0FYu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 01:24:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D28C061A0F;
        Tue, 26 May 2020 22:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=j/0fX6heLmqRakQA7qi+pziHK3sxFOca3+bsUnfP3dI=; b=qEEJ85HrX/zM1/Qp5PJTXizQe7
        ZMMBhaQjqwnkthh3OZVxds1+2PrSQ796RMv/+Q/FfoufYwyx6FKNS3NBFKHmq9jozRy4mFuvz3Kfh
        ROIennB5z9rigcC/EwdEaFNyXpTXfL5xo+oQAncGXo4/RObBt0w1a9ONcbH7PGi1zPWYGpOd57xLh
        6tqtFZtPokO3Cp6QWTR7CHKsOo3krfH97u71KzF0ZygcY2QXY6+u6k8CjL8HL18Eel3OnWtEnlWb/
        gp2Xl4aA9IpMx6Jo5JubP6EhkoUpK8KNW4YLscSnBEkcO4+JtaoxmoPaojxK1dzCW8MGjuktoPlBY
        cFB700Uw==;
Received: from [2001:4bb8:18c:5da7:8164:affc:3c20:853d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdoYY-0000qw-W9; Wed, 27 May 2020 05:24:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] block: remove generic_{start,end}_io_acct
Date:   Wed, 27 May 2020 07:24:12 +0200
Message-ID: <20200527052419.403583-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org
Message-ID: <20200527052412.3cYA991HDtHssI7B3n8Oj5sFGD1YwD_rShcN3Rnic_4@z>

Remove these now unused functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 block/bio.c         | 39 ---------------------------------------
 include/linux/bio.h |  6 ------
 2 files changed, 45 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 9c101a0572ca2..3e89c7b37855a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1392,45 +1392,6 @@ void update_io_ticks(struct hd_struct *part, unsigned long now, bool end)
 	}
 }
 
-void generic_start_io_acct(struct request_queue *q, int op,
-			   unsigned long sectors, struct hd_struct *part)
-{
-	const int sgrp = op_stat_group(op);
-	int rw = op_is_write(op);
-
-	part_stat_lock();
-
-	update_io_ticks(part, jiffies, false);
-	part_stat_inc(part, ios[sgrp]);
-	part_stat_add(part, sectors[sgrp], sectors);
-	part_stat_local_inc(part, in_flight[rw]);
-	if (part->partno)
-		part_stat_local_inc(&part_to_disk(part)->part0, in_flight[rw]);
-
-	part_stat_unlock();
-}
-EXPORT_SYMBOL(generic_start_io_acct);
-
-void generic_end_io_acct(struct request_queue *q, int req_op,
-			 struct hd_struct *part, unsigned long start_time)
-{
-	unsigned long now = jiffies;
-	unsigned long duration = now - start_time;
-	const int sgrp = op_stat_group(req_op);
-	int rw = op_is_write(req_op);
-
-	part_stat_lock();
-
-	update_io_ticks(part, now, true);
-	part_stat_add(part, nsecs[sgrp], jiffies_to_nsecs(duration));
-	part_stat_local_dec(part, in_flight[rw]);
-	if (part->partno)
-		part_stat_local_dec(&part_to_disk(part)->part0, in_flight[rw]);
-
-	part_stat_unlock();
-}
-EXPORT_SYMBOL(generic_end_io_acct);
-
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 950c9dc44c4f2..941378ec5b39f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -444,12 +444,6 @@ void bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 
-void generic_start_io_acct(struct request_queue *q, int op,
-				unsigned long sectors, struct hd_struct *part);
-void generic_end_io_acct(struct request_queue *q, int op,
-				struct hd_struct *part,
-				unsigned long start_time);
-
 extern void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
 			       struct bio *src, struct bvec_iter *src_iter);
 extern void bio_copy_data(struct bio *dst, struct bio *src);
-- 
2.26.2

