Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB703559CD
	for <linux-bcache@vger.kernel.org>; Thu, 22 Jan 2026 01:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769046072; cv=pass; b=seaQ8wUeTZNjcysxg5uZtbALqFmyypaFFCtkr3GsTJlcG6K1QH3PugFGC5+Uzh+C4LhSAOJnpkpQyQm3R5Umk+kISFffyOa7RW9yTtTKhubCVhqDcDaazJFVDUHE1CK/cmCmGbjNsFrwZRK1GtRboufFqqQUbPCcMtqoE9Uat+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769046072; c=relaxed/simple;
	bh=B7CJjGpU3ZdSH0hedoUDfAef923J8NQ5zA1XB+qlmnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nKVq3oFxDekWFLzH9MzP+tisIXNEL09+plqUPvHCZTEtGvxWTZMK6P1ni//P/YVgp2k213DcYd931n/fQ4Kh6ofw9KnoMCQA3M8jn7LKFzttsI/lxCDXWTM4Es4PA5iJGLfPBQFNmRLDmAIgCf7FGIqM/YSRWja38XCnmC3y9IM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gY6nrnQY; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gY6nrnQY"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88a2e3bd3cdso5045076d6.0
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 17:41:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769046069; cv=none;
        d=google.com; s=arc-20240605;
        b=dVVUWtwQQ/34yjKSuwKlMWM4hJs+JfA3PYdJLcboEDIlDfZ/8Nm9uCoJ+JZ8UIaxCi
         z+IVdD+g0DEIBESonuLBWT84HxZjEn33uplInfQEoAnmPiz3hn89yhrkUAa5d/ariTj5
         O0yMdmgARSYvEOcxhRaBAAeYJ4s5sb6F9CJcn4k4m8bwz5no61Le8T0zkd1AWPXOild7
         jT/2Gi/VOQOZY04zc4ew4PZptsx0S5mcZqdAd/pnu6omHz4dwQB4K/QVvrRX/d7FKT/2
         lOZY9PEyT4Qg69JNxf6aAZgmdKCtrMUgjeLCiwP8emHJBRHoOIqy9ru8dxWa2UcLfRiC
         c1dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SkxqSxypaUI8slonreBvH2LdRBoF7BMwYW6lfxLlwIU=;
        fh=qpJAXddN7Khv0PXM1V0n8DLNjQrbJFo12PYFonu32xQ=;
        b=HhR0D44kr40k7QvCIKA9QALBRzmp8fzhX29axaT22nfCoTSfKz+0pilgKrSXJgsjNv
         Ie5dQY8fQJHK+3NlQ0CS9fFptQ4fBHVs8jTIFc5IUp/2Xf6uwM1FJw0kHrL4jip7iCu9
         epWqqGyCr6PpeJ/B0wSMwkhbNYcRLzEfM/H1GGTwu6qcnJUDm6wgaJwkfBjqrY63fL/s
         quLleCdo4yuHDvdZbdWLqxCNhs83te2if35Ng+BQFrw/wIi+PDk2EpA0+WmwQJxPnpa0
         w7ZaJly5N0N+eh3uxYbDEvC7UufI8CTRtWEwFCqXp2bQHCxzeVvG8A43yA4C+l7MfAeX
         ovTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769046069; x=1769650869; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkxqSxypaUI8slonreBvH2LdRBoF7BMwYW6lfxLlwIU=;
        b=gY6nrnQY0qhS+F8Yx+4XSLgClPQ2mWVeSo7o2bAjb1QEmZfRRvaUOqLYdTvc0lidJM
         8rS14Q+JScnOVLn1SddlU3jRZ6JW0Xs8Tt2w+68X92ImYrLxCdH5x3Xw4Ockl//tfI4U
         0JS2CycCgO7Vksg8BYWSc5PohwIanDSVUL8SSnKrEhP1DXmk2EJ2I5OCA5epdL+UmmgT
         1cKhKYH+KPpoWfcg6h32bQMjRVK99EGFu/hqM26WqX7QVSeUCvQa/4hNwH+yF9RvkMko
         /NXS42MLoth8iGbe+kc5nuhuP6IKt7CW8Xg5WVw8AMHMjm1Z0WQaQKOmFLK6zmf9ws6Q
         teGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769046069; x=1769650869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SkxqSxypaUI8slonreBvH2LdRBoF7BMwYW6lfxLlwIU=;
        b=YMa+xobtoByifdOgzx7OqKtTNzcQwmZBL++mTCJHvgL2P4uftMnPcIe659n0AcCIgZ
         rSMVFQl/8JoPj+gOZk6e6nztAbflLhWglEwd8elQT4NCTRSJUw7421Tc9buYi2lzriQs
         aKFD8ywAdBngj/qaZYRq7wOeOfyccPfFFSsxYKpmOnYpXarTfbPlzGA4/SJmoYPEZGrR
         q1B/dZMCBp5T2xVzn9t0H4lmt+9MKmPO56ZtKK7LNfrj0IoXPFwzKVNFkl7Z2LWcGDLC
         gykDmQisOp+AAP1M//PocyPQ+nzloIEKwzK5tdAgWQAD0cQNtMCRTNkLOhK7c6ho7MWi
         7eWQ==
