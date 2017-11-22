From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 21:36:08 +0100
Message-ID: <91e9b95d-861e-13bb-2b61-5c010657c2af@profihost.ag>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
 <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li>
 <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
 <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org>
 <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
 <93a1e381-ea82-b5c0-444b-6bdd3062e7f0@profihost.ag>
 <73e9184b-c74b-fe92-bb87-a0b945931187@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:25060 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751260AbdKVUgL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 15:36:11 -0500
In-Reply-To: <73e9184b-c74b-fe92-bb87-a0b945931187@lyle.org>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <i@coly.li>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>


Am 22.11.2017 um 21:22 schrieb Michael Lyle:
> Hey Stefan--
> 
> On 11/22/2017 11:42 AM, Stefan Priebe - Profihost AG wrote:
>> I found the problem the device is not detected as bcache by blkid - see
>> here:
>>
>> '/sbin/blkid -o udev -p /dev/sdf1'(out) 'ID_FS_AMBIVALENT=other:bcache
>> other:xfs_external_log'
>>
>> normally it looks like this:
>> '/sbin/blkid -o udev -p /dev/sdg1'(out) 'ID_FS_TYPE=bcache'
>>
>> so instead of setting the FS_TYPE to bcache it's ID_FS_AMBIVALENT which
>> skips the bcache udev rules.
>>
>> Just no idea how to fix that.
>>
>> Stefan
> 
> Good find.  Can you send me the first 8k of /dev/sdf1?  I'll poke at it
> (no promises though).

Yes will send in seperate mail.

> 
> Mike
> 
