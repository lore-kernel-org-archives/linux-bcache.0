From: Michael Lyle <mlyle@lyle.org>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Tue, 28 Nov 2017 11:51:33 -0800
Message-ID: <CAJ+L6qcJ+heW+B2tyimxmJwjW6jQ0tsAz+bYx_3uYSc0YR53nA@mail.gmail.com>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li> <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li> <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
 <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org> <eee65109-aa05-d639-e0fe-12259e726803@profihost.ag>
 <93a1e381-ea82-b5c0-444b-6bdd3062e7f0@profihost.ag> <73e9184b-c74b-fe92-bb87-a0b945931187@lyle.org>
 <91e9b95d-861e-13bb-2b61-5c010657c2af@profihost.ag> <864cbf6d-7e8d-7dd4-7417-3150fe019fd8@lyle.org>
 <3fde77da-e12f-7862-f3c5-2a3dad316b86@profihost.ag> <0387447a-cce1-4162-3458-03193e146732@lyle.org>
 <0ab9bd3f-f2ea-04d7-1416-941b3d93d410@profihost.ag> <e2acf9c9-9097-e24c-69dd-a56ec672f9ef@lyle.org>
 <e016c187-fb69-463b-8a1f-3c41fdec369a@profihost.ag> <03029ee8-2856-19a3-a44d-8fbdc3f27da4@profihost.ag>
 <cb1cbbc1-194c-d583-07ed-9ff81777dace@profihost.ag> <CAJ+L6qc79S1t10WfeycRFLesuqbZNfUXrN7qo6fVuwbHk=n8xw@mail.gmail.com>
 <ce696f9d-07e5-88b4-dca8-dbef47594fca@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:45532 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbdK1Tve (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Nov 2017 14:51:34 -0500
Received: by mail-qt0-f169.google.com with SMTP id g10so1386021qtj.12
        for <linux-bcache@vger.kernel.org>; Tue, 28 Nov 2017 11:51:34 -0800 (PST)
In-Reply-To: <ce696f9d-07e5-88b4-dca8-dbef47594fca@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Coly Li <i@coly.li>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, n.fahldieck@profihost.ag

On Tue, Nov 28, 2017 at 11:32 AM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> nobody asked for this - but bcache provides bcache-tools and upstream
> udev rules and those don't work in this case. To i consider this an
> upstream bug. Not a bug in my envorinment or in my distribution.

I do not maintain bcache-tools.  It looks like g2p wrote a set of
rules in 2014 that Debian uses.  Gentoo uses a different set of rules.
Arch uses a slightly different set of rules.

Nor is what you're trying to do completely safe, because depending on
rule ordering it can mean if you stack md & bcache, for instance, very
bad things could happen with your change.

This is an issue for your distribution maintainer.

>
> I can fix this myself - i just had the hope to get it fixed upstream so
> others don't fall into the same issue.
>
> Greets,
> Stefan

Mike
