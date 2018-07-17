From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3 0/3] add crc64 calculation as kernel library
Date: Tue, 17 Jul 2018 18:46:53 +0300
Message-ID: <b9e186e35d780a31077c8336315e86a8f0551523.camel@linux.intel.com>
References: <20180717145525.50852-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717145525.50852-1-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, 2018-07-17 at 22:55 +0800, Coly Li wrote:
> This patch set adds basic implementation of crc64 calculation as Linux
> kernel library. Since bcache already does crc64 by itself, this patch
> set also modifies bcache code to use the new crc64 library routine.
> 
> bcache uses crc64 as storage checksum, if a change of crc lib routines
> results an inconsistent result, the unmatched checksum may make bcache
> 'think' the on-disk is corrupted, such change should be avoided or
> detected as early as possible. Therefore the last patch in this series
> adds a crc test framework, to check consistency of different
> calculations.
> 

Thanks, I have commented individual patches, though I didn't see patch
3/3 and...

> Andy Shevchenko (1):
>   lib/crc64: add crc64 option to lib/Kconfig
> 
> Coly Li (3):
>   lib: add crc64 calculation routines
>   bcache: use routines from lib/crc64.c for CRC64 calculation
>   lib/test_crc: Add test cases for crc calculation

...this part looks weird.

Do you use `git format-patch --cover-letter`?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
