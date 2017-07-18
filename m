From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PULL] bcache updates based on git.kernel.dk/linux-block:for-next
Date: Tue, 18 Jul 2017 19:24:01 +0100
Message-ID: <f09f9db6-c8ec-3e38-84af-40195b0fc13b@ehuk.net>
References: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
 <23b4ace1-60b7-1ce6-23d7-29433ec8582c@ehuk.net>
 <7040453d-2272-d376-710b-6ed07527a98e@coly.li>
 <d94db8ff-ff2c-0c3c-5638-97cd3c769c1c@ehuk.net>
 <OF92BA0158.87BDF9E3-ON4825815E.000736BF-4825815E.000833F7@zte.com.cn>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from schatzi.steelbluetech.co.uk ([92.63.139.240]:41881 "EHLO
        schatzi.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751480AbdGRSYD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 18 Jul 2017 14:24:03 -0400
In-Reply-To: <OF92BA0158.87BDF9E3-ON4825815E.000736BF-4825815E.000833F7@zte.com.cn>
Content-Language: en-GB
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <i@coly.li>, linux-bcache@vger.kernel.org, stable@vger.kernel.org

On 15/07/17 02:29, tang.junhui@zte.com.cn wrote:
> Hello Eddie
> 
> One thing, please see below:
> 
> 
>>On 14/07/17 16:07, Coly Li wrote:
>>> On 2017/7/14 下午7:40, Eddie Chapman wrote:
>>>> On 25/05/17 20:10, Eric Wheeler wrote:
>>>>> Hi Jens,
>>>>>
>>>>> Please pull these updates and bugfixes from the bcache community when you
>>>>> have a minute.  If you need a rebase against something else then please
>>>>> let me know and I would be happy to update for you.
>>>>>
>>>>> Thank you for your help!
>>>>
>>>> <snip>
>>>>
>>>> Hi all,
>>>>
>>>> (replying to all but as a subscriber to stable only)
>>>>
>>>> I'm not a kernel coder but have several 4.4 (kernel.org stable series)
>>>> servers using bcache, so I'd love to see (possibly some of?) these in
>>>> 4.4 if they are relevant and apply without any significant work needed.
>>>>
>>>> This series was CC'd to stable but I don't see any info of how far back
>>>> any of them might be applicable, if at all.
>>>>
>>>> If any of you guys are able to give a hint with this series just along
>>>> the lines of "this one is/is not applicable to 4.4" then I'm happy to
>>>> apply them, resolve any simple context issues, use, and report back with
>>>> clean patches.
>>>
>>> (remove many unnecessary email receivers)
>>
>>I'm re-adding the stable list to CC as we're discussing a stable kernel.
>>Hope that's OK.
>>
>>> Hi Eddie,
>>>
>>> I think some patches from Junhui Tang are important stable fixes.
>>> After all the patches get reviewed, and accepted in mainline kernel, you
>>> may find them in 4.4 stable tree (any way it won't be very soon for
>>> these fixes show up in stable tree).
>>>
>>> Thanks.
>>
>>Thanks for your reply Coly.  You're right, forgot about that. Before
>>they can go in 4.4 or any other stable kernel they must be in Linus' tree.
>>
>>Of the 9 patches CC'd to stable, it looks to me that so far these 2 have
>>subsequently received approval by you plus at least 1 other person other
>>than the author (e.g. Christoph Hellwig):
>>
>>- fix sequential large write IO bypass
>>- do not subtract sectors_to_gc for bypassed IO
>>
>>The first one looks particularly important to me and Kent himself has
>>also reviewed it.
>>
>>This one also has not received any objections yet and you mentioned you
>>discussed with the author and both concluded it is correct:
>>
>>- Subtract dirty sectors of thin flash from cache_sectors in calculating
>>writeback rate
> 
> If you want to apply this patch, please also apply this patch to make
> dirty sectors of thin flashInitializing correctly. Otherwise
> it will subtract a wrong dirty sectors of thin flash.
> 
> -bcache: initialize stripe_sectors_dirty correctly for thin flash device

Thank you very much Tang for pointing this out.

I applied all 4 patches on top of vanilla kernel.org 4.4.77 . So they are:

- bcache: fix sequential large write IO bypass
- bcache: do not subtract sectors_to_gc for bypassed IO
- bcache: Subtract dirty sectors of thin flash from cache_sectors in calculating writeback rate
- bcache: initialize stripe_sectors_dirty correctly for thin flash device

They applied without any issues just some fuzz.
There were no issues during build, and I've been running 4.4.77 with 
these 4 patches on one server using bcache for 3 days now without any 
problems or any unusual logs from bcache in dmesg.

I will send another mail separately, as a reply to this one, with the 4 
patches with context adjusted, generated from patched 4.4.77 using diff -up, 
in case they are any use to anyone. Not sure if they are any use to you guys 
though as they are not generated with git-send-email, but anyway, FWIW.

Thanks,
Eddie

>>So for me these 3 by Junhui Tang seem "safe" enough that I will take a
>>little risk and try them already on 4.4 on my own machines (I'm guessing
>>they are likely relevant to 4.4 but of course I'll check if they apply).
>>I'll report back, FWIW.
>>
>>If I'm brave (foolish) enough I might go through mainline bcache commits
>>since 4.4 and see if there are any other goodies to try out with 4.4. Of
>>course if anyone has any in particular to suggest to me to try, please
>>do! If I do, I'll report back anything that seems to have worked.
>>
>>Thanks again!
>>Eddie
>>--
> 
> Thanks to use it.
> 
> Tang Junhui
> 
