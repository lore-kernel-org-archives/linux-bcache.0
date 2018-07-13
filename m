From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] [v2] bcache: stop using the deprecated get_seconds()
Date: Fri, 13 Jul 2018 23:34:55 +0800
Message-ID: <83724892-de0f-40ff-e16a-792a90d77ff1@suse.de>
References: <20180622134907.227131-1-arnd@arndb.de>
 <b5de0a86-b3cd-9e45-ac39-9c4eb7611016@suse.de>
 <CAK8P3a3FULT7uakRyZ4Nfq3E-ij+Gkn06=XP4Rn2m9u4Wd2OWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3FULT7uakRyZ4Nfq3E-ij+Gkn06=XP4Rn2m9u4Wd2OWA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, y2038 Mailman List <y2038@lists.linaro.org>, Jens Axboe <axboe@kernel.dk>, Michael Lyle <mlyle@lyle.org>, Tang Junhui <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>, linux-bcache@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/13 10:20 PM, Arnd Bergmann wrote:
> On Sat, Jun 23, 2018 at 10:12 AM, Coly Li <colyli@suse.de> wrote:
>> On 2018/6/22 9:48 PM, Arnd Bergmann wrote:
>>> The get_seconds function is deprecated now since it returns a 32-bit
>>> value that will eventually overflow, and we are replacing it throughout
>>> the kernel with ktime_get_seconds() or ktime_get_real_seconds() that
>>> return a time64_t.
>>>
>>> bcache uses get_seconds() to read the current system time and store it in
>>> the superblock as well as in uuid_entry structures that are user visible.
>>>
>>> Unfortunately, the two structures in are still limited to 32 bits, so this
>>> won't fix any real problems but will still overflow in year 2106. Let's
>>> at least document that properly, in case we get an updated format in the
>>> future it can be fixed. We still have a long time before the overflow
>>> and checking the tools at https://github.com/koverstreet/bcache-tools
>>> reveals no access to any of them.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Added to 4.19 for-next.
> 
> I noticed this isn't part of linux-next (yet). Did it get dropped?
> 
>       Arnd
> 
Hi Arnd,

It is here,
https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-patches.git/tree/for-next/0004-bcache-stop-using-the-deprecated-get_seconds.patch

It is for Linux v4.19, the merge window is not available yet, and I
don't post them to Jens yet.

Thanks.

Coly Li
