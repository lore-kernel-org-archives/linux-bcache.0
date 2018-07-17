From: Coly Li <colyli@suse.de>
Subject: [PATCH v3 0/3] add crc64 calculation as kernel library
Date: Tue, 17 Jul 2018 22:55:22 +0800
Message-ID: <20180717145525.50852-1-colyli@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

This patch set adds basic implementation of crc64 calculation as Linux
kernel library. Since bcache already does crc64 by itself, this patch
set also modifies bcache code to use the new crc64 library routine.

bcache uses crc64 as storage checksum, if a change of crc lib routines
results an inconsistent result, the unmatched checksum may make bcache
'think' the on-disk is corrupted, such change should be avoided or
detected as early as possible. Therefore the last patch in this series
adds a crc test framework, to check consistency of different calculations.

Changelog:
v3: Remove little endian restriction and remove 'le' from function names.
    Fixes all review comments of v2
v2: Combine first two patches into one
    Fixes all review comments of v1
v1: Initial version.

Coly Li

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
---
Andy Shevchenko (1):
  lib/crc64: add crc64 option to lib/Kconfig

Coly Li (3):
  lib: add crc64 calculation routines
  bcache: use routines from lib/crc64.c for CRC64 calculation
  lib/test_crc: Add test cases for crc calculation

 drivers/md/bcache/bcache.h  |   7 +-
 drivers/md/bcache/btree.c   |   2 +-
 drivers/md/bcache/request.c |   2 +-
 drivers/md/bcache/super.c   |   5 +-
 drivers/md/bcache/util.c    | 131 ----------------------------------
 drivers/md/bcache/util.h    |   5 +-
 include/linux/crc64.h       |  15 ++++
 lib/.gitignore              |   2 +
 lib/Kconfig                 |   8 +++
 lib/Kconfig.debug           |  11 +++
 lib/Makefile                |  12 ++++
 lib/crc64.c                 |  71 +++++++++++++++++++
 lib/gen_crc64table.c        |  76 ++++++++++++++++++++
 lib/test_crc.c              | 136 ++++++++++++++++++++++++++++++++++++
 14 files changed, 341 insertions(+), 142 deletions(-)
 create mode 100644 include/linux/crc64.h
 create mode 100644 lib/crc64.c
 create mode 100644 lib/gen_crc64table.c
 create mode 100644 lib/test_crc.c

-- 
2.17.1
