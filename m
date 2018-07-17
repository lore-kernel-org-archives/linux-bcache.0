From: Coly Li <colyli@suse.de>
Subject: [PATCH v2 3/3] lib/test_crc: Add test cases for crc calculation
Date: Tue, 17 Jul 2018 14:57:11 +0800
Message-ID: <20180717065711.28281-4-colyli@suse.de>
References: <20180717065711.28281-1-colyli@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717065711.28281-1-colyli@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>
List-Id: linux-bcache@vger.kernel.org

This patch adds a kernel module to test the consistency of multiple crc
calculation in Linux kernel. It is enabled with CONFIG_TEST_CRC enabled.

The test results are printed into kernel message, which look like,

test_crc: crc64_le: PASSED (0x4e6b1ff972fa8c55, expval 0x4e6b1ff972fa8c55)
test_crc: crc64_le_bch: PASSED (0x0e4f1391d7a4a62e, expval 0x0e4f1391d7a4a62e)
test_crc: crc64_le_update: FAILED (0x03d4d0d85685d9a1, expval 0x3d4d0d85685d9a1f)

kernel 0day system has framework to check kernel message, then the above
result can be handled by 0day system. If crc calculation inconsistency
happens, it can be detected quite soon.

lib/test_crc.c is a testing frame work for many crc consistency
testings. For now, there are only test caes for 3 crc routines,
- crc64_le()
- crc64_le_bch()
- crc64_le_update()

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
---
 lib/Kconfig.debug |  11 ++++
 lib/Makefile      |   1 +
 lib/test_crc.c    | 133 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)
 create mode 100644 lib/test_crc.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8838d1158d19..de7bddd23c30 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1911,6 +1911,17 @@ config TEST_SYSCTL
 
 	  If unsure, say N.
 
+config TEST_CRC
+	tristate "CRC calculation test driver"
+	depends on CRC64
+	default n
+	help
+	  This builds the "test_crc" module. This driver enables to test the
+	  CRC calculation consistency to make sure new modification does not
+	  break existing checksum calculation.
+
+	  if unsure, say N.
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	default n
diff --git a/lib/Makefile b/lib/Makefile
index 40c215181687..224d047d026a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_FIND_BIT_BENCHMARK) += find_bit_benchmark.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
 obj-$(CONFIG_TEST_SYSCTL) += test_sysctl.o
+obj-$(CONFIG_TEST_CRC) += test_crc.o
 obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o
 obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 CFLAGS_test_kasan.o += -fno-builtin
diff --git a/lib/test_crc.c b/lib/test_crc.c
new file mode 100644
index 000000000000..3a793005b813
--- /dev/null
+++ b/lib/test_crc.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CRC test driver
+ *
+ * Copyright (C) 2018 Coly Li <colyli@suse.de>
+ *
+ * This module provides an simple framework to check the consistency of
+ * Linux kernel CRC calculation routines in lib/crc*.c. This driver
+ * requires CONFIG_CRC* items to be enabled if the associated routines are
+ * tested here. The test results will be printed to kernel message
+ * when this test driver is loaded.
+ *
+ * Current test routines are,
+ * - crc64_le()
+ * - crc64_le_bch()
+ * - crc64_le_update()
+ *
+ */
+
+#include <linux/async.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/miscdevice.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/crc64.h>
+
+struct crc_test_record {
+	char	*name;
+	__le64	data[4];
+	__le64	initval;
+	__le64	expval;
+	int	(*handler)(struct crc_test_record *rec);
+};
+
+static int chk_and_msg(const char *name, __le64 crc, __le64 expval)
+{
+	int ret = 0;
+
+	if (crc == expval) {
+		pr_info("test_crc: %s: PASSED:(0x%016llx, expected 0x%016llx)",
+			name, crc, expval);
+	} else {
+		pr_err("test_crc: %s: FAILED:(0x%016llx, expected 0x%016llx)",
+			name, crc, expval);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/* Add your crc test cases here */
+static int test_crc64_le(struct crc_test_record *rec)
+{
+	__le64 crc;
+
+	crc = crc64_le(rec->data, sizeof(rec->data));
+	return chk_and_msg(rec->name, crc, rec->expval);
+}
+
+static int test_crc64_le_bch(struct crc_test_record *rec)
+{
+	__le64 crc;
+
+	crc = crc64_le_bch(rec->data, sizeof(rec->data));
+	return chk_and_msg(rec->name, crc, rec->expval);
+}
+
+static int test_crc64_le_update(struct crc_test_record *rec)
+{
+	__le64 crc = rec->initval;
+
+	crc = crc64_le_update(crc, rec->data, sizeof(rec->data));
+	return chk_and_msg(rec->name, crc, rec->expval);
+}
+
+/*
+ * Set up your crc test initial data here.
+ * Do not change the existing items, they are hard coded with
+ * pre-calculated values.
+ */
+static struct crc_test_record test_data[] = {
+	{ .name		= "crc64_le",
+	  .data		= { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
+			    0xC711223CFA3E5BB5, 0x493366450E42ECDF },
+	  .initval	= 0,
+	  .expval	= 0xe2b9911e7b997201,
+	  .handler	= test_crc64_le,
+	},
+	{ .name		= "crc64_le_bch",
+	  .data		= { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
+			    0xC711223CFA3E5BB5, 0x493366450E42ECDF },
+	  .initval	= 0,
+	  .expval	= 0xd2753a20fd862892,
+	  .handler	= test_crc64_le_bch,
+	},
+	{ .name		= "crc64_le_update",
+	  .data		= { 0x42F0E1EBA9EA3693, 0x85E1C3D753D46D26,
+			    0xC711223CFA3E5BB5, 0x493366450E42ECDF },
+	  .initval	= 0x61C8864680B583EB,
+	  .expval	= 0xb2c863673f4292bf,
+	  .handler	= test_crc64_le_update,
+	},
+	{}
+};
+
+
+static int __init test_crc_init(void)
+{
+	int i;
+	int v, ret = 0;
+
+	pr_info("Kernel CRC consitency testing:");
+	for (i = 0; test_data[i].name; i++) {
+		v = test_data[i].handler(&test_data[i]);
+		if (v < 0 && ret == 0)
+			ret = -EINVAL;
+	}
+
+	return ret;
+}
+late_initcall(test_crc_init);
+
+static void __exit test_crc_exit(void) { }
+module_exit(test_crc_exit);
+
+MODULE_DESCRIPTION("CRC consistency testing driver");
+MODULE_AUTHOR("Coly Li <colyli@suse.de>");
+MODULE_LICENSE("GPL v2");
-- 
2.17.1
