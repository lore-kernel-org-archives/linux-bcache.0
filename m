From: cgxu <cgxu@mykernel.net>
Subject: very poor write performance in writeback mode
Date: Wed, 9 Aug 2017 15:09:39 +0800
Message-ID: <14A0EA53-A1CF-40DA-AE5C-18D3CC347A40@mykernel.net>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpbg299.qq.com ([184.105.67.99]:51910 "EHLO smtpbg299.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752008AbdHIHQv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 9 Aug 2017 03:16:51 -0400
Received: from [172.17.46.165] (unknown [122.224.77.194])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <linux-bcache@vger.kernel.org>; Wed, 09 Aug 2017 15:09:39 +0800 (CST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

HI

I make bcache device using NVMe ssd device as cache and 4T SATA disk as backing device.

I found write performance is extremely poor in writeback cache_mode but raw ssd has very high performance.

I monitored io workload using iostat for a while, so I'm sure it really worked in writeback mode.

can anyone explain this problem£¿ Is there any compatible issue with special hardware?
