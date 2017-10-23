From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: bcache: for-next unable to handle kernel NULL pointer dereference
 at 0000000000000019
Date: Mon, 23 Oct 2017 19:49:33 +0200
Message-ID: <4d03983e-c052-e8a8-ac77-aa6f9844a940@profihost.ag>
References: <5cd9d4e9-88b2-c24b-f6ed-dad3f8b21283@profihost.ag>
 <4f1c616f-2e86-2cd3-162c-4ee7a3a02bf4@coly.li>
 <b3fe481a-67d7-1e70-1f52-0aa285dc48e7@profihost.ag>
 <08c770ef-eb09-ed55-a7bb-31b1b97a88d9@coly.li>
 <26bed6fb-d433-bcb7-4428-ed7b771f2def@profihost.ag>
 <ebfea14d-0fbd-00e0-d31b-54e1adfb2b80@coly.li>
 <ee16f106-9bce-d33b-e8cc-acd6eeb94d10@profihost.ag>
 <52830ea6-a17c-e3a6-f4fb-bc463615aac4@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:55815 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932143AbdJWRtg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Oct 2017 13:49:36 -0400
In-Reply-To: <52830ea6-a17c-e3a6-f4fb-bc463615aac4@lyle.org>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <i@coly.li>, linux-bcache@vger.kernel.org


Am 23.10.2017 um 18:48 schrieb Michael Lyle:
> On 10/23/2017 07:26 AM, Stefan Priebe - Profihost AG wrote:
>> It seems i'm missing a5f3d8a5eaaf but i have 09b3efec81de.
>>
>> I missed it because
>> git log ..linux-block/for-next -- drivers/md/bcache/
>>
>> does not show it. It seems linux-block/for-next does not contain it?
>> Which branch should i use?
> 
> This is one of the pitfalls of selectively taking a bunch of changes
> back into an older kernel series, especially from development trees.
> linux-block/for-next is guaranteed to contain all the changes needed to
> take the linux-next tree into complete state, but not necessarily to be
> based on a point in time on linux-next that captures all past changes.
> Similarly, there's no guarantee that current bcache code will work well
> on the 4.4 kernel without changes-- i.e. I am accepting changes that
> rely on recent changes in kernel facilities to compile, and I would
> accept changes that rely on recent changes in semantics to be correct.

Yes sure but that's no problem. I already backported them.

Stefan
