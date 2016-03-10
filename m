From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: Bcache still unstable for me (memory problems)
Date: Thu, 10 Mar 2016 16:41:09 +0100
Message-ID: <56E19595.5010208@evilazrael.de>
References: <CA+nZN+i0fmEc0Uz1X5k0DJaNB_sNu2EP0dEUy32_ipsW66MFmA@mail.gmail.com>
 <alpine.LRH.2.11.1603090344040.15354@mail.ewheeler.net>
 <alpine.LRH.2.11.1603100125110.13488@mail.ewheeler.net>
 <20160310021516.GM14112@merlins.org> <20160310152958.GR14112@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from evilazrael.net ([5.10.172.2]:49406 "EHLO mail.evilazrael.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbcCJPlN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Mar 2016 10:41:13 -0500
In-Reply-To: <20160310152958.GR14112@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
Cc: linux-bcache@vger.kernel.org


Am 10.03.2016 um 16:29 schrieb Marc MERLIN:
> On Wed, Mar 09, 2016 at 06:15:16PM -0800, Marc MERLIN wrote:
>> On Thu, Mar 10, 2016 at 01:34:56AM +0000, Eric Wheeler wrote:
>>> Hi Richard, Marc,
>>>
>>>>>> [290623.673871] bcache-register: page allocation failure: order:7, mode:0x24080c0
>>> Do you still have the backtraces that show the function call stack for
>>> errors that look like this?
>>> 	%s: page allocation failure: order:%d, mode:0x%x
>>>
>>> Please send as many relevant OOM failure traces that you can.  I would
>>> like to see which memory allocation(s) are failing and if they are always
>>> the same stack trace.
>>   
>> It's the same one I already sent you, just from syslog instead of serial
>> console (I was looking for other relevant cronjobs or errors per your
>> request)
>   
>
> gargamel:~# cat /proc/meminfo
> MemTotal:       24392440 kB
> Mlocked:        120259089404 kB
> VmallocTotal:   34359738367 kB
>
> Thanks,
> Marc

Just out of curiosity, how can 112TB be in the state mlocked on a 24GB 
machine?

Regards

Christoph
