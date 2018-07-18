From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3 3/3] lib/test_crc: Add test cases for crc calculation
Date: Wed, 18 Jul 2018 23:28:22 +0800
Message-ID: <370a51bc-6029-c2df-67b4-22ef906ea62f@suse.de>
References: <20180717145525.50852-1-colyli@suse.de>
 <20180717145525.50852-4-colyli@suse.de>
 <CAHp75VcXDbDTebddnepeari8_ruynPudbtHGybFEQ=3Cz8Ddvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VcXDbDTebddnepeari8_ruynPudbtHGybFEQ=3Cz8Ddvg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/18 1:11 AM, Andy Shevchenko wrote:
> On Tue, Jul 17, 2018 at 5:55 PM, Coly Li <colyli@suse.de> wrote:
>> This patch adds a kernel module to test the consistency of multiple crc
>> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
>>
>> The test results are printed into kernel message, which look like,
>>
>> test_crc: crc64: PASSED (0x4e6b1ff972fa8c55, expected 0x4e6b1ff972fa8c55)
>> test_crc: crc64_bch: PASSED (0x0e4f1391d7a4a62e, expected 0x0e4f1391d7a4a62e)
>> test_crc: crc64_update: FAILED (0x03d4d0d85685d9a1, expected 0x3d4d0d85685d9a1f)
>>
>> kernel 0day system has framework to check kernel message, then the above
>> result can be handled by 0day system. If crc calculation inconsistency
>> happens, it can be detected quite soon.
>>
>> lib/test_crc.c is a testing frame work for many crc consistency
>> testings. For now, there are only test caes for 3 crc routines,
>> - crc64()
>> - crc64_bch()
>> - crc64_update()
> 
> Thanks for an update. My comments below.
> 
>> Changelog:
>> v3: Add test cases passed/failed statistic
>>     More fixes for review comments of v2
>> v2: Fixes for review comments of v1
>> v1: Initial version.
> 
> Usually this part goes after --- line below.
> 

OK, I change all the patches in this way.

>> Signed-off-by: Coly Li <colyli@suse.de>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> 
> Please, Cc me as well this one in next version (use my Intel address).
> 

Added :-)

>> +#include <linux/async.h>
>> +#include <linux/delay.h>
>> +#include <linux/fs.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/printk.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/crc64.h>
> 
> Do we need all of them?
> 

I remove most of them, only keep linux/module.h and linux/crc64.h in v4
series.

>> +static int chk_and_msg(const char *name, u64 crc, u64 expval)
>> +{
> 
>> +       int ret = 0;
>> +
>> +       if (crc == expval) {
> 
>> +               pr_info("test_crc: %s: PASSED:(0x%016llx, expected 0x%016llx)\n",
>> +                       name, crc, expval);
> 
> This doesn't bring anything useful.
> 
>> +       } else {
>> +               pr_err("test_crc: %s: FAILED:(0x%016llx, expected 0x%016llx)\n",
>> +                       name, crc, expval);
>> +               ret = -EINVAL;
>> +       }
>> +
>> +       return ret;
> 
> I would rewrite entire function as follows:
> 
> static void ...(...)
> {
>   total_tests++;
>   if (crc == expval)
>     return;
> 
>   pr_err(...);
>   failed_tests++;
> }
> 
> 
>> +}
> 
>> +static int __init test_crc_init(void)
>> +{
>> +       int i;
>> +       int v, err = 0;
>> +
>> +       pr_info("Kernel CRC consitency testing:\n");
> 
>> +       for (i = 0; test_data[i].name; i++) {
>> +               v = test_data[i].handler(&test_data[i]);
>> +               if (v < 0)
>> +                       err++;
>> +       }
> 
> ...and correct this to simple
> for (...)
>  test_data[i].handler(...);
> 
>> +       if (err == 0)
>> +               pr_info("test_crc: all %d tests passed\n", i);
>> +       else
>> +               pr_err("test_crc: %d cases tested, %d passed, %d failed\n",
>> +                      i, i - err, err);
> 
> ...and this accordingly.
> 
> Note, that in the future someone can add more test cases one or more
> of which could not map 1:1 to i here.
> That's why the rationale to have two global variables for test statistics.
> Also it allows (as you see above) to get rid of return code from all
> of those test. We don't interested in them I believe.

Yes, your code is simpler and more elegant IMHO. I change the code as
you suggested in v4 series.

Thanks.

Coly Li
