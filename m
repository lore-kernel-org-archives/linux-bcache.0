From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: bcache deadlock
Date: Wed, 12 Aug 2015 15:39:11 +0200
Message-ID: <CA+res+RR6g4VSMOBs_qBSuaWO5z6Sukjm_BQZStDq6gwN=zbDw@mail.gmail.com>
References: <55BC6268.3060407@profihost.ag>
	<CAF1ivSY=+SDonyQdWntkyYWYhEgVrgzNLxdd7x1PVmKcyH2fGA@mail.gmail.com>
	<55BF096A.5070902@profihost.ag>
	<55C8BA74.2010001@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34945 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbbHLNjM (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 12 Aug 2015 09:39:12 -0400
Received: by igbjg10 with SMTP id jg10so42890384igb.0
        for <linux-bcache@vger.kernel.org>; Wed, 12 Aug 2015 06:39:11 -0700 (PDT)
In-Reply-To: <55C8BA74.2010001@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Ming Lin <mlin@kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Have you checked on the server when this deadlock happened?

From my experience, you will get a trace for the warning.

2015-08-10 16:51 GMT+02:00 Stefan Priebe <s.priebe@profihost.ag>:
> Am 03.08.2015 um 08:25 schrieb Stefan Priebe - Profihost AG:
>>
>>
>>
>> Am 03.08.2015 um 08:21 schrieb Ming Lin:
>>>
>>> On Fri, Jul 31, 2015 at 11:08 PM, Stefan Priebe <s.priebe@profihost.ag>
>>> wrote:
>>>>
>>>> Hi,
>>>>
>>>> any ideas about this deadlock:
>>>> 2015-08-01 00:05:05     "echo 0 >
>>>> /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> 2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
>>>> 2015-08-01 00:05:05     INFO: task xfsaild/bcache5:2437 blocked for more
>>>> than 120 seconds.
>>>
>>>
>>> No backtrace?
>>>
>>
>> Yes, no backtrace.
>
>
> Any chance or idea to fix this? This happens every day at a different server
> and is really annoying.
>
>
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
