From: Noah Massey <noah.massey@gmail.com>
Subject: Re: [PATCH v3 3/3] lib/test_crc: Add test cases for crc calculation
Date: Tue, 17 Jul 2018 14:51:46 -0400
Message-ID: <CADfjVriarrPnxixjun1g0m7izp4kMCvP4vXuPtNTth7_LWXrMA@mail.gmail.com>
References: <20180717145525.50852-1-colyli@suse.de> <20180717145525.50852-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717145525.50852-4-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, gregkh@linuxfoundation.org, torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Jul 17, 2018 at 10:56 AM Coly Li <colyli@suse.de> wrote:
>
> This patch adds a kernel module to test the consistency of multiple crc
> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
>
> The test results are printed into kernel message, which look like,
>
> test_crc: crc64: PASSED (0x4e6b1ff972fa8c55, expected 0x4e6b1ff972fa8c55)
> test_crc: crc64_bch: PASSED (0x0e4f1391d7a4a62e, expected 0x0e4f1391d7a4a62e)
> test_crc: crc64_update: FAILED (0x03d4d0d85685d9a1, expected 0x3d4d0d85685d9a1f)
>
> kernel 0day system has framework to check kernel message, then the above
> result can be handled by 0day system. If crc calculation inconsistency
> happens, it can be detected quite soon.
>
> lib/test_crc.c is a testing frame work for many crc consistency
> testings. For now, there are only test caes for 3 crc routines,
> - crc64()
> - crc64_bch()
> - crc64_update()
>
> Changelog:
> v3: Add test cases passed/failed statistic
>     More fixes for review comments of v2
> v2: Fixes for review comments of v1
> v1: Initial version.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> ---
>  lib/Kconfig.debug |  10 ++++
>  lib/Makefile      |   1 +
>  lib/test_crc.c    | 138 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 149 insertions(+)
>  create mode 100644 lib/test_crc.c
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8838d1158d19..a9c1de0c2a7d 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1911,6 +1911,16 @@ config TEST_SYSCTL
>
>           If unsure, say N.
>
> +config TEST_CRC
> +       tristate "CRC calculation test driver"
> +       depends on CRC64
> +       help
> +         This builds the "test_crc" module. This driver enables to test the
> +         CRC calculation consistency to make sure new modification does not
> +         break existing checksum calculation.
> +
> +         if unsure, say N.
> +
>  config TEST_UDELAY
>         tristate "udelay test driver"
>         default n
> diff --git a/lib/Makefile b/lib/Makefile
> index 40c215181687..224d047d026a 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_FIND_BIT_BENCHMARK) += find_bit_benchmark.o
>  obj-$(CONFIG_TEST_BPF) += test_bpf.o
>  obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
>  obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
> +obj-$(CONFIG_TEST_CRC) += test_crc.o
>  obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
>  obj-$(CONFIG_TEST_KASAN) += test_kasan.o
>  CFLAGS_test_kasan.o += -fno-builtin
> diff --git a/lib/test_crc.c b/lib/test_crc.c
> new file mode 100644
> index 000000000000..441bf835fbd3
> --- /dev/null
> +++ b/lib/test_crc.c
> @@ -0,0 +1,138 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * CRC test driver
> + *
> + * Copyright (C) 2018 Coly Li <colyli@suse.de>
> + *
> + * This module provides an simple framework to check the consistency of
> + * Linux kernel CRC calculation routines in lib/crc*.c. This driver
> + * requires CONFIG_CRC* items to be enabled if the associated routines are
> + * tested here. The test results will be printed to kernel message
> + * when this test driver is loaded.
> + *
> + * Current test routines are,
> + * - crc64()
> + * - crc64_bch()
> + * - crc64_update()
> + *
> + */
> +
> +#include <linux/async.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>
> +#include <linux/miscdevice.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/vmalloc.h>
> +#include <linux/crc64.h>
> +
> +struct crc_test_record {
> +       char    *name;
> +       u64     data[4];
> +       u64     initval;
> +       u64     expval;
> +       int     (*handler)(struct crc_test_record *rec);
> +};
> +
> +static int chk_and_msg(const char *name, u64 crc, u64 expval)
> +{
> +       int ret = 0;
> +
> +       if (crc == expval) {
> +               pr_info("test_crc: %s: PASSED:(0x%016llx, expected 0x%016llx)\n",
> +                       name, crc, expval);

I don't think we should have specific kernel output for passed tests.
If a new test is added which follows this pattern, the 0-day will fail
because the kernel output would change. Along the lines of "silence is
golden", if no test hit the error output, we're good.

> +       } else {
> +               pr_err("test_crc: %s: FAILED:(0x%016llx, expected 0x%016llx)\n",
> +                       name, crc, expval);
> +               ret = -EINVAL;
> +       }
> +
> +       return ret;
> +}
> +
> +/* Add your crc test cases here */
> +static int test_crc64(struct crc_test_record *rec)
> +{
> +       u64 crc;
> +
> +       crc = crc64(rec->data, sizeof(rec->data));
> +       return chk_and_msg(rec->name, crc, rec->expval);
> +}
> +
> +static int test_crc64_bch(struct crc_test_record *rec)
> +{
> +       u64 crc;
> +
> +       crc = crc64_bch(rec->data, sizeof(rec->data));
> +       return chk_and_msg(rec->name, crc, rec->expval);
> +}
> +
> +static int test_crc64_update(struct crc_test_record *rec)
> +{
> +       u64 crc = rec->initval;
> +
> +       crc = crc64_update(crc, rec->data, sizeof(rec->data));
> +       return chk_and_msg(rec->name, crc, rec->expval);
> +}
> +
> +/*
> + * Set up your crc test initial data here.
> + * Do not change the existing items, they are hard coded with
> + * pre-calculated values.
> + */
> +static struct crc_test_record test_data[] = {
> +       { .name         = "crc64",
> +         .data         = { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
> +                           0xC711223CFA3E5BB5, 0x493366450E42ECDF },
> +         .initval      = 0,
> +         .expval       = 0xe2b9911e7b997201,
> +         .handler      = test_crc64,
> +       },
> +       { .name         = "crc64_bch",
> +         .data         = { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
> +                           0xC711223CFA3E5BB5, 0x493366450E42ECDF },
> +         .initval      = 0,
> +         .expval       = 0xd2753a20fd862892,
> +         .handler      = test_crc64_bch,
> +       },
> +       { .name         = "crc64_update",
> +         .data         = { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
> +                           0xC711223CFA3E5BB5, 0x493366450E42ECDF },
> +         .initval      = 0x61C8864680B583EB,
> +         .expval       = 0xb2c863673f4292bf,
> +         .handler      = test_crc64_update,
> +       },
> +       {}
> +};
> +
> +static int __init test_crc_init(void)
> +{
> +       int i;
> +       int v, err = 0;
> +
> +       pr_info("Kernel CRC consitency testing:\n");
> +       for (i = 0; test_data[i].name; i++) {
> +               v = test_data[i].handler(&test_data[i]);
> +               if (v < 0)
> +                       err++;
> +       }
> +
> +       if (err == 0)
> +               pr_info("test_crc: all %d tests passed\n", i);

Similar to previous comment: we should not report the number of passed
tests, since adding a test would invalidate previous golden output.
Also, consider the situation where some tests are conditionally
executed depending on kconfig.

> +       else
> +               pr_err("test_crc: %d cases tested, %d passed, %d failed\n",
> +                      i, i - err, err);
> +
> +       return (err == 0) ? 0 : -EINVAL;
> +}
> +late_initcall(test_crc_init);
> +
> +static void __exit test_crc_exit(void) { }
> +module_exit(test_crc_exit);
> +
> +MODULE_DESCRIPTION("CRC consistency testing driver");
> +MODULE_AUTHOR("Coly Li <colyli@suse.de>");
> +MODULE_LICENSE("GPL v2");
> --
> 2.17.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
