From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 522/671] bcache: Fix an error code in bch_dump_read()
Date: Thu, 16 Jan 2020 12:02:40 -0500
Message-ID: <20200116170509.12787-259-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d66c9920c0cf984cf99cab5036fd5f3a1b7fba46 ]

The copy_to_user() function returns the number of bytes remaining to be
copied, but the intention here was to return -EFAULT if the copy fails.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8c53d874ada4..f6b60d5908f7 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -178,10 +178,9 @@ static ssize_t bch_dump_read(struct file *file, char __user *buf,
 	while (size) {
 		struct keybuf_key *w;
 		unsigned int bytes = min(i->bytes, size);
-		int err = copy_to_user(buf, i->buf, bytes);
 
-		if (err)
-			return err;
+		if (copy_to_user(buf, i->buf, bytes))
+			return -EFAULT;
 
 		ret	 += bytes;
 		buf	 += bytes;
-- 
2.20.1
