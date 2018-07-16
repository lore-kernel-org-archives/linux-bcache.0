From: Coly Li <colyli@suse.de>
Subject: [PATCH 1/4] lib/crc64: add crc64 option to lib/Kconfig
Date: Tue, 17 Jul 2018 00:55:04 +0800
Message-ID: <20180716165507.23100-2-colyli@suse.de>
References: <20180716165507.23100-1-colyli@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716165507.23100-1-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Coly Li <colyli@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R . Rodriguez" <mcgrof@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This patch adds crc64 option entry in lib/Kconfig. This patch is part of
a patch originally written by Andy Shevchenko, Coly Li cherry-picks it
and compose the commit log for a re-written crc64 source code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
---
 lib/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index 706836ec314d..4059df9ec4c7 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -170,6 +170,14 @@ config CRC32_BIT
 
 endchoice
 
+config CRC64
+	tristate "CRC64 functions"
+	help
+	  This option is provided for the case where no in-kernel-tree
+	  modules require CRC64 functions, but a module built outside
+	  the kernel tree does. Such modules that use library CRC64
+	  functions require M he
+
 config CRC4
 	tristate "CRC4 functions"
 	help
-- 
2.17.1
