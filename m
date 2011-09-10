From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: [PATCH 2/7] Provide 64-bit arithmetic functions
Date: Sat, 10 Sep 2011 14:45:34 +0100
Message-ID: <1315662339-3115-2-git-send-email-mark@pogo.org.uk>
References: <1109101110320.2733@stax.localdomain>
 <1315662339-3115-1-git-send-email-mark@pogo.org.uk>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315662339-3115-1-git-send-email-mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Building on x86 (32-bit) gives linkage errors against __udivdi3 and
__umoddi3, which gcc uses to modulo and divide operations on 64-bit
numbers. eg. sector_t when divided by block_size, bucket_size

  ERROR: "__udivdi3" [block/bcache.ko] undefined!
  ERROR: "__umoddi3" [block/bcache.ko] undefined!

The recommended way to handle this in the kernel seems to be the do_div()
function. But since block_size, bucket_size etc. are restricted to powers
of 2 anyway, should we really be storing block size as a shift and a mask?

To get things running I just provided the following implementation in the
code, borrowed from a old patch by David Howells [1]

[1] http://lkml.org/lkml/2006/8/14/305
---
 block/bcache_util.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/block/bcache_util.c b/block/bcache_util.c
index ea707c9..8e147de 100644
--- a/block/bcache_util.c
+++ b/block/bcache_util.c
@@ -1,6 +1,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/debugfs.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/types.h>
@@ -659,3 +660,97 @@ uint64_t crc64(const void *data, size_t len)
 	return crc ^ 0xffffffffffffffff;
 }
 EXPORT_SYMBOL(crc64);
+
+/*
+ * calculate:
+ *	Q = a / b
+ *	R = a % b
+ * by long division (repeated shift and conditional subtract)
+ * - base2 long division does not require any usage of actual division or
+ *   multiplication instructions
+ */
+u64 __udivmoddi4(u64 a, u64 b, u64 *_r)
+{
+	u64 acc, Q;
+	u32 A;
+	int M;
+
+	/* dispose of trivialities first */
+	if (b >= a) {
+		if (b == a) {
+			if (_r)
+				*_r = 0;
+			return 1;
+		}
+		if (_r)
+			*_r = a;
+		return 0;
+	}
+
+	/* divide by two until at least one argument is odd */
+	while (!((a | b) & 1)) {
+		a >>= 1;
+		b >>= 1;
+	}
+
+	/* handle it as 64-bit divide by 32-bit if we can */
+	if (b <= 0xffffffffULL) {
+		acc = do_div(a, b);
+		if (_r)
+			*_r = acc;
+		return a;
+	}
+
+	/* skip any steps that don't need to be done given the magnitude of the
+	 * divisor:
+	 * - the divisor is at least 33 bits in size (log2(b) >= 32)
+	 * - load the accumulator with as many bits of the dividend as we can
+	 * - decant the remainder into a 32-bit variable since we will have
+	 *   fewer than 32-bits remaining
+	 */
+	M = ilog2(b >> 32) + 32;
+	acc = a >> (63 - M);
+	A = a;
+	A <<= M - 31;
+
+	Q = 0;
+
+	for (;;) {
+		if (acc >= b) {
+			/* reduce the accumulator if we can */
+			acc -= b;
+			Q |= 1ULL;
+		}
+
+		if (M >= 63)
+			break;
+
+		/* shift next-MSB from dividend into LSB of accumulator */
+		acc = acc << 1;
+		if (A & 0x80000000U)
+			acc |= 1ULL;
+		A <<= 1;
+		Q <<= 1;
+		M++;
+	}
+
+	/* the accumulator is left holding the remainder */
+	if (_r)
+		*_r = acc;
+
+	return Q;
+}
+
+u64 __udivdi3(u64 a, u64 b)
+{
+	return __udivmoddi4(a, b, NULL);
+}
+EXPORT_SYMBOL(__udivdi3);
+
+u64 __umoddi3(u64 a, u64 b)
+{
+	u64 r;
+	__udivmoddi4(a, b, &r);
+	return r;
+}
+EXPORT_SYMBOL(__umoddi3);
-- 
1.7.4.4
