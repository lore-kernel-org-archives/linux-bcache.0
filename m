Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A09365A00
	for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 11:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996541; cv=pass; b=Iz5UL0z1Q7d3Mhwo8TEitV72OgR5Q2pmlj88RRU+kYty/aQvptf/NPJaZG9NtQYuEBV+zb+dcfTKAETS+voa2BIHfrxUoLc9Udy87rd747X8ZE/0ZpxQeuqPoiOIU+y7KHrNvH+mZhobfX1l0l7M0zZbq3I/MF8TDSNL6ZZkCp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996541; c=relaxed/simple;
	bh=K8DH7YHd7k3afgelcDe4MPeh8/6/Axo57k4MgBAjKUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c5vc86YoCAlWzfnVjyM14rD5z2CeqNdB2Um2u4gXg9/iJZqAESwBoUN7UJb0zZZif2yg6Jm3qkXVtzMQMh6u+dxvJuyAMB4lbP+jT/zS8QcABIxaTt1bd4ts0bvWI68GCjquqR7FmkxDHgk+H7WNKlKf8PO5lrxhlv41iVv37S0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y3FHQ3Ss; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3FHQ3Ss"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-501469b598fso45055821cf.3
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2026 03:55:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768996537; cv=none;
        d=google.com; s=arc-20240605;
        b=ZELaQqpYV46w8/9FprqAwRv+7KJSNvcgjd13L16U4IdooD+UjXqqOWj0kFG4a9Y3iH
         fEzo+Am6Soyf7p2kY/GlUwmwTkxiygZkJ80QtS7zdaaCi83UzHgzy6jXlBZ8Jok04mgO
         d85uRbdnwfzMdoHuLDyS8JI/W6lToMtzjEIqXz2vun3NtegNG1/xc+wcxLPMh2ufN2ym
         sOOFjPX69HXX8bBcCQQfmoypc+J4I8NdLFHNQLSIrWmI8E0R7LubN5bPMHQLdDKH3KbD
         y//kcfhNip8hs6DEVjwdZtiAHQ/lGCsqiXs+zVE0zGmW1UnFJahkm+vdkawFA7boUq1H
         yX/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V2tFG/1ntLKgxTobe+nJSK7vULQ3PgUXRLj5pZe+OH0=;
        fh=mbIUawnTbKnN/G/c09GNLsHWhOVJ4hvlf4pBi04Wp+c=;
        b=EnZgcOI2R1aPEg6Ek0FpxW5SFmBffCjCaLrmhc9TmohrY1UozbBDzSY8FckO57Q+XU
         dkpv2PT5To5LYx+yjGE0au4Vl22Pd8rqKHYQc0Et5Vi7iHtMrA4XR20k7otIj4jY6a4v
         dUQqWs+byF6wOBxSGFz3hpUoWDCvZHPlGvJV1e7M1PKKYMN106dRs5oSHdBILfb/udv4
         BKf3h4oedaFsiGM5hkCIby8bdkQ8/6StlobEeK+pYP1u4gK8uovSuisFnzBI+q0rPWSG
         bGug10rKq74UZj/yC+LKDRwZJTlQya/MbzzLF4KSwYcNGrJQ3cFo0OzQHTMcRJSeHr27
         tDHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768996537; x=1769601337; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2tFG/1ntLKgxTobe+nJSK7vULQ3PgUXRLj5pZe+OH0=;
        b=Y3FHQ3SsNrZ2dzZxLU55Hetw6UjKrSy3MMSXiMmDEmKpa1dlSguTCmTslfAmXRoIXT
         4vRviA3mwfYga6SWiO7WMym0Z1COpCsFxiribvWc4+VyEC0w/FwLShcKqIz3Fu+1Iw5g
         rgb+qSzVHyjiXEvI+qhFyt3Jepto4G+wdVWYibKHvjVBshKv7qjOThKgsoSTqECP2D93
         hnNVvN5s2qrYzv7XOeoh+wFqi0Na7SN2g7ujRNmetjvhXj7+3RvQCUbcDPC7RJt0kjEB
         SWAzYcnjVkdmVwPt9XnXUuKWMIdzcH9YoZNG6QGbX2qze7ei9lneYiCd7/Fi8tdSHgdd
         3egQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768996537; x=1769601337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V2tFG/1ntLKgxTobe+nJSK7vULQ3PgUXRLj5pZe+OH0=;
        b=HMpqnC7GJVT4QpqHmOXfqVsVhajTp50mPXFPDIZB26zXXxrtOi6h5yXP4EvKtSE4/6
         L+ui+urDpCTS7CSNg8v3Ib80wdNJX6/43bMUMIScwPj5F2pnrUBprKMZHK+nh28ESuFs
         da3Qs1YcnSuUL5ficqTQHCtm1Y3UvdUYsEKBipiI7DKPbd0Y2mz9U1XTiq6XjkC4/FnM
         qjYiNFe0ciKhTrphNjho8R9FZjhsc/4ixIimrVy4CeFBlG4KShY/uL81rG5sErlol3Fz
         leMB/Ve7eAd34VFvnOBd0xf9GpexHTDz841/XO+osJLwI39MsNIJ5pNp+f9JC5Lrhrq1
         96cA==
