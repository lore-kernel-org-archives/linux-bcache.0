From: Michael Lyle <mlyle@lyle.org>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 13:10:02 -0800
Message-ID: <e2acf9c9-9097-e24c-69dd-a56ec672f9ef@lyle.org>
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
 <0ab9bd3f-f2ea-04d7-1416-941b3d93d410@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36079 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdKVVKE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 16:10:04 -0500
Received: by mail-pf0-f194.google.com with SMTP id i15so12603300pfa.3
        for <linux-bcache@vger.kernel.org>; Wed, 22 Nov 2017 13:10:04 -0800 (PST)
In-Reply-To: <0ab9bd3f-f2ea-04d7-1416-941b3d93d410@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Coly Li <i@coly.li>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 11/22/2017 01:07 PM, Stefan Priebe - Profihost AG wrote:
> default debian jessie version:
> # blkid -v
> blkid from util-linux 2.25.2  (libblkid 2.25.0, 24-Oct-2014)

OK, so it's ancient.

One other thing that can get you-- if there was ever an xfs or other
filesystem on this disk -without- bcache, then you created bcache & xfs
on it without wipefs... the old superblock can still be hanging around
and not having happened to been rewritten.

Mike

> 
>>
>> Mike
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
