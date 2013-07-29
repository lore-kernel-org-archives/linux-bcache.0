From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH] bcache: Correct printf()-style format length modifier
Date: Mon, 29 Jul 2013 12:45:05 +0200
Message-ID: <1375094705-27302-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

drivers/md/bcache/btree.c: In function =E2=80=98bch_btree_node_read=E2=80=
=99:
drivers/md/bcache/btree.c:259: warning: format =E2=80=98%lu=E2=80=99 ex=
pects type =E2=80=98long unsigned int=E2=80=99, but argument 3 has type=
 =E2=80=98size_t=E2=80=99

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ee37288..60908de 100644
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
1.7.9.5
