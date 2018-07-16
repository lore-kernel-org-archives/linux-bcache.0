From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 4/4] lib/test_crc: Add test cases for crc calculation
Date: Mon, 16 Jul 2018 23:47:14 +0300
Message-ID: <CAHp75VchQOrUU1pA3GRraXO=gdhr9Uwibxo-ri1W_mwtehRtyw@mail.gmail.com>
References: <20180716165507.23100-1-colyli@suse.de> <20180716165507.23100-5-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716165507.23100-5-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R . Rodriguez" <mcgrof@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jul 16, 2018 at 7:55 PM, Coly Li <colyli@suse.de> wrote:
> This patch adds a kernel module to test the consistency of multiple crc
> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
>
> The test results are printed into kernel message, which look like,
>
> test_crc: crc64_le: PASSED (0x4e6b> +
1ff972fa8c55, expval 0x4e6b1ff972fa8c55)
> test_crc: crc64_le_bch: PASSED (0x0e4f1391d7a4a62e, expval 0x0e4f1391d7a4a62e)
> test_crc: crc64_le_update: FAILED (0x03d4d0d85685d9a1, expval 0x3d4d0d85685d9a1f)
>
> kernel 0day system has framework to check kernel message, then the above
> result can be handled by 0day system. If crc calculation inconsistency
> happens, it can be detected quite soon.
>
> lib/test_crc.c can is a testing frame work for all crc consistency
> testings. For now, there are only test caes for 3 crc routines,
> - crc64_le()
> - crc64_le_bch()
> - crc64_le_update()

> +config TEST_CRC
> +       tristate "CRC calculation test driver"

> +       default n

Default default is n.

> +       depends on CRC64

> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/async.h>
> +#include <linux/delay.h>
> +#include <linux/vmalloc.h>
> +#include <linux/crc64.h>

Perhaps in order?

Moreover, either init.h or module.h depending on the Kconfig (here
seems module.h is a right choice).

> +struct crc_test_record {

> +

Redundant.

> +       char    *name;
> +       __le64  data[4];
> +       __le64  initval;
> +       __le64  expval;
> +       int     (*handler)(struct crc_test_record *rec);
> +};
> +
> +static int chk_and_msg(const char *name, __le64 crc, __le64 expval)
> +{
> +       int ret = 0;
> +
> +       if (crc == expval) {
> +               pr_info("test_crc: %s: PASSED:(0x%016llx, expval 0x%016llx)",
> +                       name, crc, expval);
> +       } else {
> +               pr_err("test_crc: %s: FAILED:(0x%016llx, expval 0x%016llx)",
> +                       name, crc, expval);
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;

Perhaps collect statistics instead how it's done in many other tests?

> +}
> +
> +/* Add your crc test caese here */

caese ?

> +static int test_crc64_le(struct crc_test_record *rec)
> +{
> +       __le64 crc;
> +
> +       crc = crc64_le(rec->data, sizeof(rec->data));
> +       return chk_and_msg(rec->name, crc, rec->expval);

> +

Redundant.

> +}

> +       { .name = NULL, }

Simple {} would work.

> +static int __init test_crc_init(void)
> +{
> +       int i;
> +       int v, ret = 0;
> +
> +       pr_info("Kernel crc consitency testing:");
> +       for (i = 0; test_data[i].name; i++) {

> +               v = test_data[i].handler(&test_data[i]);
> +               if (v < 0 && ret == 0)
> +                       ret = -EINVAL;

A bit strange. Anyway, better to collect statistics and print it at
the end with corresponding return code.

> +       }
> +
> +       return ret;
> +}

> +late_initcall(test_crc_init);

Why?

> +static void __exit test_crc_exit(void) { }
> +module_exit(test_crc_exit);

> +MODULE_LICENSE("GPL");

It's not the same as in SPDX.

-- 
With Best Regards,
Andy Shevchenko
