From: Coly Li <colyli@suse.de>
Subject: [PATCHv4] bcache: only permit to recovery read error when cache device is clean
Date: Tue, 17 Oct 2017 02:04:28 +0800
Message-ID: <20171016180428.123657-1-colyli@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, mlyle@lyle.org
Cc: linux-block@vger.kernel.org, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Nix <nix@esperi.org.uk>, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

When bcache does read I/Os, for example in writeback or writethrough mode,
if a read request on cache device is failed, bcache will try to recovery
the request by reading from cached device. If the data on cached device is
not synced with cache device, then requester will get a stale data.

For critical storage system like database, providing stale data from
recovery may result an application level data corruption, which is
unacceptible.

With this patch, for a failed read request in writeback or writethrough
mode, recovery a recoverable read request only happens when cache device
is clean. That is to say, all data on cached device is up to update.

For other cache modes in bcache, read request will never hit
cached_dev_read_error(), they don't need this patch.

Please note, because cache mode can be switched arbitrarily in run time, a
writethrough mode might be switched from a writeback mode. Therefore
checking dc->has_data in writethrough mode still makes sense.

Changelog:
V4: Fix parens error pointed by Michael Lyle.
v3: By response from Kent Oversteet, he thinks recovering stale data is a
    bug to fix, and option to permit it is unneccessary. So this version
    the sysfs file is removed.
v2: rename sysfs entry from allow_stale_data_on_failure  to
    allow_stale_data_on_failure, and fix the confusing commit log.
v1: initial patch posted.

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: Arne Wolf <awolf@lenovo.com>
Acked-by: Michael Lyle <mlyle@lyle.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Nix <nix@esperi.org.uk>
Cc: Kai Krakow <hurikhan77@gmail.com>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Junhui Tang <tang.junhui@zte.com.cn>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/request.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 681b4f12b05a..e7f769ff7234 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -697,8 +697,16 @@ static void cached_dev_read_error(struct closure *cl)
 {
 	struct search *s = container_of(cl, struct search, cl);
 	struct bio *bio = &s->bio.bio;
+	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
-	if (s->recoverable) {
+	/*
+	 * If cache device is dirty (dc->has_dirty is non-zero), then
+	 * recovery a failed read request from cached device may get a
+	 * stale data back. So read failure recovery is only permitted
+	 * when cache device is clean.
+	 */
+	if (s->recoverable &&
+	    (dc && !atomic_read(&dc->has_dirty))) {
 		/* Retry from the backing device: */
 		trace_bcache_read_retry(s->orig_bio);
 
-- 
2.13.6
