From: Michael Lyle <mlyle@lyle.org>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 12:44:47 -0800
Message-ID: <864cbf6d-7e8d-7dd4-7417-3150fe019fd8@lyle.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f47.google.com ([209.85.160.47]:40736 "EHLO
        mail-pl0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdKVUou (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 15:44:50 -0500
Received: by mail-pl0-f47.google.com with SMTP id 62so1402722plc.7
        for <linux-bcache@vger.kernel.org>; Wed, 22 Nov 2017 12:44:50 -0800 (PST)
In-Reply-To: <91e9b95d-861e-13bb-2b61-5c010657c2af@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Coly Li <i@coly.li>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 11/22/2017 12:36 PM, Stefan Priebe - Profihost AG wrote:
> Am 22.11.2017 um 21:22 schrieb Michael Lyle:
>> Good find.  Can you send me the first 8k of /dev/sdf1?  I'll poke at it
>> (no promises though).
> 
> Yes will send in seperate mail.

mlyle@midnight:~/Downloads$ blkid 8k
8k: UUID="65811163-4ffc-4823-ad72-bae10ce85b63" TYPE="bcache"
mlyle@midnight:~/Downloads$ blkid --version
blkid from util-linux 2.30.1  (libblkid 2.30.1, 20-Jul-2017)

I don't understand, it seems OK.

Mike
