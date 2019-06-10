From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 01/12] Compiler Attributes: add __flatten
Date: Mon, 10 Jun 2019 15:14:09 -0400
Message-ID: <20190610191420.27007-2-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 include/linux/compiler_attributes.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 6b318efd8a..48b2c6ae6f 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -253,4 +253,9 @@
  */
 #define __weak                          __attribute__((__weak__))
 
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-flatten-function-attribute
+ */
+#define __flatten __attribute__((flatten))
+
 #endif /* __LINUX_COMPILER_ATTRIBUTES_H */
-- 
2.20.1
