Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17296C433DB
	for <linux-bcache@archiver.kernel.org>; Sat, 27 Feb 2021 02:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2B5864DAF
	for <linux-bcache@archiver.kernel.org>; Sat, 27 Feb 2021 02:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhB0Chh (ORCPT <rfc822;linux-bcache@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:37:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13093 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhB0ChU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Feb 2021 21:37:20 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DnVwC64mkz16B0g
        for <linux-bcache@vger.kernel.org>; Sat, 27 Feb 2021 10:34:19 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Feb 2021
 10:35:47 +0800
To:     <linux-bcache@vger.kernel.org>, Coly Li <colyli@suse.de>
CC:     linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "lijinlin (A)" <lijinlin3@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] bcache-tools: check whether allocating memory fails in tree()
Message-ID: <655607db-abc7-3241-cf14-e6efbec8331a@huawei.com>
Date:   Sat, 27 Feb 2021 10:35:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


In tree(), we do not check whether malloc() returns NULL,
it may cause potential Null pointer dereference problem.
In addition, when we fail to list devices, we should free(out)
before return.

Signed-off-by: ZhiqiangLiu <lzhq28@mail.ustc.edu.cn>
---
 bcache.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/bcache.c b/bcache.c
index 044d401..1c4cef9 100644
--- a/bcache.c
+++ b/bcache.c
@@ -174,7 +174,7 @@ void replace_line(char **dest, const char *from, const char *to)

 int tree(void)
 {
-	char *out = (char *)malloc(4096);
+	char *out;
 	const char *begin = ".\n";
 	const char *middle = "├─";
 	const char *tail = "└─";
@@ -184,8 +184,15 @@ int tree(void)
 	INIT_LIST_HEAD(&head);
 	int ret;

+	out = (char *)malloc(4096);
+	if (out == NULL) {
+		fprintf(stderr, "Error: fail to allocate memory buffer\n");
+		return 1;
+	}
+
 	ret = list_bdevs(&head);
 	if (ret != 0) {
+		free(out);
 		fprintf(stderr, "Failed to list devices\n");
 		return ret;
 	}
-- 
2.30.0


