From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [v2] bcache: stop using the deprecated get_seconds()
Date: Fri, 13 Jul 2018 16:20:39 +0200
Message-ID: <CAK8P3a3FULT7uakRyZ4Nfq3E-ij+Gkn06=XP4Rn2m9u4Wd2OWA@mail.gmail.com>
References: <20180622134907.227131-1-arnd@arndb.de> <b5de0a86-b3cd-9e45-ac39-9c4eb7611016@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b5de0a86-b3cd-9e45-ac39-9c4eb7611016@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, y2038 Mailman List <y2038@lists.linaro.org>, Jens Axboe <axboe@kernel.dk>, Michael Lyle <mlyle@lyle.org>, Tang Junhui <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>, linux-bcache@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Sat, Jun 23, 2018 at 10:12 AM, Coly Li <colyli@suse.de> wrote:
> On 2018/6/22 9:48 PM, Arnd Bergmann wrote:
>> The get_seconds function is deprecated now since it returns a 32-bit
>> value that will eventually overflow, and we are replacing it throughout
>> the kernel with ktime_get_seconds() or ktime_get_real_seconds() that
>> return a time64_t.
>>
>> bcache uses get_seconds() to read the current system time and store it in
>> the superblock as well as in uuid_entry structures that are user visible.
>>
>> Unfortunately, the two structures in are still limited to 32 bits, so this
>> won't fix any real problems but will still overflow in year 2106. Let's
>> at least document that properly, in case we get an updated format in the
>> future it can be fixed. We still have a long time before the overflow
>> and checking the tools at https://github.com/koverstreet/bcache-tools
>> reveals no access to any of them.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Added to 4.19 for-next.

I noticed this isn't part of linux-next (yet). Did it get dropped?

      Arnd
