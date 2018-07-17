From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2 3/3] lib/test_crc: Add test cases for crc calculation
Date: Tue, 17 Jul 2018 22:21:17 +0800
Message-ID: <c5f4089e-2794-8f11-7b04-5993fbcad25b@suse.de>
References: <20180717065711.28281-1-colyli@suse.de>
 <20180717065711.28281-4-colyli@suse.de>
 <CAHp75Vfe34n31UAxyqdX63hP7kCYWHo-_LEWx2KLsiW5F9xEEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Vfe34n31UAxyqdX63hP7kCYWHo-_LEWx2KLsiW5F9xEEQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/17 3:32 PM, Andy Shevchenko wrote:
> On Tue, Jul 17, 2018 at 9:57 AM, Coly Li <colyli@suse.de> wrote:
>> This patch adds a kernel module to test the consistency of multiple crc
>> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
>>
>> The test results are printed into kernel message, which look like,
>>
>> test_crc: crc64_le: PASSED (0x4e6b1ff972fa8c55, expval 0x4e6b1ff972fa8c55)
>> test_crc: crc64_le_bch: PASSED (0x0e4f1391d7a4a62e, expval 0x0e4f1391d7a4a62e)
>> test_crc: crc64_le_update: FAILED (0x03d4d0d85685d9a1, expval 0x3d4d0d85685d9a1f)
>>
>> kernel 0day system has framework to check kernel message, then the above
>> result can be handled by 0day system. If crc calculation inconsistency
>> happens, it can be detected quite soon.
>>
>> lib/test_crc.c is a testing frame work for many crc consistency
>> testings. For now, there are only test caes for 3 crc routines,
>> - crc64_le()
>> - crc64_le_bch()
>> - crc64_le_update()
> 
>> +config TEST_CRC
>> +       tristate "CRC calculation test driver"
>> +       depends on CRC64
> 
>> +       default n
> 
> Please, remove it.
> You Cc'ed the guy who did this:
> http://git.infradead.org/linux-platform-drivers-x86.git/commit/0192f17529fa3f8d78ca0181a2b2aaa7cbb0784d
> 

Sure, this line is removed in v3 series.

>> +       help
>> +         This builds the "test_crc" module. This driver enables to test the
>> +         CRC calculation consistency to make sure new modification does not
>> +         break existing checksum calculation.
> 
>> +static int chk_and_msg(const char *name, __le64 crc, __le64 expval)
>> +{
>> +       int ret = 0;
>> +
>> +       if (crc == expval) {
>> +               pr_info("test_crc: %s: PASSED:(0x%016llx, expected 0x%016llx)",
>> +                       name, crc, expval);
>> +       } else {
>> +               pr_err("test_crc: %s: FAILED:(0x%016llx, expected 0x%016llx)",
>> +                       name, crc, expval);
>> +               ret = -EINVAL;
>> +       }
>> +
>> +       return ret;
>> +}
> 
>> +
>> +
> 
> One of the blank lines is redundant.
> 

removed.

>> +static int __init test_crc_init(void)
>> +{
>> +       int i;
>> +       int v, ret = 0;
>> +
>> +       pr_info("Kernel CRC consitency testing:");
>> +       for (i = 0; test_data[i].name; i++) {
>> +               v = test_data[i].handler(&test_data[i]);
>> +               if (v < 0 && ret == 0)
>> +                       ret = -EINVAL;
>> +       }
>> +
>> +       return ret;
>> +}
> 
> Didn't notice anything about statistics.
> 
> See, for example,
> https://elixir.bootlin.com/linux/v4.18-rc5/source/lib/test_printf.c#L536
> 

The code is added into v3 series.

Thanks for your review :-)

Coly Li
