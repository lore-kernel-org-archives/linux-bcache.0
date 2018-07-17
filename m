From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v3 1/3] lib: add crc64 calculation routines
Date: Tue, 17 Jul 2018 09:31:16 -0700
Message-ID: <20180717163116.GA75957@gmail.com>
References: <20180717145525.50852-1-colyli@suse.de>
 <20180717145525.50852-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180717145525.50852-2-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

Hi Coly,

On Tue, Jul 17, 2018 at 10:55:23PM +0800, Coly Li wrote:
> This patch adds the re-write crc64 calculation routines for Linux kernel.
> The CRC64 polynomical arithmetic follows ECMA-182 specification, inspired
> by CRC paper of Dr. Ross N. Williams
> (see http://www.ross.net/crc/download/crc_v3.txt) and other public domain
> implementations.

Please also mention who is planned to use this CRC-64 code.  Again, if it's just
one user then there's no need for this patchset yet.  If bcachefs is planned to
be another user (separate from bcache) then you need to say so.

> 
> All the changes work in this way,
> - When Linux kernel is built, host program lib/gen_crc64table.c will be
>   compiled to lib/gen_crc64table and executed.
> - The output of gen_crc64table execution is an array called as lookup
>   table (a.k.a POLY 0x42f0e1eba9ea369) which contain 256 64bits-long
>   numbers, this talbe is dumped into header file lib/crc64table.h.
> - Then the header file is included by lib/crc64.c for normal 64bit crc
>   calculation.
> - Function declaration of the crc64 calculation routines is placed in
>   include/linux/crc64.h
> 
> Changelog:
> v3: More fixes for review comments of v2
>     By review comments from Eric Biggers, current functions naming with
>     'le' is misleading. Remove 'le' from the crc function names, and use
>     u64 to replace __le64 in parameters and return values. 
> v2: Fix reivew comments of v1
> v1: Initial version.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Co-developed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Michael Lyle <mlyle@lyle.org>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> Cc: Eric Biggers <ebiggers3@gmail.com>
> ---
>  include/linux/crc64.h | 13 ++++++++
>  lib/.gitignore        |  2 ++
>  lib/Kconfig           |  8 +++++
>  lib/Makefile          | 11 +++++++
>  lib/crc64.c           | 71 +++++++++++++++++++++++++++++++++++++++++++
>  lib/gen_crc64table.c  | 69 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 174 insertions(+)
>  create mode 100644 include/linux/crc64.h
>  create mode 100644 lib/crc64.c
>  create mode 100644 lib/gen_crc64table.c
> 
> diff --git a/include/linux/crc64.h b/include/linux/crc64.h
> new file mode 100644
> index 000000000000..3e87b61cd54f
> --- /dev/null
> +++ b/include/linux/crc64.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * See lib/crc64.c for the related specification and polynomical arithmetic.
> + */
> +#ifndef _LINUX_CRC64_H
> +#define _LINUX_CRC64_H
> +
> +#include <linux/types.h>
> +
> +u64 __pure crc64_update(u64 crc, const void *_p, size_t len);
> +u64 __pure crc64(const void *p, size_t len);
> +u64 __pure crc64_bch(const void *p, size_t len);
> +#endif /* _LINUX_CRC64_H */

I still think you should make the API consistent with lib/crc32.c by replacing
the three functions with just:

	u64 __pure crc64_be(u64 crc, const void *p, size_t len);

Your API maps to it as follows:

	crc64_update(crc, p, len) == crc64_be(crc, p, len)
	crc64(p, len)             == crc64_be(0, p, len)
	crc64_bch(p, len)         == ~crc64_be(~0, p, len)

The "_be" suffix clarifies that it's not using the bit-reversed convention.  We
don't want to have to rename everything when someone needs to do CRC-64 using
the other convention.  The CRC-64 in the .xz file format, for example, uses the
bit-reversed convention.

The other problem with your API (besides it being inconsistent with lib/crc32.c)
is that as soon as the caller needs to do something nontrivial, like passing the
data in multiple chunks or using different conventions for the initial and final
values, then they actually have to use only "crc64_update()" anyway, which is
confusing as it makes it sound like there should be a "crc64_init()" and
"crc64_final()" to go along with "crc64_update()".

Also, naming CRC conventions after a specific user ("bch") isn't appropriate.

Thanks,

- Eric
