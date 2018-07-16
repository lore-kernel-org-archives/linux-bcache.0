From: Coly Li <colyli@suse.de>
Subject: [PATCH 2/4] lib: add crc64 calculation routines
Date: Tue, 17 Jul 2018 00:55:05 +0800
Message-ID: <20180716165507.23100-3-colyli@suse.de>
References: <20180716165507.23100-1-colyli@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716165507.23100-1-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Luis R . Rodriguez" <mcgrof@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

This patch adds the re-write crc64 calculation routines for Linux kernel.
The CRC64 polynomical arithmetic follows ECMA-182 specification, inspired
by CRC paper of Dr. Ross N. Williams
(see http://www.ross.net/crc/download/crc_v3.txt) and other public domain
implementations.

All the changes work in this way,
- When Linux kernel is built, host program lib/gen_crc64table.c will be
  compiled to lib/gen_crc64table and executed.
- The output of gen_crc64table execution is an array called as lookup
  table (a.k.a POLY 0x42f0e1eba9ea369) which contain 256 64bits-long
  numbers, this talbe is dumped into header file lib/crc64table.h.
- Then the header file is included by lib/crc64.c for normal 64bit crc
  calculation.
- Function declaration of the crc64 calculation routines is placed in
  include/linux/crc64.h

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Michael Lyle <mlyle@lyle.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
---
 include/linux/crc64.h | 15 +++++++++
 lib/.gitignore        |  2 ++
 lib/Makefile          | 11 +++++++
 lib/crc64.c           | 71 +++++++++++++++++++++++++++++++++++++++
 lib/gen_crc64table.c  | 77 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 176 insertions(+)
 create mode 100644 include/linux/crc64.h
 create mode 100644 lib/crc64.c
 create mode 100644 lib/gen_crc64table.c

diff --git a/include/linux/crc64.h b/include/linux/crc64.h
new file mode 100644
index 000000000000..cbd10a47d861
--- /dev/null
+++ b/include/linux/crc64.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * crc64.h
+ *
+ * See lib/crc64.c for the related specification and polynomical arithmetic.
+ */
+#ifndef _LINUX_CRC64_H
+#define _LINUX_CRC64_H
+
+#include <linux/types.h>
+
+__le64 crc64_le_update(__le64 crc, const void *_p, size_t len);
+__le64 crc64_le(const void *p, size_t len);
+__le64 crc64_le_bch(const void *p, size_t len);
+#endif /* _LINUX_CRC64_H */
diff --git a/lib/.gitignore b/lib/.gitignore
index 09aae85418ab..f2a39c9e5485 100644
--- a/lib/.gitignore
+++ b/lib/.gitignore
@@ -2,5 +2,7 @@
 # Generated files
 #
 gen_crc32table
+gen_crc64table
 crc32table.h
+crc64table.h
 oid_registry_data.c
diff --git a/lib/Makefile b/lib/Makefile
index 90dc5520b784..40c215181687 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_CRC16)	+= crc16.o
 obj-$(CONFIG_CRC_T10DIF)+= crc-t10dif.o
 obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
+obj-$(CONFIG_CRC64)     += crc64.o
 obj-$(CONFIG_CRC32_SELFTEST)	+= crc32test.o
 obj-$(CONFIG_CRC4)	+= crc4.o
 obj-$(CONFIG_CRC7)	+= crc7.o
@@ -215,7 +216,9 @@ obj-$(CONFIG_FONT_SUPPORT) += fonts/
 obj-$(CONFIG_PRIME_NUMBERS) += prime_numbers.o
 
 hostprogs-y	:= gen_crc32table
+hostprogs-y	+= gen_crc64table
 clean-files	:= crc32table.h
+clean-files	+= crc64table.h
 
 $(obj)/crc32.o: $(obj)/crc32table.h
 
@@ -225,6 +228,14 @@ quiet_cmd_crc32 = GEN     $@
 $(obj)/crc32table.h: $(obj)/gen_crc32table
 	$(call cmd,crc32)
 
+$(obj)/crc64.o: $(obj)/crc64table.h
+
+quiet_cmd_crc64 = GEN     $@
+      cmd_crc64 = $< > $@
+
+$(obj)/crc64table.h: $(obj)/gen_crc64table
+	$(call cmd,crc64)
+
 #
 # Build a fast OID lookip registry from include/linux/oid_registry.h
 #
