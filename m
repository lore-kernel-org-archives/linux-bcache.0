From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Sun, 10 Dec 2017 20:34:55 +0100
Message-ID: <b32aa385-ef0e-3a6c-2150-6a65048ba02e@profihost.ag>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
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
 <1855331d-a606-58fd-2649-67203ddee8b5@profihost.ag>
 <e19204b9-bca0-052b-99c2-102b983547f8@lyle.org>
 <c2c82969-5fba-cea8-756a-d7489b506e7a@profihost.ag>
 <87a7z21o2f.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:24116 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751991AbdLJTe5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 10 Dec 2017 14:34:57 -0500
In-Reply-To: <87a7z21o2f.fsf@esperi.org.uk>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Michael Lyle <mlyle@lyle.org>, Coly Li <i@coly.li>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, n.fahldieck@profihost.ag


Am 01.12.2017 um 16:10 schrieb Nix:
> On 28 Nov 2017, Stefan Priebe spake thusly:
> 
>> Am 28.11.2017 um 21:05 schrieb Michael Lyle:
> [...]
>>> Even if I maintained bcache-tools, I couldn't really fix this.  If there
>>> is a desire to proceed through ambiguity, the ordering that actions are
>>> attempted in-- RAID, filesystems, bcache, DM, etc, becomes important,
>>> and can't be solved in any one package.
>>
>> I dont want to allow to register for ambiguity in general - but in case
>> there is ambiguity with an FS (xfs,btrfs, ...). I can't see a way where
>> this could be a problem. Even considering other block drivers like md or dm.
> 
> bcache can be stacked underneath filesystems via loopback mounts. Heck
> you can have a RAID->bcache->LVM->cryptfs->loopback->RAID->bcache stack
> if you like (I've done that, though the loopback layers and below were
> only for testing.)

mhm but that means bcache can't be autoregistered in a solid way. Sad to
here that.

Thanks for your example.

Greets,
Stefan
