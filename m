From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: bcache deadlock
Date: Mon, 03 Aug 2015 08:25:46 +0200
Message-ID: <55BF096A.5070902@profihost.ag>
References: <55BC6268.3060407@profihost.ag> <CAF1ivSY=+SDonyQdWntkyYWYhEgVrgzNLxdd7x1PVmKcyH2fGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:57513 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbbHCGZs (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 3 Aug 2015 02:25:48 -0400
In-Reply-To: <CAF1ivSY=+SDonyQdWntkyYWYhEgVrgzNLxdd7x1PVmKcyH2fGA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>



Am 03.08.2015 um 08:21 schrieb Ming Lin:
> On Fri, Jul 31, 2015 at 11:08 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
>> Hi,
>>
>> any ideas about this deadlock:
>> 2015-08-01 00:05:05     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> 2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
>> 2015-08-01 00:05:05     INFO: task xfsaild/bcache5:2437 blocked for more
>> than 120 seconds.
> 
> No backtrace?
> 

Yes, no backtrace.

Stefan
