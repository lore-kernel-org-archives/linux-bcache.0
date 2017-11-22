From: Michael Lyle <mlyle@lyle.org>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 13:13:02 -0800
Message-ID: <CAJ+L6qeajyUipuysa1emAmgF5fhofnQbR3sa_xoYdvyAxGFQCA@mail.gmail.com>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li> <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li> <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
 <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org> <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
 <93a1e381-ea82-b5c0-444b-6bdd3062e7f0@profihost.ag> <73e9184b-c74b-fe92-bb87-a0b945931187@lyle.org>
 <91e9b95d-861e-13bb-2b61-5c010657c2af@profihost.ag> <864cbf6d-7e8d-7dd4-7417-3150fe019fd8@lyle.org>
 <3fde77da-e12f-7862-f3c5-2a3dad316b86@profihost.ag> <0387447a-cce1-4162-3458-03193e146732@lyle.org>
 <32714083-db95-0837-5dcd-e863a833b89d@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:41422 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbdKVVND (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 16:13:03 -0500
Received: by mail-qk0-f182.google.com with SMTP id f63so18573009qke.8
        for <linux-bcache@vger.kernel.org>; Wed, 22 Nov 2017 13:13:03 -0800 (PST)
In-Reply-To: <32714083-db95-0837-5dcd-e863a833b89d@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Coly Li <i@coly.li>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Wed, Nov 22, 2017 at 1:10 PM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> If you strace blkid you see that it seeks several positions and reads them.

Yes, of course, but that doesn't change that an XFS superblock within
a bcache will not be at the expected offset on the backing device.

Mike
