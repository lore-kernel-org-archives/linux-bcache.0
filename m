From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v4 3/3] lib/test_crc: Add test cases for crc calculation
Date: Mon, 23 Jul 2018 21:44:20 -0700
Message-ID: <20180724044420.GB1944@sol.localdomain>
References: <20180718165545.1622-1-colyli@suse.de>
 <20180718165545.1622-4-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718165545.1622-4-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Noah Massey <noah.massey@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 19, 2018 at 12:55:45AM +0800, Coly Li wrote:
> This patch adds a kernel module to test the consistency of multiple crc
> calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.
> 
> The test results are printed into kernel message, which look like,
> 
> test_crc: crc64_be: FAILED (0x03d4d0d85685d9a1, expected 0x3d4d0d85685d9a1f)
> 
> kernel 0day system has framework to check kernel message, then the above
> result can be handled by 0day system. If crc calculation inconsistency
> happens, it can be detected quite soon.
> 
> lib/test_crc.c is a testing frame work for many crc consistency
> testings. For now, there is only one test caes for crc64_be().

Are you aware there's already a CRC-32 test module: CONFIG_CRC32_SELFTEST and
lib/crc32test.c?  Confusingly, your patch uses a different naming convention for
the new CRC-64 one, and puts the Kconfig option in a different place, and makes
it sound like it's a generic test for all CRC implementations rather than just
the CRC-64 one.  Please use the existing convention (i.e. add
CONFIG_CRC64_SELFTEST and lib/crc64test.c) unless you have a strong argument for
why it should be done differently.

(And I don't think it makes sense to combine all CRC tests into one module,
since you should be able to e.g. enable just CRC32 and CRC32_SELFTEST without
also pulling in a dependency on all the other CRC variants.)

> +/* Add your crc test cases here */
> +static void test_crc64_be(struct crc_test_record *rec)
> +{
> +	u64 crc;
> +
> +	crc = crc64_be(rec->initval, rec->data, sizeof(rec->data));
> +	chk_and_msg(rec->name, crc, rec->expval);
> +}
> +
> +/*
> + * Set up your crc test initial data here.
> + * Do not change the existing items, they are hard coded with
> + * pre-calculated values.
> + */
> +static struct crc_test_record test_data[] = {
> +	{ .name		= "crc64_be",
> +	  .data		= { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
> +			    0xC711223CFA3E5BB5, 0x493366450E42ECDF },
> +	  .initval	= 0x61C8864680B583EB,
> +	  .expval	= 0xb2c863673f4292bf,
> +	  .handler	= test_crc64_be,
> +	},
> +	{}
> +};

This is incorrect; the test is checksumming data that has a CPU-specific
endianness.  So, it will fail on big-endian systems.  The data needs to be
declared as a byte or char array instead.  See e.g. what crypto/testmgr.h does
for crypto API algorithms.

Also please mark the test data structures 'const'.

- Eric