diff --git a/lib/crc64.c b/lib/crc64.c
new file mode 100644
index 000000000000..03f078303bd3
--- /dev/null
+++ b/lib/crc64.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Normal 64bit CRC calculation.
+ *
+ * This is a basic crc64 implementation following ECMA-182 specification,
+ * which can be found from,
+ * http://www.ecma-international.org/publications/standards/Ecma-182.htm
+ *
+ * Dr. Ross N. Williams has a great document to introduce the idea of CRC
+ * algorithm, here the CRC64 code is also inspired by the table-driven
+ * algorithm and detail example from this paper. This paper can be found
+ * from,
+ * http://www.ross.net/crc/download/crc_v3.txt
+ *
+ * crc64table_le[256] is the lookup table of a table-driver 64bit CRC
+ * calculation, which is generated by gen_crc64table.c in kernel build
+ * time. The polynomial of crc64 arithmetic is from ECMA-182 specification
+ * as well, which is defined as,
+ *
+ * x^64 + x^62 + x^57 + x^55 + x^54 + x^53 + x^52 + x^47 + x^46 + x^45 +
+ * x^40 + x^39 + x^38 + x^37 + x^35 + x^33 + x^32 + x^31 + x^29 + x^27 +
+ * x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^9 +
+ * x^7 + x^4 + x + 1
+ *
+ * Copyright 2018 SUSE Linux.
+ *   Author: Coly Li <colyli@suse.de>
+ *
+ */
+
+#include <linux/module.h>
+#include <uapi/linux/types.h>
+#include "crc64table.h"
+
+MODULE_DESCRIPTION("CRC64 calculations");
+MODULE_LICENSE("GPL");
+
+__le64 crc64_le_update(__le64 crc, const void *_p, size_t len)
+{
+	size_t i, t;
+
+	const unsigned char *p = _p;
+
+	for (i = 0; i < len; i++) {
+		t = ((crc >> 56) ^ (__le64)(*p++)) & 0xFF;
+		crc = crc64table_le[t] ^ (crc << 8);
+	}
+
+	return crc;
+}
+EXPORT_SYMBOL_GPL(crc64_le_update);
+
+__le64 crc64_le(const void *p, size_t len)
+{
+	__le64 crc = 0x0000000000000000ULL;
+
+	crc = crc64_le_update(crc, p, len);
+
+	return crc;
+}
+EXPORT_SYMBOL_GPL(crc64_le);
+
+/* For checksum calculation in drivers/md/bcache/ */
+__le64 crc64_le_bch(const void *p, size_t len)
+{
+	__le64 crc = 0xFFFFFFFFFFFFFFFFULL;
+
+	crc = crc64_le_update(crc, p, len);
+
+	return (crc ^ 0xFFFFFFFFFFFFFFFFULL);
+}
+EXPORT_SYMBOL_GPL(crc64_le_bch);
diff --git a/lib/gen_crc64table.c b/lib/gen_crc64table.c
new file mode 100644
index 000000000000..5f292f287498
--- /dev/null
+++ b/lib/gen_crc64table.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generate lookup table for the talbe-driven CRC64 calculation.
+ *
+ * gen_crc64table is executed in kernel build time and generates
+ * lib/crc64table.h. This header is included by lib/crc64.c for
+ * the table-driver CRC64 calculation.
+ *
+ * See lib/crc64.c for more information about which specification
+ * and polynomical arithmetic that gen_crc64table.c follows to
+ * generate the lookup table.
+ *
+ * Copyright 2018 SUSE Linux.
+ *   Author: Coly Li <colyli@suse.de>
+ *
+ */
+
+#include <inttypes.h>
+#include <linux/swab.h>
+#include <stdio.h>
+#include "../usr/include/asm/byteorder.h"
+
+#define CRC64_ECMA182_POLY 0x42F0E1EBA9EA3693ULL
+
+#ifdef __LITTLE_ENDIAN
+#  define cpu_to_le64(x) ((__le64)(x))
+#else
+#  define cpu_to_le64(x) ((__le64)__swab64(x))
+#endif
+
+static int64_t crc64_table[256] = {0,};
+
+static void generate_crc64_table(void)
+{
+	uint64_t i, j, c, crc;
+
+	for (i = 0; i < 256; i++) {
+		crc = 0;
+		c = i << 56;
+
+		for (j = 0; j < 8; j++) {
+			if ((crc ^ c) & 0x8000000000000000ULL)
+				crc = (crc << 1) ^ CRC64_ECMA182_POLY;
+			else
+				crc <<= 1;
+			c <<= 1;
+		}
+
+		crc64_table[i] = crc;
+	}
+
+}
+
+static void print_crc64le_table(void)
+{
+	int i;
+
+	printf("/* this file is generated - do not edit */\n\n");
+	printf("#include <uapi/linux/types.h>\n");
+	printf("#include <linux/cache.h>\n\n");
+	printf("static const __le64 ____cacheline_aligned crc64table_le[256] = {\n");
+	for (i = 0; i < 256; i++) {
+		printf("\t0x%016" PRIx64 "ULL", cpu_to_le64(crc64_table[i]));
+		if (i & 0x1)
+			printf(",\n");
+		else
+			printf(", ");
+	}
+	printf("};\n");
+}
+
+int main(int argc, char *argv[])
+{
+	generate_crc64_table();
+	print_crc64le_table();
+	return 0;
+}
-- 
2.17.1
