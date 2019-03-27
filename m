From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 192/192] bcache: fix potential div-zero error of writeback_rate_p_term_inverse
Date: Wed, 27 Mar 2019 14:10:24 -0400
Message-ID: <20190327181025.13507-192-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 5b5fd3c94eef69dcfaa8648198e54c92e5687d6d ]

Current code already uses d_strtoul_nonzero() to convert input string
to an unsigned integer, to make sure writeback_rate_p_term_inverse
won't be zero value. But overflow may happen when converting input
string to an unsigned integer value by d_strtoul_nonzero(), then
dc->writeback_rate_p_term_inverse can still be set to 0 even if the
sysfs file input value is not zero, e.g. 4294967296 (a.k.a UINT_MAX+1).

If dc->writeback_rate_p_term_inverse is set to 0, it might cause a
dev-zero error in following code from __update_writeback_rate(),
	int64_t proportional_scaled =
		div_s64(error, dc->writeback_rate_p_term_inverse);

This patch replaces d_strtoul_nonzero() by sysfs_strtoul_clamp() and
limit the value range in [1, UINT_MAX]. Then the unsigned integer
overflow and dev-zero error can be avoided.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 503ad954ccc0..d9481640b3e1 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -286,7 +286,9 @@ STORE(__cached_dev)
 	sysfs_strtoul_clamp(writeback_rate_i_term_inverse,
 			    dc->writeback_rate_i_term_inverse,
 			    1, UINT_MAX);
-	d_strtoul_nonzero(writeback_rate_p_term_inverse);
+	sysfs_strtoul_clamp(writeback_rate_p_term_inverse,
+			    dc->writeback_rate_p_term_inverse,
+			    1, UINT_MAX);
 	d_strtoul_nonzero(writeback_rate_minimum);
 
 	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
-- 
2.19.1
