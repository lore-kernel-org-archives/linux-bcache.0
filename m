From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: [PATCH 05/11] bcache: Correct printf()-style format length modifier
Date: Mon, 23 Sep 2013 23:17:30 -0700
Message-ID: <1380003456-19938-6-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380003456-19938-1-git-send-email-kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

=46rom: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>

drivers/md/bcache/btree.c: In function =E2=80=98bch_btree_node_read=E2=80=
=99:
drivers/md/bcache/btree.c:259: warning: format =E2=80=98%lu=E2=80=99 ex=
pects type =E2=80=98long unsigned int=E2=80=99, but argument 3 has type=
 =E2=80=98size_t=E2=80=99

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Signed-off-by: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index f9764e6..8fad840 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -255,7 +255,7 @@ void bch_btree_node_read(struct btree *b)
=20
 	return;
 err:
-	bch_cache_set_error(b->c, "io error reading bucket %lu",
+	bch_cache_set_error(b->c, "io error reading bucket %zu",
 			    PTR_BUCKET_NR(b->c, &b->key, 0));
 }
=20
--=20
1.8.4.rc3
