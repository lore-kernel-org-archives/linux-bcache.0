From: tang.junhui@zte.com.cn
Subject: Question of compatibility of bcache
Date: Fri, 24 Nov 2017 16:35:01 +0800
Message-ID: <1511512501-25890-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:56980 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752456AbdKXIe5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 03:34:57 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hi, everyone:

I create bcache device in 3.10 kernel with bcache of 3.10 kernel, and 
we had used it for while, then we backport upstream code to bcache of
3.10 kernel, and build a new kernel module to use in 3.10 kernel.

Is there any compatible issues. In other words, did bcache on-disk data 
have changed from 3.10 branch to hight branchs?  If I upgrade kernel, does
the bcache data produced in the old kernel still can work? 

Thanks,
Tang