X-Forwarded-Encrypted: i=1; AJvYcCUrSRw+E6JXRjT5zW6GUk3rQVDBWJ68aQZn6UjcZmzcTSKdM5ZCvVwP6xdqGql1FrLKQtoBp6oIQwPuU5c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6qaoGKexuQiFVD9yBBsZ27Nj4xS+rchbJa9EW+6Ot2hvlgpUI
	ryzUMg9d+BtHVWapH7iAFUDR8Rt3O4AZc6XZte3/sfnGr1+/zgE8Lv5gq3d6V8vDr6uqx+Um0uJ
	YiNpfimIcn0zSd/BVPs4PmuBcMrkR2MA=
X-Gm-Gg: AZuq6aKMmotHKla6slq9vuh7KPYzFK2YhL7D82pYGciNjnlge/CPu/4JfYB0zaCPxqS
	d3fbzP9w6UdC64+qmBx2tAbWwUIfwtjbu34edNCGTlARgfimUMyiCj1sw2eMzaq4lYkyAr9D9IG
	gdo89C1PYwFgciWkArMma5OYb6E0eyDKWvf0WBQASnYcRYuQciMs92mhGLOmNKVNyj9dRsxJRiq
	mWwZm2pk2FYKJxKXnKU6hs8FDHxLQnCMpERpA8TFpQfHk2dpedw/tbcnsO/FYkF5wZOEX0=
X-Received: by 2002:ac8:5949:0:b0:4ff:b261:c6f4 with SMTP id
 d75a77b69052e-502a1e2931amr242526241cf.21.1768996537326; Wed, 21 Jan 2026
 03:55:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120023535.9109-1-zhangshida@kylinos.cn> <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
 <aW-DHlpo4dzKRB8K@studio.local> <322136ff-95f6-49f6-9126-05845f25b4e8@kernel.dk>
 <aXAoi9wTa7VWUiPj@studio.local>
