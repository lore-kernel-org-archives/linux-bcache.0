From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 20:42:20 +0100
Message-ID: <93a1e381-ea82-b5c0-444b-6bdd3062e7f0@profihost.ag>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
 <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li>
 <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
 <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org>
 <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:22184 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751273AbdKVTmW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 14:42:22 -0500
In-Reply-To: <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <i@coly.li>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi Coly,
  Hi Michael,


Am 22.11.2017 um 20:06 schrieb Stefan Priebe - Profihost AG:
> Am 22.11.2017 um 18:51 schrieb Michael Lyle:
>> Hi Coly, Stefan--
>>
>> On 11/22/2017 05:14 AM, Stefan Priebe - Profihost AG wrote:
>>>> Hi Stefan,
>>>>
>>>> Hmm, I don't have idea here. Anyway, is the cache mode set as writeback?
>>>> Recently I post a patch to fix a potential deadlock between writeback
>>>> rate update kworker and register code, I am not sure whether it is
>>>> relative to your issue, but at least we can have a try. the patch title is:
>>>>  [RFC] bcache: fix a circular dead locking with dc->writeback_lock and
>>>> bch_register_lock
>>>>
>>>> Just for your information.
>>>
>>> i can try that one - can you please resend? I can't find that mail and
>>> don't know how to grab that one our of the web html archives to apply
>>> correctly.
>>>
>>> Stefan
>>
>> I don't think there's any chance this patch will do anything.  If
>> there's a deadlock, the whole thing will become stuck forever and never
>> allow registration or progress on the device again-- which doesn't match
>> the symptoms here.
> 
> No it does not ;-)
> 
>> This probably relates to udev configuration in your environment somehow.

I found the problem the device is not detected as bcache by blkid - see
here:

'/sbin/blkid -o udev -p /dev/sdf1'(out) 'ID_FS_AMBIVALENT=other:bcache
other:xfs_external_log'

normally it looks like this:
'/sbin/blkid -o udev -p /dev/sdg1'(out) 'ID_FS_TYPE=bcache'

so instead of setting the FS_TYPE to bcache it's ID_FS_AMBIVALENT which
skips the bcache udev rules.

Just no idea how to fix that.

Stefan
