From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
Date: Wed, 15 Jan 2014 10:06:24 +0100
Message-ID: <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:57841 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaAOKtz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 15 Jan 2014 05:49:55 -0500
In-Reply-To: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

drivers/md/bcache/btree.c: In function =E2=80=98insert_u64s_remaining=E2=
=80=99:
drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer=
 types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 98cc0a810a36..c2ebc850d9a9 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree =
*b)
 	if (b->keys.ops->is_extents)
 		ret -=3D KEY_MAX_U64S;
=20
-	return max(ret, 0L);
+	return max_t(ssize_t, ret, 0L);
 }
=20
 static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op=
,
--=20
1.7.9.5
