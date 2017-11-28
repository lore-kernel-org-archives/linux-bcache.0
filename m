From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Tue, 28 Nov 2017 20:59:56 +0100
Message-ID: <1855331d-a606-58fd-2649-67203ddee8b5@profihost.ag>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
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
 <e2acf9c9-9097-e24c-69dd-a56ec672f9ef@lyle.org>
 <e016c187-fb69-463b-8a1f-3c41fdec369a@profihost.ag>
 <03029ee8-2856-19a3-a44d-8fbdc3f27da4@profihost.ag>
 <cb1cbbc1-194c-d583-07ed-9ff81777dace@profihost.ag>
 <CAJ+L6qc79S1t10WfeycRFLesuqbZNfUXrN7qo6fVuwbHk=n8xw@mail.gmail.com>
 <ce696f9d-07e5-88b4-dca8-dbef47594fca@profihost.ag>
 <CAJ+L6qcJ+heW+B2tyimxmJwjW6jQ0tsAz+bYx_3uYSc0YR53nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:52894 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752997AbdK1T77 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Nov 2017 14:59:59 -0500
In-Reply-To: <CAJ+L6qcJ+heW+B2tyimxmJwjW6jQ0tsAz+bYx_3uYSc0YR53nA@mail.gmail.com>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <i@coly.li>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, n.fahldieck@profihost.ag

)

Am 28.11.2017 um 20:51 schrieb Michael Lyle:
> On Tue, Nov 28, 2017 at 11:32 AM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
>> nobody asked for this - but bcache provides bcache-tools and upstream
>> udev rules and those don't work in this case. To i consider this an
>> upstream bug. Not a bug in my envorinment or in my distribution.
> 
> I do not maintain bcache-tools.  It looks like g2p wrote a set of
> rules in 2014 that Debian uses.  Gentoo uses a different set of rules.
> Arch uses a slightly different set of rules.
> 
> Nor is what you're trying to do completely safe, because depending on
> rule ordering it can mean if you stack md & bcache, for instance, very
> bad things could happen with your change.

Thanks - that helped. - didn't know that the original bcache-tools which
came from kent were handed over to somebody else / or that each
distribution uses it's own.

> This is an issue for your distribution maintainer.
> 
>>
>> I can fix this myself - i just had the hope to get it fixed upstream so
>> others don't fall into the same issue.
>>
>> Greets,
>> Stefan
> 
> Mike
> 
