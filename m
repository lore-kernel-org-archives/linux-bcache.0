From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Date: Wed, 27 Mar 2013 18:56:28 +0100
Message-ID: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-bcache@vger.kernel.org

m68k/allmodconfig:

drivers/md/bcache/bset.c: In function =E2=80=98bset_search_tree=E2=80=99=
:
drivers/md/bcache/bset.c:727: error: implicit declaration of function =E2=
=80=98prefetch=E2=80=99

drivers/md/bcache/btree.c: In function =E2=80=98bch_btree_node_get=E2=80=
=99:
drivers/md/bcache/btree.c:933: error: implicit declaration of function =
=E2=80=98prefetch=E2=80=99

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/bcache/bset.c  |    1 +
 drivers/md/bcache/btree.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 4dc9cb4..ea06946 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -10,6 +10,7 @@
 #include "debug.h"
=20
 #include <linux/random.h>
+#include <linux/prefetch.h>
=20
 /* Keylists */
=20
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 4005991..1d5f5f4 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/hash.h>
+#include <linux/prefetch.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <trace/events/bcache.h>
--=20
1.7.0.4
