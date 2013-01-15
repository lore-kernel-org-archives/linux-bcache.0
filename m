From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 2/4] Export get_random_int()
Date: Tue, 15 Jan 2013 13:25:40 -0800
Message-ID: <1358285142-10576-2-git-send-email-koverstreet@google.com>
References: <1358285142-10576-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358285142-10576-1-git-send-email-koverstreet@google.com>
In-Reply-To: <20130114223202.GV26407@google.com>
References: <20130114223202.GV26407@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, Theodore Ts'o <tytso@mit.edu>
List-Id: linux-bcache@vger.kernel.org

Needed for bcache - need a cheap source of random numbers for perturbing
IO sizes, for rate limiting IO to the SSD.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 85e81ec..d6f673e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1481,6 +1481,7 @@ unsigned int get_random_int(void)
 
 	return ret;
 }
+EXPORT_SYMBOL(get_random_int);
 
 /*
  * randomize_range() returns a start address such that
-- 
1.7.12