In-Reply-To: <aXAoi9wTa7VWUiPj@studio.local>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Wed, 21 Jan 2026 19:55:01 +0800
X-Gm-Features: AZwV_Qh5Jodf1IWDD2f4t1zqqdCuxQ-ZklLBTNyT-6-F6b8h1V050fa6_zCvses
Message-ID: <CANubcdUT+PoGs3j=0ZN5jsntU-hNGHRFQoucKJZvYGXxFC75ng@mail.gmail.com>
Subject: Re: Fwd: [PATCH v2] bcache: use bio cloning for detached device requests
To: Coly Li <colyli@fnnas.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Sasha Levin <sashal@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-bcache@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zhangshida <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Coly Li <colyli@fnnas.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=8821=E6=97=A5=E5=
=91=A8=E4=B8=89 09:34=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Jan 20, 2026 at 08:01:52AM +0800, Jens Axboe wrote:
> > On 1/20/26 7:46 AM, Coly Li wrote:
> > >> @@ -949,6 +950,11 @@ static int bcache_device_init(struct
> > >> bcache_device *d, unsigned int block_size,
> > >>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> > >>                 goto out_ida_remove;
> > >>
> > >> +       if (bioset_init(&d->bio_detach, 4,
> > >                                     ^^^^^-> I feel 4 might be a bit s=
mall
> > > here. bio_detached set is for normal IO when backing device is not
> > > attached to a cache device. I would suggest to set the pool size to
> > > 128 or 256.
> >
> > Absolutely not, 4 is more than plenty. The pool elements are only ever
> > used if allocations fail, to guarantee forward progress. Setting aside
> > 128 or 256 for that case is utterly wasteful, you only need a couple. 4
> > is a good number, if anything it should be smaller (2).
>
> Hi Jens,
>
> Thanks for the information. Please correct me if I am wrong for the follo=
wing
> text,
> - If the backing is a normal SSD raid0, the IOPS without attached cache d=
evice
> might be more than thousands. In this case, I assume 128 or 256 might be =
more
> tolerant.
> - I see what =E2=80=984=E2=80=99 means, just not sure/comfortable when me=
mory pressure is high.
> And reserving 128/256 will occupy around 0.5~1MB memory, I feel such extr=
a
> memory is acceptable in bcache use case.
>
> Don't get me wrong, I totally trust you. If '4' works well enough for hig=
h
> memory pressure condition for detached bcache device, it is cool.
>
> Thanks in advance.
>
> Coly Li

Hi Jens, Coly,

Regarding the discussion on the bio_detached pool size: while 4 is
sufficient to guarantee forward progress, some high-load environments
may prefer a larger reserve to minimize allocation latency under
extreme memory pressure.

To provide a middle ground, I propose adding a generic bioset_resize()
interface to the block layer and exposing it through a new bcache
sysfs attribute 'detached_pool_size'.

This allows us to keep the default value conservative (e.g., 4) to
avoid unnecessary memory overhead, while giving users the flexibility
to tune the emergency reserves based on their specific hardware and
workload requirements.

The patch is attached below. Does this look like a reasonable
compromise?

Thanks,
Shida
------------
From 511d7404ce482d4ae8faf5911cf3e11bb791369e Mon Sep 17 00:00:00 2001
From: Shida Zhang <zhangshida@kylinos.cn>
Date: Wed, 21 Jan 2026 19:32:06 +0800
Subject: [PATCH] block/bcache: introduce bioset_resize() and use it in bcac=
he

Subsystems using bio_sets currently have their reserve pool sizes fixed at
initialization. In some scenarios, such as high-load storage environments o=
r
memory-constrained systems, it is beneficial to adjust these emergency
reserves dynamically without tearing down the entire bioset.

Introduce bioset_resize() to allow the resizing of the bio_pool, bvec_pool,
within an existing bio_set.

Additionally, update bcache to expose this functionality. A new sysfs
attribute 'detached_pool_size' is added to bcache devices, allowing users
to tune the emergency reserve for detached bios based on production
workloads.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c               | 30 ++++++++++++++++++++++++++++++
 drivers/md/bcache/sysfs.c | 34 ++++++++++++++++++++++++++++++++++
 include/linux/bio.h       |  1 +
 3 files changed, 65 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index e726c0e280a..8c80325e616 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1857,6 +1857,36 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);

+/**
+ * bioset_resize - resize a bio_set's reserve pools
+ * @bs: bio_set to resize
+ * @pool_size: new number of elements in the reserve pool
+ *
+ * Description:
+ *    Resizes the pre-allocated elements in a bio_set. This allows a subsy=
stem
+ *    to increase or decrease its emergency reserves dynamically.
+ *
+ * Return:
+ *    0 on success, -ENOMEM on failure.
+ */
+int bioset_resize(struct bio_set *bs, unsigned int pool_size)
+{
+ int ret;
+
+ ret =3D mempool_resize(&bs->bio_pool, pool_size);
+ if (ret)
+ return ret;
+
+ if (bs->bvec_pool.pool_data) {
+ ret =3D mempool_resize(&bs->bvec_pool, pool_size);
+ if (ret)
+ return ret;
+ }
+
+ return 0;
+}
+EXPORT_SYMBOL(bioset_resize);
+
 static int __init init_bio(void)
 {
  int i;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 72f38e5b6f5..de63c04dafe 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/sort.h>
 #include <linux/sched/clock.h>
+#include <linux/bio.h>

 extern bool bcache_is_reboot;

@@ -150,6 +151,8 @@ rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
+rw_attribute(detached_pool_size);
+

 static ssize_t bch_snprint_string_list(char *buf,
         size_t size,
@@ -167,6 +170,30 @@ static ssize_t bch_snprint_string_list(char *buf,
  return out - buf;
 }

+SHOW(bch_detached_pool_size)
+{
+ struct bcache_device *d =3D container_of(kobj, struct bcache_device, kobj=
);
+
+ return scnprintf(buf, PAGE_SIZE, "%u\n", d->bio_detached.bio_pool.min_nr)=
;
+}
+
+STORE(bch_detached_pool_size)
+{
+ struct bcache_device *d =3D container_of(kobj, struct bcache_device, kobj=
);
+ unsigned int v;
+ int ret;
+
+ /* Bcache STORE macro uses 'size', not 'count' */
+ if (kstrtouint(buf, 10, &v) || v < 1)
+ return -EINVAL;
+
+ ret =3D bioset_resize(&d->bio_detached, v);
+ if (ret)
+ return ret;
+
+ return size;
+}
+
 SHOW(__bch_cached_dev)
 {
  struct cached_dev *dc =3D container_of(kobj, struct cached_dev,
@@ -282,6 +309,9 @@ SHOW(__bch_cached_dev)
  return strlen(buf);
  }

+ if (attr =3D=3D &sysfs_detached_pool_size)
+ return bch_detached_pool_size_show(kobj, attr, buf);
+
 #undef var
  return 0;
 }
@@ -450,6 +480,9 @@ STORE(__cached_dev)
  if (attr =3D=3D &sysfs_stop)
  bcache_device_stop(&dc->disk);

+ if (attr =3D=3D &sysfs_detached_pool_size)
+ return bch_detached_pool_size_store(kobj, attr, buf, size);
+
  return size;
 }

@@ -540,6 +573,7 @@ static struct attribute *bch_cached_dev_attrs[] =3D {
 #endif
  &sysfs_backing_dev_name,
  &sysfs_backing_dev_uuid,
+ &sysfs_detached_pool_size,
  NULL
 };
 ATTRIBUTE_GROUPS(bch_cached_dev);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index c75a9b3672a..2d8a657000c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -354,6 +354,7 @@ enum {
 extern int bioset_init(struct bio_set *, unsigned int, unsigned int,
int flags);
 extern void bioset_exit(struct bio_set *);
 extern int biovec_init_pool(mempool_t *pool, int pool_entries);
+int bioset_resize(struct bio_set *bs, unsigned int pool_size);

 struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_=
vecs,
       blk_opf_t opf, gfp_t gfp_mask,
--=20
2.34.1
