From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] bcache: Zero initialize bucket in bch_allocator_thread
Date: Thu,  7 Mar 2019 15:10:54 -0700
Message-ID: <20190307221054.13126-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-bcache@vger.kernel.org

When building with -Wsometimes-uninitialized, Clang warns:

drivers/md/bcache/alloc.c:333:4: warning: variable 'bucket' is used
uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

fifo_pop expands to a conditional depending on '!fifo_empty(...)', which
is the same condition as the while loop. It seems Clang can't piece
together that this condition will never been false as long as we are in
the while loop because they are the same condition. It's easy enough to
silence this warning by just explicitly zero initializing bucket.

Link: https://github.com/ClangBuiltLinux/linux/issues/396
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/md/bcache/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 5002838ea476..c72094901ac6 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -328,7 +328,7 @@ static int bch_allocator_thread(void *arg)
 		 * the free list:
 		 */
 		while (!fifo_empty(&ca->free_inc)) {
-			long bucket;
+			long bucket = 0;
 
 			fifo_pop(&ca->free_inc, bucket);
 
-- 
2.21.0
