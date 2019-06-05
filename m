From: Coly Li <colyli@suse.de>
Subject: Re: bcache: oops when writing to writeback_percent without a cache
 device
Date: Wed, 5 Jun 2019 12:41:01 +0800
Message-ID: <78880cf8-07c6-e00d-0084-ce9c211eeec6@suse.de>
References: <CAEYzJUH1L5qyWKN3_s4Sz81frho6nKB9bkyDoGxXCvLNO484ew@mail.gmail.com>
 <6823d3ab-5f93-da74-0dbc-19bdb7be6907@suse.de>
 <3399cad5-4387-dd23-77f1-a70e551fb531@suse.de>
 <CAEYzJUE0SuO3uHm1TTxfr1kPtLic1ggUPnGFYTSPcwk6nfq82g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEYzJUE0SuO3uHm1TTxfr1kPtLic1ggUPnGFYTSPcwk6nfq82g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Bj=c3=b8rn_Forsman?= <bjorn.forsman@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 2019/6/5 1:24 上午, Bjørn Forsman wrote:
> On Tue, 4 Jun 2019 at 17:41, Coly Li <colyli@suse.de> wrote:
>>
>> On 2019/6/4 10:59 下午, Coly Li wrote:
>>> On 2019/6/4 7:00 下午, Bjørn Forsman wrote:
>>>> Hi all,
>>>>
>>>> I get a kernel oops from bcache when writing to
>>>> /sys/block/bcache0/bcache/writeback_percent and there is no attached
>>>> cache device. See the oops itself below my signature.
>>>>
>>>> This is on Linux 4.19.46. I looked in git and see many commits to
>>>> bcache lately, but none seem to address this particular issue.
>>>>
>>>> Background: I'm writing to .../writeback_percent with
>>>> systemd-tmpfiles. I'd rather not replace it with a script that figures
>>>> out whether or not the kernel will oops if writing to the sysfs file
>>>> -- the kernel should not oops in the first place.
>>>
>>> Hi Bjorn,
>>>
>>> Thank you for the reporting. I believe this is a case we missed in
>>> testings. When a bcache device is not attached, it does not make sense
>>> to update the writeback rate in period by the changing of writeback_percent.
>>>
>>> I will post a patch for your testing soon.
>>
>> Hi Bjorn,
>>
>> Could you please to try this patch ? Hope it may help a bit.
> 
> Hi Coly,
> 
> Thanks for the quick patch! I tested it on linux 5.2-rc2 and it indeed
> fixes the problem.
> 
> There is one typo in the patch/commit message: s/writebac/writeback/
> 

Hi Bjorn,

Thanks for the patch review. Do you mind if I add Reviewed-By: tag with
your name and email address ?

-- 

Coly Li
