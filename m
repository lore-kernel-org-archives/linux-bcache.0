From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 22:10:48 +0100
Message-ID: <32714083-db95-0837-5dcd-e863a833b89d@profihost.ag>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
 <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li>
 <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
 <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org>
 <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
 <93a1e381-ea82-b5c0-444b-6bdd3062e7f0@profihost.ag>
 <73e9184b-c74b-fe92-bb87-a0b945931187@lyle.org>
 <91e9b95d-861e-13bb-2b61-5c010657c2af@profihost.ag>
 <864cbf6d-7e8d-7dd4-7417-3150fe019fd8@lyle.org>
 <3fde77da-e12f-7862-f3c5-2a3dad316b86@profihost.ag>
 <0387447a-cce1-4162-3458-03193e146732@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:12270 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751303AbdKVVKu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 16:10:50 -0500
In-Reply-To: <0387447a-cce1-4162-3458-03193e146732@lyle.org>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <i@coly.li>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>


Am 22.11.2017 um 22:03 schrieb Michael Lyle:
> On 11/22/2017 12:56 PM, Stefan Priebe - Profihost AG wrote:
>>
>> Am 22.11.2017 um 21:44 schrieb Michael Lyle:
>>> On 11/22/2017 12:36 PM, Stefan Priebe - Profihost AG wrote:
>>>> Am 22.11.2017 um 21:22 schrieb Michael Lyle:
>>> mlyle@midnight:~/Downloads$ blkid 8k
>>> 8k: UUID="65811163-4ffc-4823-ad72-bae10ce85b63" TYPE="bcache"
>>> mlyle@midnight:~/Downloads$ blkid --version
>>> blkid from util-linux 2.30.1  (libblkid 2.30.1, 20-Jul-2017)
>>>
>>> I don't understand, it seems OK.
>> i think i remember that the xfs external log superblock is NOT at the
>> beginning. Not sure where it is and yes there's an XFS on top of bcache...
>>
>> Greets,
>> Stefan
> 
> It shouldn't be an issue because: A) blkid should "favor" bcache, and B)
> the other filesystem data structures should be offset and not at the
> position that blkid will be looking for them.  Can you check your blkid
> version?

If you strace blkid you see that it seeks several positions and reads them.

Exmaple:
read(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
4096) = 4096
lseek(3, 0, SEEK_SET)                   = 0
read(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024
lseek(3, 1024, SEEK_SET)                = 1024
read(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024
lseek(3, 1048576, SEEK_SET)             = 1048576
read(3,
"ABTB\0\0\1\36\0\0\1\310\0\0\0\215\0029\335\334\0\0\0070\0029\355\f\0\0\4\0"...,
1024) = 1024
lseek(3, 3072, SEEK_SET)                = 3072
read(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024
lseek(3, 7168, SEEK_SET)                = 7168
read(3,
"\0\0\232\352\0\0\0\26\0\0\233\301\0\0\0\20\0\0\234\21\0\0\0\34\0\0\234.\0\0\0\1"...,
1024) = 1024
lseek(3, 15360, SEEK_SET)               = 15360
read(3,
"\0\0'\353\0\0\0\1\0\0'\353\0\0\0\1\0\0'\353\0\0\0\1\0\0'\353\0\0\0\1"...,
1024) = 1024
lseek(3, 31744, SEEK_SET)               = 31744
read(3,
"\0\10\340\346\0\0\0\30\0\10\340\346\0\0\0\30drmtwsS0l\n1gKn80"...,
1024) = 1024
lseek(3, 64512, SEEK_SET)               = 64512
read(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024
lseek(3, 0, SEEK_SET)                   = 0
mmap(NULL, 266240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7efe60612000
read(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
262144) = 262144
lseek(3, 393216, SEEK_SET)              = 393216

> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
