From: wangyijing <wangyijing@huawei.com>
Subject: question about writeback data
Date: Fri, 21 Apr 2017 10:49:51 +0800
Message-ID: <58F9734F.5010109@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2071 "EHLO
        dggrg05-dlp.huawei.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1034574AbdDUC4E (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Apr 2017 22:56:04 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all, recently I read bcache writeback related codes, and found there is no flush send
during writeback flow, after a bio complete, write_dirty_finish() be called, and free the
meta key in cache devices, if a sudden poweroff happen, the data cached in backing device cache may lost, right?

Thanks!
Yijing.
