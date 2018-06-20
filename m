From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcache: stop using the deprecated get_seconds()
Date: Wed, 20 Jun 2018 18:20:44 +0200
Message-ID: <CAK8P3a1S4mRH5jkpv3ecKhEkHUH5799uEF6eq_wBx7Z07NqVWA@mail.gmail.com>
References: <20180620095228.3686471-1-arnd@arndb.de> <5ffd5433-6bb3-71a8-2b33-ceef50ddf6d7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ffd5433-6bb3-71a8-2b33-ceef50ddf6d7@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, y2038 Mailman List <y2038@lists.linaro.org>, Jens Axboe <axboe@kernel.dk>, Michael Lyle <mlyle@lyle.org>, Tang Junhui <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bart.vanassche@wdc.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-bcache@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-bcache@vger.kernel.org

On Wed, Jun 20, 2018 at 5:51 PM, Coly Li <colyli@suse.de> wrote:
> On 2018/6/20 5:51 PM, Arnd Bergmann wrote:
>> bcache uses get_seconds() to read the current system time and store it in
>> the superblock as well as in uuid_entry structures that are user visible.
>>
>> This changes over from the deprecated function to
>> ktime_get_real_seconds(), which returns a 64-bit timestamp as it
>> should. Unfortunately, the two structures are still limited to 32 bits,
>> so this won't fix any real problems. Let's at least document that
>> properly, in case we get an updated format in the future it can be
>> fixed. Until then, we still have some time, and checking the tools
>> at https://github.com/koverstreet/bcache-tools reveals no access to
>> any of them.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hi Arnd,
>
> Firstly thanks to your patch, especially the detailed information in
> patch log, it helps me to understand the problem more easier.
>
> From the information, it seems the problem is current 32bit time stamp
> will be overflow in 2106. So it will be 88 years later, which I have to
> say I don't care.
>
> Also for get_seconds() which works well for current code as many other
> places call it, I would like to keep it.

I'm currently in the process of removing all instances of get_seconds()
with patches like this. In many cases, we actually want to use
ktime_get_seconds() to return a monotonic time that is immune
to concurrent setttimeofday() calls, in others the code needs to be
changed to avoid the y2038 overflow. For bcache, we don't
really need either of them, but I'd still want to move over everything
to ktime_get_* based interfaces.

Should I clarify that motivation in the changelog text further?

I can also do a simple replacement of get_seconds() with
ktime_get_real_seconds() throughout bcache instead of
adding the intermediate helper function.

      Arnd
