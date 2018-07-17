From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 1/3] lib: add crc64 calculation routines
Date: Tue, 17 Jul 2018 12:57:24 +0300
Message-ID: <4a25d281a0e7f622872f1e9fe3abf44288ec87e4.camel@linux.intel.com>
References: <20180717065711.28281-1-colyli@suse.de>
         <20180717065711.28281-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717065711.28281-2-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, 2018-07-17 at 14:57 +0800, Coly Li wrote:
> This patch adds the re-write crc64 calculation routines for Linux
> kernel.
> The CRC64 polynomical arithmetic follows ECMA-182 specification,
> inspired
> by CRC paper of Dr. Ross N. Williams
> (see http://www.ross.net/crc/download/crc_v3.txt) and other public
> domain
> implementations.
> 
> All the changes work in this way,
> - When Linux kernel is built, host program lib/gen_crc64table.c will
> be
>   compiled to lib/gen_crc64table and executed.
> - The output of gen_crc64table execution is an array called as lookup
>   table (a.k.a POLY 0x42f0e1eba9ea369) which contain 256 64bits-long
>   numbers, this talbe is dumped into header file lib/crc64table.h.
> - Then the header file is included by lib/crc64.c for normal 64bit crc
>   calculation.
> - Function declaration of the crc64 calculation routines is placed in
>   include/linux/crc64.h

> + * crc64.h
> + *

Do we need file name in the file?

> + * See lib/crc64.c for the related specification and polynomical
> arithmetic.
> + */

> +// SPDX-License-Identifier: GPL-2.0

> +#include <linux/module.h>
> +#include <uapi/linux/types.h>

Why not simple linux/types.h ?

> +#include "crc64table.h"
> +
> +MODULE_DESCRIPTION("CRC64 calculations");

> +MODULE_LICENSE("GPL");

License mismatch with SPDX.

> +#include <inttypes.h>
> +#include <linux/swab.h>
> +#include <stdio.h>

I would follow the common grouping of the headers, like more generic
first, more particular last:

inttupes
stdio

linux/foo

asm/bar

> +#include "../usr/include/asm/byteorder.h"

Hmm...


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
