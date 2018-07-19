From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3 0/3] add crc64 calculation as kernel library
Date: Thu, 19 Jul 2018 10:45:55 +0800
Message-ID: <bfbd0932-1bd1-7198-62e7-d920daa1bb58@suse.de>
References: <20180717145525.50852-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717145525.50852-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Eric Biggers <ebiggers3@gmail.com>, Noah Massey <noah.massey@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

On 2018/7/17 10:55 PM, Coly Li wrote:
> This patch set adds basic implementation of crc64 calculation as Linux
> kernel library. Since bcache already does crc64 by itself, this patch
> set also modifies bcache code to use the new crc64 library routine.
> 
> bcache uses crc64 as storage checksum, if a change of crc lib routines
> results an inconsistent result, the unmatched checksum may make bcache
> 'think' the on-disk is corrupted, such change should be avoided or
> detected as early as possible. Therefore the last patch in this series
> adds a crc test framework, to check consistency of different calculations.
> 
> Changelog:
> v3: Remove little endian restriction and remove 'le' from function names.
>     Fixes all review comments of v2
> v2: Combine first two patches into one
>     Fixes all review comments of v1
> v1: Initial version.
> 
> Coly Li


Hi folks,

Many thanks for your review and comments, I do appreciate for your help.
Also thank Andrew to pick up the patches.

Coly Li
