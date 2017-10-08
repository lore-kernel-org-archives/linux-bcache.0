From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: writeback rate shouldn't artifically clamp
Date: Sun, 8 Oct 2017 16:06:22 +0800
Message-ID: <1e2ed986-d85b-0eef-88ce-ae67b12e1391@coly.li>
References: <20171008052520.17068-1-mlyle@lyle.org>
 <fe817f47-89d6-8543-ded6-7ffa46fd52d0@coly.li>
 <C6C056E1-713E-4E3C-910D-5737463C2F95@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <C6C056E1-713E-4E3C-910D-5737463C2F95@profihost.ag>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, colyli@suse.de
List-Id: linux-bcache@vger.kernel.org

On 2017/10/8 下午3:50, Stefan Priebe - Profihost AG wrote:
> Is there a branch with all patches available?
> 
> Stefan

Hi Stefan,

Current I just organize patch files not a git tree branch. The reason
is, I send bcache patches by emails to Jens and Cc linux-bcache and
linux-block, in order to make more people notice the patches.

Currently the patches can be found here (today's change not pushed yet),
https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-patches.git/tree/

for-next: this directory contains patches under serious testing and for
next merge window
for-test: this directory contains all meaningful patches, I verify them
when I have time, they are candidate of for-next.

Michael is preparing a git tree at mean time, maybe we will take care
patches in form of git tree soon.

Thanks.

Coly Li

> 
> Excuse my typo sent from my mobile phone.
> 
> Am 08.10.2017 um 08:09 schrieb Coly Li <i@coly.li <mailto:i@coly.li>>:
> 
>> On 2017/10/8 下午1:25, Michael Lyle wrote:
>>> The previous code artificially limited writeback rate to 1000000
>>> blocks/second (NSEC_PER_MSEC), which is a rate that can be met on fast
>>> hardware.  The rate limiting code works fine (though with decreased
>>> precision) up to 3 orders of magnitude faster, so use NSEC_PER_SEC.
>>>
>>> Additionally, ensure that uint32_t is used as a type for rate throughout
>>> the rate management so that type checking/clamp_t can work properly.
>>>
>>> bch_next_delay should be rewritten for increased precision and better
>>> handling of high rates and long sleep periods, but this is adequate for
>>> now.
>>>
>>> Signed-off-by: Michael Lyle <mlyle@lyle.org <mailto:mlyle@lyle.org>>
>>> Reported-by: Coly Li <colyli@suse.de <mailto:colyli@suse.de>>
>>
>> Added to for-test, I will update test result after the writeback
>> performance test done (hopefully in 2 days).
>>
>> Thanks for fast fix.
>>
>> Coly Li
>>
>>
>> [snip]
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> <mailto:majordomo@vger.kernel.org>
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
