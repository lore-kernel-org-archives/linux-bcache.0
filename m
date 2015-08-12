From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: bcache deadlock
Date: Wed, 12 Aug 2015 15:57:47 +0200
Message-ID: <55CB50DB.5000604@profihost.ag>
References: <55BC6268.3060407@profihost.ag>	<CAF1ivSY=+SDonyQdWntkyYWYhEgVrgzNLxdd7x1PVmKcyH2fGA@mail.gmail.com>	<55BF096A.5070902@profihost.ag>	<55C8BA74.2010001@profihost.ag> <CA+res+RR6g4VSMOBs_qBSuaWO5z6Sukjm_BQZStDq6gwN=zbDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:43320 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbHLN5t (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 12 Aug 2015 09:57:49 -0400
In-Reply-To: <CA+res+RR6g4VSMOBs_qBSuaWO5z6Sukjm_BQZStDq6gwN=zbDw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: Ming Lin <mlin@kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,
Am 12.08.2015 um 15:39 schrieb Jack Wang:
> Have you checked on the server when this deadlock happened?
> 
> From my experience, you will get a trace for the warning.

sadly there is no trace as it seems the kworker is running in an endless
loop.

I don't have the abbility to login - the system is running with a load
of 2000 or even 3000.

From the logs i've gathered the following informations:

top with running processes shows only kworker running on 100% CPU.

top - 15:02:31 up 10 days, 16:20,  1 user,  load average: 2494,67,
1878,69, 905,
Tasks: 226 total,   2 running, 222 sleeping,   0 stopped,   2 zombie
%Cpu(s):  0,9 us, 12,7 sy,  0,0 ni, 36,4 id, 50,0 wa,  0,0 hi,  0,0 si,
 0,0 st
KiB Mem:  49431532 total, 48672808 used,   758724 free,       52 buffers
KiB Swap:  3906556 total,   152772 used,  3753784 free, 40328600 cached

  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
21963 root      20   0     0    0    0 R 100,5  0,0   9:15.48
[kworker/u16:3]
29978 root      20   0 62488  20m 6892 S   8,0  0,0   0:02.59
/usr/bin/python /

iotop shows the same kworker permanently writing with > 1400MB/s.

Total DISK READ:       0.00 B/s | Total DISK WRITE:       0.00 B/s
  PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
29978 be/4 root        0.00 B/s   14.69 K/s  0.00 %  0.00 % python
/usr/sbin/iotop -b -d 1 -n 30 -P
21963 be/4 root        0.00 B/s 1428.89 M/s  0.00 %  0.00 % [kworker/u16:3]

To me this looks like an endless loop which could also explain why there
is no stack trace.

Greets,
Stefan

> 
> 2015-08-10 16:51 GMT+02:00 Stefan Priebe <s.priebe@profihost.ag>:
>> Am 03.08.2015 um 08:25 schrieb Stefan Priebe - Profihost AG:
>>>
>>>
>>>
>>> Am 03.08.2015 um 08:21 schrieb Ming Lin:
>>>>
>>>> On Fri, Jul 31, 2015 at 11:08 PM, Stefan Priebe <s.priebe@profihost.ag>
>>>> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> any ideas about this deadlock:
>>>>> 2015-08-01 00:05:05     "echo 0 >
>>>>> /proc/sys/kernel/hung_task_timeout_secs"
>>>>> disables this message.
>>>>> 2015-08-01 00:05:05     Tainted: G O 3.18.19+47-ph #1
>>>>> 2015-08-01 00:05:05     INFO: task xfsaild/bcache5:2437 blocked for more
>>>>> than 120 seconds.
>>>>
>>>>
>>>> No backtrace?
>>>>
>>>
>>> Yes, no backtrace.
>>
>>
>> Any chance or idea to fix this? This happens every day at a different server
>> and is really annoying.
>>
>>
>> Stefan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