X-Gm-Message-State: AOJu0YxxmbJXXeUuMXAmsmNDoGfxXBmDqBj4R2MXbB6lbG6b+Uo+sHPw
	j+/nB0cWLq8++on2YveBTB3NIVYUuassyMMe8NPEnFKxAGL91jHi6FsE0G3w+nH9wEsk3ULNY/B
	dGqNRNfzPTKN/GeguH6C6METy/Hp5pq4=
X-Gm-Gg: AZuq6aLM760vymk6Molj6l0/Gw3E0ljMJH7g6MtHe5TYqqBM5D6q5f3pba6klKBE3Dw
	knhFPg9yCsmQzXAqK7n3P7i0sGEnMb/PEFckwdmyyy9seexuA9kmOoR1idvSp0yp57QYVaTRgXI
	kUx2oVoOKkPuTEqvKwCmiw14n5HcPOaMCqrVnaSXpzs/56K6bnKpOpEBDI9LuVOD70Ya9mLai2n
	UlwhxxS9TQsJYgxp2qLvFalbqUu61djEkZssInyYGJrkKMViotFsFL6Q7Qb8IhvgfOcemU=
X-Received: by 2002:a05:6214:2a87:b0:894:6531:d61c with SMTP id
 6a1803df08f44-8947dfdc869mr21816826d6.19.1769046068875; Wed, 21 Jan 2026
 17:41:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260122013650.321766-1-zhangshida@kylinos.cn>
In-Reply-To: <20260122013650.321766-1-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 22 Jan 2026 09:40:32 +0800
X-Gm-Features: AZwV_Qgir7PsobGF2cyvLQBjqoSuEPCVIyvrLdRFydB0GZD5KwOa-iPBale82bw
Message-ID: <CANubcdUShtRu_t+VACzqpeEUdFtxqP+ErYFr-iWHgwqzD18Pog@mail.gmail.com>
Subject: Fwd: [PATCH v3] bcache: use bio cloning for detached device requests
To: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>
Cc: linux-bcache@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zhangshida <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

---------- Forwarded message ---------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A zhangshida <starzhangzsd@gmail.com>
Date: 2026=E5=B9=B41=E6=9C=8822=E6=97=A5=E5=91=A8=E5=9B=9B 09:37
Subject: [PATCH v3] bcache: use bio cloning for detached device requests
To: <colyli@fnnas.com>, <kent.overstreet@linux.dev>,
<axboe@kernel.dk>, <sashal@kernel.org>, <hch@infradead.org>
Cc: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
<zhangshida@kylinos.cn>, <starzhangzsd@gmail.com>, Christoph Hellwig
<hch@lst.de>


From: Shida Zhang <zhangshida@kylinos.cn>

Previously, bcache hijacked the bi_end_io and bi_private fields of
the incoming bio when the backing device was in a detached state.
This is fragile and breaks if the bio is needed to be processed by
other layers.

This patch transitions to using a cloned bio embedded within a private
structure. This ensures the original bio's metadata remains untouched.

Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
Co-developed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---


Changelog:
v2:
- Renamed `bio_detach` to `bio_detached`
https://lore.kernel.org/all/CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YG=
EH9Q@mail.gmail.com/

