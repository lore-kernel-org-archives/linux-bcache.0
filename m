From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next 3/3] bcache: Use %zu to format size_t
Date: Wed, 27 Mar 2013 18:56:30 +0100
Message-ID: <1364406990-20541-3-git-send-email-geert@linux-m68k.org>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-bcache@vger.kernel.org

m68k/allmodconfig:

drivers/md/bcache/debug.c: In function =E2=80=98bch_pbtree=E2=80=99:
drivers/md/bcache/debug.c:86: warning: format =E2=80=98%li=E2=80=99 exp=
ects type =E2=80=98long int=E2=80=99, but argument 4 has type =E2=80=98=
size_t=E2=80=99

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/bcache/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 141a5ca..210c985 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -82,7 +82,7 @@ struct keyprint_hack bch_pbtree(const struct btree *b=
)
 {
 	struct keyprint_hack r;
=20
-	snprintf(r.s, 40, "%li level %i/%i", PTR_BUCKET_NR(b->c, &b->key, 0),
+	snprintf(r.s, 40, "%zu level %i/%i", PTR_BUCKET_NR(b->c, &b->key, 0),
 		 b->level, b->c->root ? b->c->root->level : -1);
 	return r;
 }
--=20
1.7.0.4
