From: Coly Li <i@coly.li>
Subject: Re: bcache: for-next unable to handle kernel NULL pointer dereference
 at 0000000000000019
Date: Wed, 25 Oct 2017 22:05:17 +0800
Message-ID: <9cb58a34-8ada-b9dd-7abb-188379e63b59@coly.li>
References: <5cd9d4e9-88b2-c24b-f6ed-dad3f8b21283@profihost.ag>
 <4f1c616f-2e86-2cd3-162c-4ee7a3a02bf4@coly.li>
 <b3fe481a-67d7-1e70-1f52-0aa285dc48e7@profihost.ag>
 <08c770ef-eb09-ed55-a7bb-31b1b97a88d9@coly.li>
 <26bed6fb-d433-bcb7-4428-ed7b771f2def@profihost.ag>
 <ebfea14d-0fbd-00e0-d31b-54e1adfb2b80@coly.li>
 <ee16f106-9bce-d33b-e8cc-acd6eeb94d10@profihost.ag>
 <8416a91c-d340-85ed-fef9-41d732e0e2be@coly.li>
 <c6681708-cddf-933b-8532-bcb24d43caab@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:52492 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751900AbdJYOFX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Oct 2017 10:05:23 -0400
In-Reply-To: <c6681708-cddf-933b-8532-bcb24d43caab@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-bcache@vger.kernel.org
Cc: Michael Lyle <mlyle@lyle.org>

On 2017/10/25 下午9:26, Stefan Priebe - Profihost AG wrote:
[snip]
>>>> Hi Stefan,
>>>>
>>>> In code path of closure_wake_up(), I remember there are two patches in
>>>> last run,
>>>> - commit a5f3d8a5eaaf ("bcache: use llist_for_each_entry_safe() in
>>>> __closure_wake_up()")
>>>> - commit 09b3efec81de ("bcache: Don't reinvent the wheel but use
>>>> existing llist API")
>>>>
>>>> Can you check whether you have all of these patches ? Or can we try to
>>>> revoke these two patches and see whether oops still happens.
>>>
>>> It seems i'm missing a5f3d8a5eaaf but i have 09b3efec81de.
>>>
>>> I missed it because
>>> git log ..linux-block/for-next -- drivers/md/bcache/
>>>
>>> does not show it. It seems linux-block/for-next does not contain it?
>>> Which branch should i use?
>>>
>>> Only those contain the mentioned commit:
>>>   remotes/linux-block/for-linus
>>>   remotes/linux-block/master
>>>   remotes/linux-block/wbt-odirect
>>>
>>
>> Hi Stefan,
>>
>> These 2 patches are in 4.14 mainline kernel already. This is my fault to
>> make commit 09b3efec81de buggy, and fix it in commit a5f3d8a5eaaf.
>>
>> Could you please try again with the fixing patch ?
>>
>> (And I guess maybe other 2 reports may also miss this fix).
> 
> OK indeed it seems it fixed it. Sorry about that.
> 

Hi Stefan,

Thanks for the confirm :-)

-- 
Coly Li
