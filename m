From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 1/3] lib: add crc64 calculation routines
Date: Tue, 24 Jul 2018 13:33:52 +0000
Message-ID: <86570dc992b64bd5a9df0898e10ce643@AcuMS.aculab.com>
References: <20180717145525.50852-1-colyli@suse.de>
 <20180717145525.50852-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717145525.50852-2-colyli@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Coly Li' <colyli@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>
List-Id: linux-bcache@vger.kernel.org

From: Coly Li
> Sent: 17 July 2018 15:55
> 
> This patch adds the re-write crc64 calculation routines for Linux kernel.
> The CRC64 polynomical arithmetic follows ECMA-182 specification, inspired
> by CRC paper of Dr. Ross N. Williams
> (see http://www.ross.net/crc/download/crc_v3.txt) and other public domain
> implementations.
> 
> All the changes work in this way,
> - When Linux kernel is built, host program lib/gen_crc64table.c will be
>   compiled to lib/gen_crc64table and executed.

That seems excessive for a fixed table.
No real point doing more than putting a commented out copy of the code
with the initialisation data.

> - The output of gen_crc64table execution is an array called as lookup
>   table (a.k.a POLY 0x42f0e1eba9ea369) which contain 256 64bits-long
>   numbers, this talbe is dumped into header file lib/crc64table.h.
> - Then the header file is included by lib/crc64.c for normal 64bit crc
>   calculation.

How long are the buffers being processed?
For short buffers a lot of bytes will suffer cache line misses.
For longer buffers you'll be displacing 2k of data from the L1 data cache.
That could easily have a knock on effect on the surrounding code.

You might find that a nibble based loop and lookup table is faster.
Or, relying on the linearity of CRCs, separate lookup tables
for the high and low nibbles of each byte.

So replacing:
		crc = crc64table[t] ^ (crc << 8);
with:
		crc = crc64table_hi[t >> 4] ^ crc64table_lo[t & 15] ^ (crc << 8);

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
