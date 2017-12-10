From: Michael Lyle <mlyle@lyle.org>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Sun, 10 Dec 2017 11:36:17 -0800
Message-ID: <f4ab9fc2-3842-948c-91a0-bc980d675481@lyle.org>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
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
 <b32aa385-ef0e-3a6c-2150-6a65048ba02e@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36103 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdLJTgU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 10 Dec 2017 14:36:20 -0500
Received: by mail-pf0-f173.google.com with SMTP id p84so9967616pfd.3
        for <linux-bcache@vger.kernel.org>; Sun, 10 Dec 2017 11:36:20 -0800 (PST)
In-Reply-To: <b32aa385-ef0e-3a6c-2150-6a65048ba02e@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Nix <nix@esperi.org.uk>
Cc: Coly Li <i@coly.li>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, n.fahldieck@profihost.ag

On 12/10/2017 11:34 AM, Stefan Priebe - Profihost AG wrote:
> 
> Am 01.12.2017 um 16:10 schrieb Nix:
>> bcache can be stacked underneath filesystems via loopback mounts. Heck
>> you can have a RAID->bcache->LVM->cryptfs->loopback->RAID->bcache stack
>> if you like (I've done that, though the loopback layers and below were
>> only for testing.)
> 
> mhm but that means bcache can't be autoregistered in a solid way. Sad to
> here that.

These problems aren't anything specific to bcache.
