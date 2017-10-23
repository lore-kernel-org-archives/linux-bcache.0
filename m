From: Coly Li <i@coly.li>
Subject: Re: bcache: for-next unable to handle kernel NULL pointer dereference
 at 0000000000000019
Date: Mon, 23 Oct 2017 21:05:24 +0800
Message-ID: <08c770ef-eb09-ed55-a7bb-31b1b97a88d9@coly.li>
References: <5cd9d4e9-88b2-c24b-f6ed-dad3f8b21283@profihost.ag>
 <4f1c616f-2e86-2cd3-162c-4ee7a3a02bf4@coly.li>
 <b3fe481a-67d7-1e70-1f52-0aa285dc48e7@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44250 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751331AbdJWNF3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Oct 2017 09:05:29 -0400
In-Reply-To: <b3fe481a-67d7-1e70-1f52-0aa285dc48e7@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-bcache@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

On 2017/10/23 下午8:59, Stefan Priebe - Profihost AG wrote:
> Hi Coly,
> 
> 
> Am 23.10.2017 um 14:56 schrieb Coly Li:
>> On 2017/10/23 下午7:42, Stefan Priebe - Profihost AG wrote:
>>> Hello,
>>>
>>> i picked all bcache patches from for-next to my 4.4 kernel to test the
>>> new controller.
>>>
>>> After doing so i see random kernel panics with the following trace:
>>
>> Hi Stefan,
>>
>> Thanks for the report. This is the 3rd report I see recently for NULL
>> pointer dereference, maybe they are related (or maybe not). Is it a
>> panic when bcache starts to run, or during heavy workload ?
> 
> It's during heavy / normal workload.
> 
>> If I may have chance to trigger similar oops on my server, that will be
>> much easier. So far I cannot reproduce any oops, neither by rebooting
>> and assemble bcache device by udev rules, nor compose bcache device and
>> run it by bash scripts...
> 
> Do you need the line where this happens? It should be possible to get
> the line from the IP: [<ffffffffc04ef62e>] output?
> 
This is very helpful. Is it possible to get a kdump crash for the kernel
oops, that will be much more informative :-)

Thanks.

-- 
Coly Li
