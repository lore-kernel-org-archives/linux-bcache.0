From: colyli@suse.de
Subject: [PATCH 10/17] lib: crc64: include <linux/crc64.h> for 'crc64_be'
Date: Fri, 24 Jan 2020 01:01:35 +0800
Message-ID: <20200123170142.98974-11-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbgAWRCy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:54 -0500
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>, Coly Li <colyli@suse.de>

From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>

The crc64_be() is declared in <linux/crc64.h> so include
this where the symbol is defined to avoid the following
warning:

lib/crc64.c:43:12: warning: symbol 'crc64_be' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 lib/crc64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/crc64.c b/lib/crc64.c
index 0ef8ae6ac047..f8928ce28280 100644
--- a/lib/crc64.c
+++ b/lib/crc64.c
@@ -28,6 +28,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/crc64.h>
 #include "crc64table.h"
 
 MODULE_DESCRIPTION("CRC64 calculations");
-- 
2.16.4
