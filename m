From: Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PULL] bcache updates based on git.kernel.dk/linux-block:for-next
Date: Fri, 14 Jul 2017 18:33:24 +0100
Message-ID: <d94db8ff-ff2c-0c3c-5638-97cd3c769c1c@ehuk.net>
References: <alpine.LRH.2.11.1705251853530.19359@mail.ewheeler.net>
 <23b4ace1-60b7-1ce6-23d7-29433ec8582c@ehuk.net>
 <7040453d-2272-d376-710b-6ed07527a98e@coly.li>
Reply-To: Eddie Chapman <eddie@ehuk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <7040453d-2272-d376-710b-6ed07527a98e@coly.li>
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, stable@vger.kernel.org, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: linux-bcache@vger.kernel.org

On 14/07/17 16:07, Coly Li wrote:
> On 2017/7/14 下午7:40, Eddie Chapman wrote:
>> On 25/05/17 20:10, Eric Wheeler wrote:
>>> Hi Jens,
>>>
>>> Please pull these updates and bugfixes from the bcache community when you
>>> have a minute.  If you need a rebase against something else then please
>>> let me know and I would be happy to update for you.
>>>
>>> Thank you for your help!
>>
>> <snip>
>>
>> Hi all,
>>
>> (replying to all but as a subscriber to stable only)
>>
>> I'm not a kernel coder but have several 4.4 (kernel.org stable series)
>> servers using bcache, so I'd love to see (possibly some of?) these in
>> 4.4 if they are relevant and apply without any significant work needed.
>>
>> This series was CC'd to stable but I don't see any info of how far back
>> any of them might be applicable, if at all.
>>
>> If any of you guys are able to give a hint with this series just along
>> the lines of "this one is/is not applicable to 4.4" then I'm happy to
>> apply them, resolve any simple context issues, use, and report back with
>> clean patches.
> 
> (remove many unnecessary email receivers)

I'm re-adding the stable list to CC as we're discussing a stable kernel. 
Hope that's OK.

> Hi Eddie,
> 
> I think some patches from Junhui Tang are important stable fixes.
> After all the patches get reviewed, and accepted in mainline kernel, you
> may find them in 4.4 stable tree (any way it won't be very soon for
> these fixes show up in stable tree).
> 
> Thanks.

Thanks for your reply Coly.  You're right, forgot about that. Before 
they can go in 4.4 or any other stable kernel they must be in Linus' tree.

Of the 9 patches CC'd to stable, it looks to me that so far these 2 have 
subsequently received approval by you plus at least 1 other person other 
than the author (e.g. Christoph Hellwig):

- fix sequential large write IO bypass
- do not subtract sectors_to_gc for bypassed IO

The first one looks particularly important to me and Kent himself has 
also reviewed it.

This one also has not received any objections yet and you mentioned you 
discussed with the author and both concluded it is correct:

- Subtract dirty sectors of thin flash from cache_sectors in calculating 
writeback rate

So for me these 3 by Junhui Tang seem "safe" enough that I will take a 
little risk and try them already on 4.4 on my own machines (I'm guessing 
they are likely relevant to 4.4 but of course I'll check if they apply). 
I'll report back, FWIW.

If I'm brave (foolish) enough I might go through mainline bcache commits 
since 4.4 and see if there are any other goodies to try out with 4.4. Of 
course if anyone has any in particular to suggest to me to try, please 
do! If I do, I'll report back anything that seems to have worked.

Thanks again!
Eddie
