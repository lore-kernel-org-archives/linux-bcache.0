From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: bcache: for-next unable to handle kernel NULL pointer dereference
 at 0000000000000019
Date: Mon, 23 Oct 2017 16:26:39 +0200
Message-ID: <ee16f106-9bce-d33b-e8cc-acd6eeb94d10@profihost.ag>
References: <5cd9d4e9-88b2-c24b-f6ed-dad3f8b21283@profihost.ag>
 <4f1c616f-2e86-2cd3-162c-4ee7a3a02bf4@coly.li>
 <b3fe481a-67d7-1e70-1f52-0aa285dc48e7@profihost.ag>
 <08c770ef-eb09-ed55-a7bb-31b1b97a88d9@coly.li>
 <26bed6fb-d433-bcb7-4428-ed7b771f2def@profihost.ag>
 <ebfea14d-0fbd-00e0-d31b-54e1adfb2b80@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:35991 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751315AbdJWO0p (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Oct 2017 10:26:45 -0400
In-Reply-To: <ebfea14d-0fbd-00e0-d31b-54e1adfb2b80@coly.li>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

Hi,
Am 23.10.2017 um 16:00 schrieb Coly Li:
> On 2017/10/23 下午9:16, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> Am 23.10.2017 um 15:05 schrieb Coly Li:
>>> On 2017/10/23 下午8:59, Stefan Priebe - Profihost AG wrote:
>>>> Hi Coly,
>>>>
>>>>
>>>> Am 23.10.2017 um 14:56 schrieb Coly Li:
>>>>> On 2017/10/23 下午7:42, Stefan Priebe - Profihost AG wrote:
>>>>>> Hello,
>>>>>>
>>>>>> i picked all bcache patches from for-next to my 4.4 kernel to test the
>>>>>> new controller.
>>>>>>
>>>>>> After doing so i see random kernel panics with the following trace:
>>>>>
>>>>> Hi Stefan,
>>>>>
>>>>> Thanks for the report. This is the 3rd report I see recently for NULL
>>>>> pointer dereference, maybe they are related (or maybe not). Is it a
>>>>> panic when bcache starts to run, or during heavy workload ?
>>>>
>>>> It's during heavy / normal workload.
>>>>
>>>>> If I may have chance to trigger similar oops on my server, that will be
>>>>> much easier. So far I cannot reproduce any oops, neither by rebooting
>>>>> and assemble bcache device by udev rules, nor compose bcache device and
>>>>> run it by bash scripts...
>>>>
>>>> Do you need the line where this happens? It should be possible to get
>>>> the line from the IP: [<ffffffffc04ef62e>] output?
>>>>
>>> This is very helpful.
>>
>> May be i'm too stupid but it does not print anything useful:
>>
>> # addr2line -f -e
>> /usr/lib/debug/lib/modules/4.4.92+534-ph/kernel/drivers/md/bcache/bcache.ko
>> ffffffffc04ef62e closure_sub
>> ??
>> ??:0
>> bch_inc_gen
>> ??:?
>>
>>> Is it possible to get a kdump crash for the kernel
>>> oops, that will be much more informative :-)
>>
>> no idea how to archieve this for a remote Server.
> 
> Hi Stefan,
> 
> In code path of closure_wake_up(), I remember there are two patches in
> last run,
> - commit a5f3d8a5eaaf ("bcache: use llist_for_each_entry_safe() in
> __closure_wake_up()")
> - commit 09b3efec81de ("bcache: Don't reinvent the wheel but use
> existing llist API")
> 
> Can you check whether you have all of these patches ? Or can we try to
> revoke these two patches and see whether oops still happens.

It seems i'm missing a5f3d8a5eaaf but i have 09b3efec81de.

I missed it because
git log ..linux-block/for-next -- drivers/md/bcache/

does not show it. It seems linux-block/for-next does not contain it?
Which branch should i use?

Only those contain the mentioned commit:
  remotes/linux-block/for-linus
  remotes/linux-block/master
  remotes/linux-block/wbt-odirect

Greets,
Stefan

> 
> Thanks.
> 
