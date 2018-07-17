From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3 1/3] lib: add crc64 calculation routines
Date: Tue, 17 Jul 2018 18:43:05 +0300
Message-ID: <8f62965ad89f82b0f4bd73d6e5acf352dc2b767e.camel@linux.intel.com>
References: <20180717145525.50852-1-colyli@suse.de>
         <20180717145525.50852-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717145525.50852-2-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On Tue, 2018-07-17 at 22:55 +0800, Coly Li wrote:
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

Thanks for an update! My comments below.

> Co-developed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

As required by coding style this tag should be accompanied with SoB of
co-developer(s).

> +u64 __pure crc64_update(u64 crc, const void *_p, size_t len);

For sake of consistency I would name _len as well.

> + * Normal 64bit CRC calculation.

I think 64-bit form is slightly better and more often

$ git grep -n -w 64bit | wc -l
809

$ git grep -n -w 64-bit | wc -l
2957

> + * crc64table[256] is the lookup table of a table-driver 64bit CRC

Ditto.

> + * Copyright 2018 SUSE Linux.
> + *   Author: Coly Li <colyli@suse.de>

> + *

This (blank comment) line is not needed.

> +u64 __pure crc64_update(u64 crc, const void *_p, size_t len)

_len ?

> + * Copyright 2018 SUSE Linux.
> + *   Author: Coly Li <colyli@suse.de>

> + *

Not needed line.


> +#include <inttypes.h>
> +#include <stdio.h>

+ blank line? Would separate groups of headers logically.

> +#include <linux/swab.h>

> +static int64_t crc64_table[256] = {0,};

I guess {0} would work as well (no comma).

> +	printf("#include <uapi/linux/types.h>\n");
> +	printf("#include <linux/cache.h>\n\n");

Do wee need these? CRC32 case seems fine without.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
