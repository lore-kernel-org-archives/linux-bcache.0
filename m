From: Coly Li <i@coly.li>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 21:29:10 +0800
Message-ID: <11ecba69-d19e-fe34-eef4-ba9f4de28d0e@coly.li>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
 <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li>
 <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:56744 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdKVN3P (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 08:29:15 -0500
In-Reply-To: <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 22/11/2017 9:14 PM, Stefan Priebe - Profihost AG wrote:
> Am 22.11.2017 um 13:57 schrieb Coly Li:
>> On 22/11/2017 8:26 PM, Stefan Priebe - Profihost AG wrote:
>>>
>>> Am 22.11.2017 um 13:16 schrieb Coly Li:
>>>> On 22/11/2017 7:23 PM, Stefan Priebe - Profihost AG wrote:
>>>>> Hello,
>>>>>
>>>>> i've 6 bcache blk devices attached to 3 caching ssds (2 each). One fails
>>>>> to register automatically at boot time.
>>>>>
>>>>> After reboot i always need to execute:
>>>>> echo /dev/sdf1 >/sys/fs/bcache/register
>>>>>
>>>>> to bring up the bcache device.
>>>>>
>>>>> Any idea?
>>>>
>>>> Hi Stefan,
>>>>
>>>> Is there any clue from kernel message ?
>>>
>>> Sadly not.
>>>
>>> Working one:
>>> ]# dmesg | grep sdi
>>> [    1.060377] sd 5:0:0:0: [sdi] 1953525168 512-byte logical blocks:
>>> (1.00 TB/932 GiB)
>>> [    1.060393] sd 5:0:0:0: [sdi] Write Protect is off
>>> [    1.060396] sd 5:0:0:0: [sdi] Mode Sense: 00 3a 00 00
>>> [    1.060425] sd 5:0:0:0: [sdi] Write cache: enabled, read cache:
>>> enabled, doesn't support DPO or FUA
>>> [    1.104341]  sdi: sdi1
>>> [    1.104644] sd 5:0:0:0: [sdi] Attached SCSI disk
>>> [    2.005452] bcache: register_bdev() registered backing device sdi1
>>> [    2.045211] bcache: bch_cached_dev_attach() Caching sdi1 as bcache0
>>> on set 76b95bf8-9cc7-407f-9f9e-a42b6d1bcb27
>>>
>>>
>>> not working one:
>>> # dmesg | grep sdf
>>> [    0.946107] sd 0:0:5:0: [sdf] 1953525168 512-byte logical blocks:
>>> (1.00 TB/932 GiB)
>>> [    1.400267] sd 0:0:5:0: [sdf] Write Protect is off
>>> [    1.400267] sd 0:0:5:0: [sdf] Mode Sense: 00 00 00 00
>>> [    1.401347] sd 0:0:5:0: [sdf] Write cache: enabled, read cache:
>>> enabled, supports DPO and FUA
>>> [    1.902910]  sdf: sdf1
>>> [    2.341289] sd 0:0:5:0: [sdf] Attached SCSI disk
>>> [  295.458804] bcache: register_bdev() registered backing device sdf1
>>> [  295.506656] bcache: bch_cached_dev_attach() Caching sdf1 as bcache5
>>> on set 76b95bf8-9cc7-407f-9f9e-a42b6d1bcb27
>>>
>>> At 295s i registeeed it manually.
>>
>> Hi Stefan,
>>
>> Hmm, I don't have idea here. Anyway, is the cache mode set as writeback?
>> Recently I post a patch to fix a potential deadlock between writeback
>> rate update kworker and register code, I am not sure whether it is
>> relative to your issue, but at least we can have a try. the patch title is:
>>  [RFC] bcache: fix a circular dead locking with dc->writeback_lock and
>> bch_register_lock
>>
>> Just for your information.
> 
> i can try that one - can you please resend? I can't find that mail and
> don't know how to grab that one our of the web html archives to apply
> correctly.

Hi Stefan,

Can you download the patch from following URL:
https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-patches.git/plain/for-test/0001-bcache-fix-a-circular-dead-locking-with-dc-writeback.patch

Coly Li
