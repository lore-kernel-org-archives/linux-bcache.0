From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 4/4] lib/test_crc: Add test cases for crc calculation
Date: Mon, 16 Jul 2018 11:05:28 -0700
Message-ID: <02a39b74-918b-a9ab-5023-99c11a8ac832@infradead.org>
References: <20180716165507.23100-1-colyli@suse.de>
 <20180716165507.23100-5-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716165507.23100-5-colyli@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R . Rodriguez" <mcgrof@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On 07/16/2018 09:55 AM, Coly Li wrote:
> This patch adds a kernel module to test the consistency of multiple crc
> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
> 
> The test results are printed into kernel message, which look like,
> 
> test_crc: crc64_le: PASSED (0x4e6b1ff972fa8c55, expval 0x4e6b1ff972fa8c55)
> test_crc: crc64_le_bch: PASSED (0x0e4f1391d7a4a62e, expval 0x0e4f1391d7a4a62e)
> test_crc: crc64_le_update: FAILED (0x03d4d0d85685d9a1, expval 0x3d4d0d85685d9a1f)
> 
> kernel 0day system has framework to check kernel message, then the above
> result can be handled by 0day system. If crc calculation inconsistency
> happens, it can be detected quite soon.
> 
> lib/test_crc.c can is a testing frame work for all crc consistency

            drop ^^^ "can"

Well, we already have (from lib/Makefile):
obj-$(CONFIG_CRC32_SELFTEST)	+= crc32test.o

so lib/test_crc.c isn't exactly "for all crc".


> testings. For now, there are only test caes for 3 crc routines,
> - crc64_le()
> - crc64_le_bch()
> - crc64_le_update()
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Luis R. Rodriguez <mcgrof@suse.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> ---
>  lib/Kconfig.debug |  11 ++++
>  lib/Makefile      |   1 +
>  lib/test_crc.c    | 136 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 148 insertions(+)
>  create mode 100644 lib/test_crc.c


> diff --git a/lib/test_crc.c b/lib/test_crc.c
> new file mode 100644
> index 000000000000..3a9442252de5
> --- /dev/null
> +++ b/lib/test_crc.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * CRC test driver
> + *
> + * Copyright (C) 2018 Coly Li <colyli@suse.de>
> + *
> + * This module provides an simple framework to check the consistency of
> + * Linux kernel crc calculation routines in lib/crc*.c. This driver

                   CRC

> + * requires CONFIG_CRC* items to be enabled if the associated routines are
> + * tested here. The test results will be printed to kernel message
> + * when this test driver is loaded.
> + *
> + * Current test routines are,
> + * - crc64_le()
> + * - crc64_le_bch()
> + * - crc64_le_update()
> + *
> + */
> +
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
> +
> +struct crc_test_record {
> +
> +	char	*name;
> +	__le64	data[4];
> +	__le64	initval;
> +	__le64	expval;
> +	int	(*handler)(struct crc_test_record *rec);
> +};
> +
> +static int chk_and_msg(const char *name, __le64 crc, __le64 expval)
> +{
> +	int ret = 0;
> +
> +	if (crc == expval) {
> +		pr_info("test_crc: %s: PASSED:(0x%016llx, expval 0x%016llx)",
> +			name, crc, expval);
> +	} else {
> +		pr_err("test_crc: %s: FAILED:(0x%016llx, expval 0x%016llx)",
> +			name, crc, expval);

For both pr_err() lines, please print "expected" instead of "expval".

> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +/* Add your crc test caese here */

               CRC test cases

> +static int test_crc64_le(struct crc_test_record *rec)
> +{
> +	__le64 crc;
> +
> +	crc = crc64_le(rec->data, sizeof(rec->data));
> +	return chk_and_msg(rec->name, crc, rec->expval);
> +
> +}
> +
> +static int test_crc64_le_bch(struct crc_test_record *rec)
> +{
> +	__le64 crc;
> +
> +	crc = crc64_le_bch(rec->data, sizeof(rec->data));
> +	return chk_and_msg(rec->name, crc, rec->expval);
> +}
> +
> +static int test_crc64_le_update(struct crc_test_record *rec)
> +{
> +	__le64 crc = rec->initval;
> +
> +	crc = crc64_le_update(crc, rec->data, sizeof(rec->data));
> +	return chk_and_msg(rec->name, crc, rec->expval);
> +}
> +
> +/*
> + * Set up your crc test initial data here.
> + * Do not change the existing items, they are hard coded with
> + * pre-calculated values.
> + */
> +static struct crc_test_record test_data[] = {
> +	{ .name		= "crc64_le",
> +	  .data		= { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
> +			    0xC711223CFA3E5BB5, 0x493366450E42ECDF },
> +	  .initval	= 0,
> +	  .expval	= 0xe2b9911e7b997201,
> +	  .handler	= test_crc64_le,
> +	},
> +	{ .name		= "crc64_le_bch",
> +	  .data		= { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
> +			    0xC711223CFA3E5BB5, 0x493366450E42ECDF },
> +	  .initval	= 0,
> +	  .expval	= 0xd2753a20fd862892,
> +	  .handler	= test_crc64_le_bch,
> +	},
> +	{ .name		= "crc64_le_update",
> +	  .data		= { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
> +			    0xC711223CFA3E5BB5, 0x493366450E42ECDF },
> +	  .initval	= 0x61C8864680B583EB,
> +	  .expval	= 0xb2c863673f4292bf,
> +	  .handler	= test_crc64_le_update,
> +	},
> +	{ .name = NULL, }
> +};
> +
> +
> +static int __init test_crc_init(void)
> +{
> +	int i;
> +	int v, ret = 0;
> +
> +	pr_info("Kernel crc consitency testing:");

	                CRC consistency

> +	for (i = 0; test_data[i].name; i++) {
> +		v = test_data[i].handler(&test_data[i]);
> +		if (v < 0 && ret == 0)
> +			ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +late_initcall(test_crc_init);
> +
> +static void __exit test_crc_exit(void) { }
> +module_exit(test_crc_exit);
> +
> +MODULE_DESCRIPTION("CRC consistency testing driver");
> +MODULE_AUTHOR("Coly Li <colyli@suse.de>");
> +MODULE_LICENSE("GPL");
> 


thanks,
-- 
~Randy
