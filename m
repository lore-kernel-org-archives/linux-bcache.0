From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH]bcache : limit the bio max sectors to make request bug in
 raid0
Date: Wed, 17 Apr 2013 09:36:11 +0200
Message-ID: <516E50EB.6020902@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010500050005020606040304"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: Michael Balser <michael.balser-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------010500050005020606040304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

We are using your bcache-testing branch.

From 20ad8cfb8047df2d09a5a960610f02c555a31a4f Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Tue, 16 Apr 2013 14:59:04 +0200
Subject: [PATCH] limit the max sectors in bcache to fix the make request bug
 in raid10
During test bcache with raid1+0, we saw a lot of complain as below:
[ 2766.555172] md/raid0:md400: make_request bug: can't convert block
across chunks or bigger than 512k 953328 144

when the using dd or fio with bigger blocksize like 512k, limited the
bio_max_sectors resolve this issue.

Reported-by: Michael Balser <michael.balser-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Tested-by: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/md/bcache/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 9b63065..c5c36f7 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -181,7 +181,7 @@ static unsigned bch_bio_max_sectors(struct bio *bio)
 	ret = min(ret, queue_max_sectors(q));

 	WARN_ON(!ret);
-	ret = max_t(int, ret, bio_iovec(bio)->bv_len >> 9);
+	ret = min_t(int, ret, bio_iovec(bio)->bv_len >> 9);

 	return ret;
 }
-- 
1.7.9.5

--------------010500050005020606040304
Content-Type: text/x-patch;
 name="0001-limit-the-max-sectors-in-bcache-to-fix-the-make-requ.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-limit-the-max-sectors-in-bcache-to-fix-the-make-requ.pa";
 filename*1="tch"

From 20ad8cfb8047df2d09a5a960610f02c555a31a4f Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Tue, 16 Apr 2013 14:59:04 +0200
Subject: [PATCH] limit the max sectors in bcache to fix the make request bug
 in raid10
During test bcache with raid1+0, we saw a lot of complain as below:
[ 2766.555172] md/raid0:md400: make_request bug: can't convert block across chunks or bigger than 512k 953328 144

when the using dd or fio with bigger blocksize like 512k, limited the bio_max_sectors resolve this issue.

Reported-by: Michael Balser <michael.balser-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Tested-by: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/md/bcache/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 9b63065..c5c36f7 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -181,7 +181,7 @@ static unsigned bch_bio_max_sectors(struct bio *bio)
 	ret = min(ret, queue_max_sectors(q));
 
 	WARN_ON(!ret);
-	ret = max_t(int, ret, bio_iovec(bio)->bv_len >> 9);
+	ret = min_t(int, ret, bio_iovec(bio)->bv_len >> 9);
 
 	return ret;
 }
-- 
1.7.9.5


--------------010500050005020606040304--
