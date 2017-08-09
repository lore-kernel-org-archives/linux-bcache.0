From: Coly Li <i@coly.li>
Subject: Re: very poor write performance in writeback mode
Date: Wed, 9 Aug 2017 20:58:57 +0800
Message-ID: <0c7403b6-2368-84a8-792d-4f77d97d8e9f@coly.li>
References: <14A0EA53-A1CF-40DA-AE5C-18D3CC347A40@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:32886 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752510AbdHIM7G (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 9 Aug 2017 08:59:06 -0400
In-Reply-To: <14A0EA53-A1CF-40DA-AE5C-18D3CC347A40@mykernel.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: linux-bcache@vger.kernel.org

On 2017/8/9 下午3:09, cgxu wrote:
> HI
> 
> I make bcache device using NVMe ssd device as cache and 4T SATA disk as backing device.
> 
> I found write performance is extremely poor in writeback cache_mode but raw ssd has very high performance.
> 
> I monitored io workload using iostat for a while, so I'm sure it really worked in writeback mode.
> 
> can anyone explain this problem？ Is there any compatible issue with special hardware?


Could you please to provide exact steps to reproduce the poor
performance situation ? When back ground writeback and garbage
collection is performing, front end regular I/O (especially write I/O)
performance is expected to downgrade.


-- 
Coly Li
