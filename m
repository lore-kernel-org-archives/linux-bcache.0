From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: [PATCH] bcache: fix compilation warning
Date: Sun, 12 May 2013 18:30:51 +0200
Message-ID: <1368376251-14622-1-git-send-email-vincent.stehle@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

The release function of a block device does not return a value; make
release_dev void. This fixes the following warning:

  drivers/md/bcache/super.c:653:2: warning: initialization from incompa=
tible pointer type [enabled by default]
  drivers/md/bcache/super.c:653:2: warning: (near initialization for =E2=
=80=98bcache_ops.release=E2=80=99) [enabled by default]

Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
---
 drivers/md/bcache/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c8046bc..b09beb2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -634,11 +634,10 @@ static int open_dev(struct block_device *b, fmode=
_t mode)
 	return 0;
 }
=20
-static int release_dev(struct gendisk *b, fmode_t mode)
+static void release_dev(struct gendisk *b, fmode_t mode)
 {
 	struct bcache_device *d =3D b->private_data;
 	closure_put(&d->cl);
-	return 0;
 }
=20
 static int ioctl_dev(struct block_device *b, fmode_t mode,
--=20
1.7.10.4
