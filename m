Return-Path: <SRS0=5amZ=CL=vger.kernel.org=linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1B9C433E7
	for <linux-bcache@archiver.kernel.org>; Wed,  2 Sep 2020 12:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F17DF2078B
	for <linux-bcache@archiver.kernel.org>; Wed,  2 Sep 2020 12:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIBMPB (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 2 Sep 2020 08:15:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:41896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgIBMOt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Sep 2020 08:14:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 98C93ADE0
        for <linux-bcache@vger.kernel.org>; Wed,  2 Sep 2020 12:14:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [PATCH 2/2] bcache-tools: add man page bcache-status.8
Date:   Wed,  2 Sep 2020 20:14:35 +0800
Message-Id: <20200902121435.85166-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200902121435.85166-1-colyli@suse.de>
References: <20200902121435.85166-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Add the initial man page for bcache-status.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache-status.8 | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 bcache-status.8

diff --git a/bcache-status.8 b/bcache-status.8
new file mode 100644
index 0000000..f56cfb6
--- /dev/null
+++ b/bcache-status.8
@@ -0,0 +1,47 @@
+.TH bcache-status 8
+.SH NAME
+bcache-status \- Display useful bcache statistics
+
+.SH SYNOPSIS
+.B bcache-status [ --help ] [ -f ] [ -h ] [ -d ] [ -t ] [ -a ] [ -r ] [ -s ] [ -g ]
+
+.SH DESCRIPTION
+This command displays useful bcache statistics in a convenient way.
+
+.SH OPTIONS
+
+.TP
+.BR \-\-help
+Print help message and exit.
+
+.TP
+.BR \-f ", " \-\-five\-minute
+Print the last five minutes of stats.
+
+.TP
+.BR \-h ", " \-\-hour
+Print the last hour of stats.
+
+.TP
+.BR \-d ", " \-\-day
+Print the last day of stats.
+
+.TP
+.BR \-t ", " \-\-total
+Print total stats.
+
+.TP
+.BR \-a ", " \-\-all
+Print all stats.
+
+.TP
+.BR \-r ", " \-\-reset\-stats
+Reset stats after printing them.
+
+.TP
+.BR \-s ", " \-\-sub\-status
+Print subdevice status.
+
+.TP
+.BR \-g ", " \-\-gc
+Invoke GC before printing status (root only).
-- 
2.26.2

