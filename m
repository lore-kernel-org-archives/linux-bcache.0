From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: bcache deadlock
Date: Mon, 10 Aug 2015 16:51:32 +0200
Message-ID: <55C8BA74.2010001@profihost.ag>
References: <55BC6268.3060407@profihost.ag>
 <CAF1ivSY=+SDonyQdWntkyYWYhEgVrgzNLxdd7x1PVmKcyH2fGA@mail.gmail.com>
 <55BF096A.5070902@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:31428 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbbHJOvW (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 10 Aug 2015 10:51:22 -0400
In-Reply-To: <55BF096A.5070902@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Am 03.08.2015 um 08:25 schrieb Stefan Priebe - Profihost AG:
>
>
> Am 03.08.2015 um 08:21 schrieb Ming Lin:
>> On Fri, Jul 31, 2015 at 11:08 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
>>> Hi,
>>>
>>> any ideas about this deadlock:
>>> 2015-08-01 00:05:05     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>> disables this message.
>>> 2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
>>> 2015-08-01 00:05:05     INFO: task xfsaild/bcache5:2437 blocked for more
>>> than 120 seconds.
>>
>> No backtrace?
>>
>
> Yes, no backtrace.

Any chance or idea to fix this? This happens every day at a different 
server and is really annoying.

Stefan
