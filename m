From: Coly Li <colyli@suse.de>
Subject: [PATCH v4 0/3] add crc64 calculation as kernel library
Date: Thu, 19 Jul 2018 00:55:42 +0800
Message-ID: <20180718165545.1622-1-colyli@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Kate Stewart <kstewart@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-bcache@vger.kernel.org

This patch set adds basic implementation of crc64 calculation as Linux
kernel library. Since bcache already does crc64 by itself, this patch
set also modifies bcache code to use the new crc64 library routine.

Currently bcache is the only user of crc64 calculation, another potential
user is bcachefs which is on the way to be in mainline kernel. Therefore
it makes sense to make crc64 calculation to be a public library.

bcache uses crc64 as storage checksum, if a change of crc lib routines
results an inconsistent result, the unmatched checksum may make bcache
'think' the on-disk is corrupted, such change should be avoided or
detected as early as possible. Therefore the last patch in this series
adds a crc test framework, to check consistency of different calculations. 

Coly Li

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
Changelog:
v4: Only keep crc64_be() in lib/crc64.c, tested bcache specific stuffs 
    moved back to bcache code.
    Fixes all review comments of v3.
v3: Remove little endian restriction and remove 'le' from function names.
    Fixes all review comments of v2
v2: Combine first two patches into one
    Fixes all review comments of v1
v1: Initial version.

Coly Li (3):
  lib: add crc64 calculation routines
  bcache: use routines from lib/crc64.c for CRC64 calculation
  lib/test_crc: Add test cases for crc calculation

 drivers/md/bcache/Kconfig |   1 +
 drivers/md/bcache/util.c  | 131 --------------------------------------
 drivers/md/bcache/util.h  |  21 ++++--
 include/linux/crc64.h     |  11 ++++
 lib/.gitignore            |   2 +
 lib/Kconfig               |   8 +++
 lib/Kconfig.debug         |  10 +++
 lib/Makefile              |  12 ++++
 lib/crc64.c               |  56 ++++++++++++++++
 lib/gen_crc64table.c      |  68 ++++++++++++++++++++
 lib/test_crc.c            |  93 +++++++++++++++++++++++++++
 11 files changed, 278 insertions(+), 135 deletions(-)
 create mode 100644 include/linux/crc64.h
 create mode 100644 lib/crc64.c
 create mode 100644 lib/gen_crc64table.c
 create mode 100644 lib/test_crc.c

-- 
2.17.1
