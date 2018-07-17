From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 4/4] lib/test_crc: Add test cases for crc calculation
Date: Tue, 17 Jul 2018 12:38:57 +0800
Message-ID: <687c7f69-b1b4-8d0d-dcda-45da3fa2ca9c@suse.de>
References: <20180716165507.23100-1-colyli@suse.de>
 <20180716165507.23100-5-colyli@suse.de>
 <CAHp75VchQOrUU1pA3GRraXO=gdhr9Uwibxo-ri1W_mwtehRtyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VchQOrUU1pA3GRraXO=gdhr9Uwibxo-ri1W_mwtehRtyw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R . Rodriguez" <mcgrof@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/17 4:47 AM, Andy Shevchenko wrote:
> On Mon, Jul 16, 2018 at 7:55 PM, Coly Li <colyli@suse.de> wrote:
>> This patch adds a kernel module to test the consistency of multiple crc
>> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
>>
>> The test results are printed into kernel message, which look like,
>>
>> test_crc: crc64_le: PASSED (0x4e6b> +
> 1ff972fa8c55, expval 0x4e6b1ff972fa8c55)
>> test_crc: crc64_le_bch: PASSED (0x0e4f1391d7a4a62e, expval 0x0e4f1391d7a4a62e)
>> test_crc: crc64_le_update: FAILED (0x03d4d0d85685d9a1, expval 0x3d4d0d85685d9a1f)
>>
>> kernel 0day system has framework to check kernel message, then the above
>> result can be handled by 0day system. If crc calculation inconsistency
>> happens, it can be detected quite soon.
>>
>> lib/test_crc.c can is a testing frame work for all crc consistency
>> testings. For now, there are only test caes for 3 crc routines,
>> - crc64_le()
>> - crc64_le_bch()
>> - crc64_le_update()
> 
>> +config TEST_CRC
>> +       tristate "CRC calculation test driver"
> 

Hi Andy,

>> +       default n
> 
> Default default is n.
> 

I see TEST_FIRMWARE, TEST_SYSCTL, TEST_UDELAY, TEST_STATIC_KEYS arround
TEST_CRC all have 'default n', then I think to follow the style it might
be better to have 'default n' here too.


>> +       depends on CRC64
> 
>> +#include <linux/init.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/printk.h>
>> +#include <linux/fs.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/async.h>
>> +#include <linux/delay.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/crc64.h>
> 
> Perhaps in order?

Do you mean in alphabet order of header file names ? I will do it in v2
series.

> 
> Moreover, either init.h or module.h depending on the Kconfig (here
> seems module.h is a right choice).
> 

Sure I will keep module.h in v2 series.

>> +struct crc_test_record {
> 
>> +
> 
> Redundant.

Removed.

> 
>> +       char    *name;
>> +       __le64  data[4];
>> +       __le64  initval;
>> +       __le64  expval;
>> +       int     (*handler)(struct crc_test_record *rec);
>> +};
>> +
>> +static int chk_and_msg(const char *name, __le64 crc, __le64 expval)
>> +{
>> +       int ret = 0;
>> +
>> +       if (crc == expval) {
>> +               pr_info("test_crc: %s: PASSED:(0x%016llx, expval 0x%016llx)",
>> +                       name, crc, expval);
>> +       } else {
>> +               pr_err("test_crc: %s: FAILED:(0x%016llx, expval 0x%016llx)",
>> +                       name, crc, expval);
>> +               ret = -EINVAL;
>> +       }
>> +
>> +       return ret;
> 
> Perhaps collect statistics instead how it's done in many other tests?
> 

Good idea. I will add this in v2 series.

>> +}
>> +
>> +/* Add your crc test caese here */
> 
> caese ?

Fixed.

> 
>> +static int test_crc64_le(struct crc_test_record *rec)
>> +{
>> +       __le64 crc;
>> +
>> +       crc = crc64_le(rec->data, sizeof(rec->data));
>> +       return chk_and_msg(rec->name, crc, rec->expval);
> 
>> +
> 
> Redundant.
> 

Fixed.

>> +}
> 
>> +       { .name = NULL, }
> 
> Simple {} would work.
> 

Fixed.

>> +static int __init test_crc_init(void)
>> +{
>> +       int i;
>> +       int v, ret = 0;
>> +
>> +       pr_info("Kernel crc consitency testing:");
>> +       for (i = 0; test_data[i].name; i++) {
> 
>> +               v = test_data[i].handler(&test_data[i]);
>> +               if (v < 0 && ret == 0)
>> +                       ret = -EINVAL;
> 
> A bit strange. Anyway, better to collect statistics and print it at
> the end with corresponding return code.
> 

Sure, I will add this :-)

>> +       }
>> +
>> +       return ret;
>> +}
> 
>> +late_initcall(test_crc_init);
> 
> Why?

Oh, IMHO this is a test module, we don't need to occupy boot time and it
should be good to invoke it after other modules loaded. As I see many
other test modules do this.

> 
>> +static void __exit test_crc_exit(void) { }
>> +module_exit(test_crc_exit);
> 
>> +MODULE_LICENSE("GPL");
> 
> It's not the same as in SPDX.
> 

Nice catch, I will change it to MODULE_LICENSE("GPL v2").

Thanks for all your review !

Coly Li
