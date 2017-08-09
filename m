From: cgxu <cgxu@mykernel.net>
Subject: Re: very poor write performance in writeback mode
Date: Wed, 9 Aug 2017 23:49:00 +0800
Message-ID: <BD81FAE3-4C50-4F47-BAED-4B4046858A1A@mykernel.net>
References: <14A0EA53-A1CF-40DA-AE5C-18D3CC347A40@mykernel.net>
 <0c7403b6-2368-84a8-792d-4f77d97d8e9f@coly.li>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:38596 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753219AbdHIPtP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 9 Aug 2017 11:49:15 -0400
In-Reply-To: <0c7403b6-2368-84a8-792d-4f77d97d8e9f@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org

Hi Coly

Thanks for your quick reply. I’ve already solved this problem by updating kernel version to 3.18.63. So I think there must be a bug in old bcache code of 3.10 kernel version.



> 在 2017年8月9日，下午8:58，Coly Li <i@coly.li> 写道：
> 
> On 2017/8/9 下午3:09, cgxu wrote:
>> HI
>> 
>> I make bcache device using NVMe ssd device as cache and 4T SATA disk as backing device.
>> 
>> I found write performance is extremely poor in writeback cache_mode but raw ssd has very high performance.
>> 
>> I monitored io workload using iostat for a while, so I'm sure it really worked in writeback mode.
>> 
>> can anyone explain this problem？ Is there any compatible issue with special hardware?
> 
> 
> Could you please to provide exact steps to reproduce the poor
> performance situation ? When back ground writeback and garbage
> collection is performing, front end regular I/O (especially write I/O)
> performance is expected to downgrade.
> 
> 
> -- 
> Coly Li
> 
