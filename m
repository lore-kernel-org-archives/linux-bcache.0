From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] [v2] bcache: stop using the deprecated get_seconds()
Date: Fri, 13 Jul 2018 13:38:11 -0600
Message-ID: <b73a9580-849a-d946-b203-2eacc31509eb@kernel.dk>
References: <20180622134907.227131-1-arnd@arndb.de>
 <b5de0a86-b3cd-9e45-ac39-9c4eb7611016@suse.de>
 <CAK8P3a3FULT7uakRyZ4Nfq3E-ij+Gkn06=XP4Rn2m9u4Wd2OWA@mail.gmail.com>
 <83724892-de0f-40ff-e16a-792a90d77ff1@suse.de>
 <CAK8P3a0GDUpXQ8WnS6ake2AuAu0Q1gZg+hFQVPgXCBqQ1sS+jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0GDUpXQ8WnS6ake2AuAu0Q1gZg+hFQVPgXCBqQ1sS+jw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Lyle <mlyle@lyle.org>, Tang Junhui <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>, linux-bcache@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 7/13/18 12:57 PM, Arnd Bergmann wrote:
> On Fri, Jul 13, 2018 at 5:34 PM, Coly Li <colyli@suse.de> wrote:
>> On 2018/7/13 10:20 PM, Arnd Bergmann wrote:
>>> On Sat, Jun 23, 2018 at 10:12 AM, Coly Li <colyli@suse.de> wrote:
> 
>>>> Added to 4.19 for-next.
>>>
>>> I noticed this isn't part of linux-next (yet). Did it get dropped?
>>>
>>>       Arnd
>>>
>> Hi Arnd,
>>
>> It is here,
>> https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-patches.git/tree/for-next/0004-bcache-stop-using-the-deprecated-get_seconds.patch
> 
> Ok, thanks for the confirmation!
> 
>> It is for Linux v4.19, the merge window is not available yet, and I
>> don't post them to Jens yet.
> 
> That sounds like an odd way to handle your patches. Normally all patches
> should be part of linux-next *before* the merge window so they get tested
> as part of the linux-next kernel before the pull request to Linus is sent.
> 
> It's not important for me for this particular patch, but generally speaking,
> the Documentation/process/2.Process.rst states:
> 
> "all patches merged during a given merge window should really have found
> their way into linux-next some time before the merge window opens."

Coly does generally send before the merge window, I think the phrasing
is just a little bit off. Depending on risk, I usually tell folks to
submit their stuff for the next window at no later than -rc5 time,
so it'll be in for-next for a least two weeks before the merge window
opens.

-- 
Jens Axboe