v1:
https://lore.kernel.org/all/20260115074811.230807-1-zhangshida@kylinos.cn/

 drivers/md/bcache/bcache.h  |  9 +++++
 drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
 drivers/md/bcache/super.c   | 12 +++++-
 3 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 8ccacba8554..ec9ff971508 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -273,6 +273,8 @@ struct bcache_device {

        struct bio_set          bio_split;

+       struct bio_set          bio_detached;
+
        unsigned int            data_csum:1;

        int (*cache_miss)(struct btree *b, struct search *s,
@@ -753,6 +755,13 @@ struct bbio {
        struct bio              bio;
 };

+struct detached_dev_io_private {
+       struct bcache_device    *d;
+       unsigned long           start_time;
+       struct bio              *orig_bio;
+       struct bio              bio;
+};
+
 #define BTREE_PRIO             USHRT_MAX
 #define INITIAL_PRIO           32768U

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7..a02aecac05c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
        continue_at(cl, cached_dev_bio_complete, NULL);
 }

-struct detached_dev_io_private {
-       struct bcache_device    *d;
-       unsigned long           start_time;
-       bio_end_io_t            *bi_end_io;
-       void                    *bi_private;
-       struct block_device     *orig_bdev;
-};
-
 static void detached_dev_end_io(struct bio *bio)
 {
-       struct detached_dev_io_private *ddip;
-
-       ddip =3D bio->bi_private;
-       bio->bi_end_io =3D ddip->bi_end_io;
-       bio->bi_private =3D ddip->bi_private;
+       struct detached_dev_io_private *ddip =3D
+               container_of(bio, struct detached_dev_io_private, bio);
+       struct bio *orig_bio =3D ddip->orig_bio;

        /* Count on the bcache device */
-       bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
+       bio_end_io_acct(orig_bio, ddip->start_time);

        if (bio->bi_status) {
-               struct cached_dev *dc =3D container_of(ddip->d,
-                                                    struct cached_dev, dis=
k);
+               struct cached_dev *dc =3D bio->bi_private;
+
                /* should count I/O error for backing device here */
                bch_count_backing_io_errors(dc, bio);
+               orig_bio->bi_status =3D bio->bi_status;
        }

-       kfree(ddip);
-       bio_endio(bio);
+       bio_put(bio);
+       bio_endio(orig_bio);
 }

-static void detached_dev_do_request(struct bcache_device *d, struct bio *b=
io,
-               struct block_device *orig_bdev, unsigned long start_time)
+static void detached_dev_do_request(struct bcache_device *d,
+               struct bio *orig_bio, unsigned long start_time)
 {
        struct detached_dev_io_private *ddip;
        struct cached_dev *dc =3D container_of(d, struct cached_dev, disk);
+       struct bio *clone_bio;

-       /*
-        * no need to call closure_get(&dc->disk.cl),
-        * because upper layer had already opened bcache device,
-        * which would call closure_get(&dc->disk.cl)
-        */
-       ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
-       if (!ddip) {
-               bio->bi_status =3D BLK_STS_RESOURCE;
-               bio_endio(bio);
+       if (bio_op(orig_bio) =3D=3D REQ_OP_DISCARD &&
+           !bdev_max_discard_sectors(dc->bdev)) {
+               bio_endio(orig_bio);
                return;
        }

-       ddip->d =3D d;
+       clone_bio =3D bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
+                                   &d->bio_detached);
+       if (!clone_bio) {
+               orig_bio->bi_status =3D BLK_STS_RESOURCE;
+               bio_endio(orig_bio);
+               return;
+       }
+
+       ddip =3D container_of(clone_bio, struct detached_dev_io_private, bi=
o);
        /* Count on the bcache device */
-       ddip->orig_bdev =3D orig_bdev;
+       ddip->d =3D d;
        ddip->start_time =3D start_time;
-       ddip->bi_end_io =3D bio->bi_end_io;
-       ddip->bi_private =3D bio->bi_private;
-       bio->bi_end_io =3D detached_dev_end_io;
-       bio->bi_private =3D ddip;
-
-       if ((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
-           !bdev_max_discard_sectors(dc->bdev))
-               detached_dev_end_io(bio);
-       else
-               submit_bio_noacct(bio);
+       ddip->orig_bio =3D orig_bio;
+
+       clone_bio->bi_end_io =3D detached_dev_end_io;
+       clone_bio->bi_private =3D dc;
+
+       submit_bio_noacct(clone_bio);
 }

 static void quit_max_writeback_rate(struct cache_set *c,
@@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)

        start_time =3D bio_start_io_acct(bio);

-       bio_set_dev(bio, dc->bdev);
        bio->bi_iter.bi_sector +=3D dc->sb.data_offset;

        if (cached_dev_get(dc)) {
+               bio_set_dev(bio, dc->bdev);
                s =3D search_alloc(bio, d, orig_bdev, start_time);
                trace_bcache_request_start(s->d, bio);

@@ -1237,9 +1227,10 @@ void cached_dev_submit_bio(struct bio *bio)
                        else
                                cached_dev_read(dc, s);
                }
-       } else
+       } else {
                /* I/O request sent to backing device */
-               detached_dev_do_request(d, bio, orig_bdev, start_time);
+               detached_dev_do_request(d, bio, start_time);
+       }
 }

 static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c17d4517af2..238d12ffdae 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *d)
        }

        bioset_exit(&d->bio_split);
+       bioset_exit(&d->bio_detached);
        kvfree(d->full_dirty_stripes);
        kvfree(d->stripe_sectors_dirty);

@@ -949,6 +950,11 @@ static int bcache_device_init(struct
bcache_device *d, unsigned int block_size,
                        BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
                goto out_ida_remove;

+       if (bioset_init(&d->bio_detached, 4,
+                       offsetof(struct detached_dev_io_private, bio),
+                       BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
+               goto out_bioset_split_exit;
+
        if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
                /*
                 * This should only happen with BCACHE_SB_VERSION_BDEV.
@@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device
*d, unsigned int block_size,

        d->disk =3D blk_alloc_disk(&lim, NUMA_NO_NODE);
        if (IS_ERR(d->disk))
-               goto out_bioset_exit;
+               goto out_bioset_detach_exit;

        set_capacity(d->disk, sectors);
        snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device
*d, unsigned int block_size,
        d->disk->private_data   =3D d;
        return 0;

-out_bioset_exit:
+out_bioset_detach_exit:
+       bioset_exit(&d->bio_detached);
+out_bioset_split_exit:
        bioset_exit(&d->bio_split);
 out_ida_remove:
        ida_free(&bcache_device_idx, idx);
--
2.34.1
