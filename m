Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79C431A2B
	for <linux-bcache@vger.kernel.org>; Thu,  6 Aug 2026 09:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008144; cv=none; b=IEQsEp0eKdBS7qjncn7SsGgeBeON7oUe5A2R2tFoYn6z0yfE87X5mRP1R20cBlQs92oOTh3Wr6v8m2M3+iXhrfC32xyuilYFnpi2nS9TXwh4Xkr3Q+tlgqxV6qN0OgmPdmyWSlW2PJvxtCGUe8LO59TroncaQN73KSfb8+GAgNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008144; c=relaxed/simple;
	bh=eAkOXZtlwNYjPhDGjyZtRke2iyDCQ2QqdzoXZFHQk1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peYCzunsIpHhDshU1aF5XVT+lomJrzEhIgdwsnO/Eor2xAAPFseNaM3dlZNUiRYHirpt4JsD9Olr9tbXxw7qo9cbiKqYkqljlTY3XPIaetOVOiueUsa8qSXWueQpVj5N9q4n1Shv6XyJI/MjGUQw/GH6Jnz54qFDWB1MEfO9QGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XrnD5ycW; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XrnD5ycW"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-472326ca506so1329689f8f.2
        for <linux-bcache@vger.kernel.org>; Thu, 06 Aug 2026 02:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786008140; x=1786612940; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pcnhqt0EtUylxXGbjqsf+1Pc4DS5YZiCgI0VutNek2Q=;
        b=XrnD5ycWprfq6ZXTgx/sPzXa5ZnxABDwcpmPqfn9GG88R1oeKt24y55hESrkuenR00
         nCKpfv3AkKfF4BEvNi1Np0lFOrYCUwYWexMxsBnhPOx2mxRlL7ydg2m/kBT+aiUV3Zd3
         VESkJ5GGNCSExJTW9D+DzbWi1fVcVr4NwLIFru+84F1HhDvhmChS2J0YqoM0vX1T/1cK
         iAluYuFr7ppe3xH4njcLfGLfuvucdrfjmvVOh34RYec6puIycELs/LS1OFCHdSinjMYe
         umcNKcyjctdczgVSItKFxhC6REpSN1RTegig96f/He4KlWghfvQV4c9yOrOSyHOvsfie
         Z3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008140; x=1786612940;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pcnhqt0EtUylxXGbjqsf+1Pc4DS5YZiCgI0VutNek2Q=;
        b=dCcc9MUFivE+dhmlCbcGxWdw3UVfgw54PEyeDtWuFgrqQqDsEolAiRXspxN+rBR0u0
         JmpjZlSWCfDz+OMHkPa4LN9PqrOR94w8bTCXX9UdkOjdOQK9m2tnOSBil2I3cDP4Ers5
         eDWdQtBug1k/6c3KsPVzSa8p+m+rMI7rdE9+7Y8GKJIrGUqmNYj/RlCtWTxqvsL2oRcq
         teLb4jXy3BokBVxSUXvVK9wd6tLjNfuqEek1iOGF8v0QNmOrddS5EEYB7QaJQe40pMdo
         CmLkZF9NE9ASHEbM0+Y6sJPiMT82n7q/PMVzEBZS5aM+cflSVQzHoRL67hDoyck9RlWr
         B2uA==
X-Forwarded-Encrypted: i=1; AHgh+RpzSxN+gX2gBQiVCJx5R6L4MFuYGlIuQ3a1hQJcSR8gj7RsRgaHQ6LKFaXR5mD8illCoL5eZWpqY8mB4zs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9aB7cXmZX+3bjoEhkB+0WnfyUUwOrvJuQi+bISI0Ra374+bBV
	n2WBqE+Co0SSgM1rmpE0wCZRqjJ3r9xxeFZx0lP5UqQux4JgUmWY3XOdymuuiQR/YGo=
X-Gm-Gg: AR+sD13tzGIcnHuOrnDW070qJIhSq+fS2YQZRaKqblmpz1x1ejqeHJ2lULlp7yEvc0m
	6Zez/02Tsh2PIlN+RdKjZXPb2ijkPxOcUc/R/Lq/n7x7WynaQ+m0bm0ntTlLdk1RFG75RUgsCm9
	T58c//FYs78ghY+tHk12PWyqJjHLbAOhxZdSQLRdyrB0RtpSqsStg4NVd9eYrdHR5pgfSEJ6YBF
	+0Ob2dUv1Xqy2Evlk5Fp5wzZwME1DFp94XyzQMDCdrOsONo8/OxQqBa9ngFG0VtEq+5hnFIRDh0
	7JTlKBOLvTyJOkTJUvJJEPxnpDdCydVdjqp2XP5GFgsvW07LGXp7ypNQkO8wrpL+UiFaK6Ng228
	+xt9PyPZ894YvG93Iu+UH6ypQJMkCH3My/AjPX9FhQ0JoDONSlxPFeulfpU1xWKjuhOi9PeGsgw
	izdOQHfOFbi9KynlH6xFSIR+GVRCD7AS0/f2jUcwXHerilVOVkTKb+p8yvwnDpgt0g
X-Received: by 2002:a5d:624a:0:b0:47f:9750:26cc with SMTP id ffacd0b85a97d-47fec630b5cmr16574414f8f.23.1786008139632;
        Thu, 06 Aug 2026 02:22:19 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm4112794f8f.33.2026.08.06.02.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:22:18 -0700 (PDT)
Date: Thu, 6 Aug 2026 11:22:16 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Yu Kuai <yukuai@fygo.io>, 
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>, Tao Cui <cui.tao@linux.dev>, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-ID: <anRPSKHWo59GPIA0@localhost.localdomain>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-3-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ltojthlavrpt3nkl"
Content-Disposition: inline
In-Reply-To: <20260804065313.2092022-3-yukuai@kernel.org>


--ltojthlavrpt3nkl
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
MIME-Version: 1.0

Hi Kuai.

On Tue, Aug 04, 2026 at 02:53:12PM +0800, Yu Kuai <yukuai@kernel.org> wrote:
> From: Yu Kuai <yukuai@fygo.io>
>=20
> A bio currently stores a queue-local blkg reference.  This forces bio
> association and remap paths to look up or create a blkg even when the bio
> will never enter a blkcg policy.
>=20
> Store the blkcg css association in the bio instead, and derive the blkg
> from the bio's blkcg and current bdev when a policy needs it.  The first
> successful policy lookup pins the blkg, records the pin with BIO_BLKG_REF,
> and drops it from bio_clear_blkcg() or when bio_set_dev() changes the
> lookup key.
>=20
> Keep lookup-only users from creating missing blkgs by using
> bio_blkg_lookup(), and rename the bio cgroup association helpers to match
> the stored blkcg state.

I assume this should be OK due to limited lifetime of bios -- this would
not lead no possibly indefinite accumulation of offlined blkcgs,
correct?

> -void bio_associate_blkg_from_css(struct bio *bio,
> +void bio_associate_blkcg_from_css(struct bio *bio,
>  				 struct cgroup_subsys_state *css)
>  {
> -	if (bio_blkg(bio))
> -		blkg_put(bio_blkg(bio));
> +	struct blkcg *blkcg;
> =20
> -	if (css && css->parent) {
> -		bio->bi_blkg =3D blkg_tryget_closest(bio, css);
> -	} else {
> -		blkg_get(bdev_get_queue(bio->bi_bdev)->root_blkg);
> -		bio->bi_blkg =3D bdev_get_queue(bio->bi_bdev)->root_blkg;
> -	}
> +	if (!css || !css->parent)
> +		css =3D &blkcg_root.css;
> +
> +	blkcg =3D css_to_blkcg(css);
> +	if (bio_blkcg(bio) =3D=3D blkcg)
> +		return;
> +
> +	css_get(css);	<---
> +	bio_clear_blkcg(bio);
> +	bio->bi_blkcg =3D blkcg;
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg_from_css);

[skip to next comment below now]

And here yet another (any) reference to same css is taken 2nd time.

[skip after next comment below :)]


> =20
>  /**
> - * bio_associate_blkg - associate a bio with a blkg
> + * bio_associate_blkcg - associate a bio with a blkcg
>   * @bio: target bio
>   *
> - * Associate @bio with the blkg found from the bio's css and request_que=
ue.
> - * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
> - * already associated, the css is reused and association redone as the
> - * request_queue may have changed.
> + * Associate @bio with the blkcg found from the bio's css.  If a blkcg is
> + * already associated, keep it as blkcg association is not queue-local.
>   */
> -void bio_associate_blkg(struct bio *bio)


> +void bio_associate_blkcg(struct bio *bio)
>  {
>  	struct cgroup_subsys_state *css;
> =20
>  	if (blk_op_is_passthrough(bio->bi_opf))
>  		return;
> =20
> -	if (bio_blkg(bio)) {
> -		css =3D bio_blkcg_css(bio);
> -		bio_associate_blkg_from_css(bio, css);
> -	} else {
> -		rcu_read_lock();
> -		css =3D blkcg_css();
> -		if (!css_tryget_online(css))
> -			css =3D NULL;
> -		rcu_read_unlock();
> +	if (bio_blkcg(bio))
> +		return;
> =20
> -		bio_associate_blkg_from_css(bio, css);
> -		if (css)
> -			css_put(css);
> -	}
> +	rcu_read_lock();
> +	css =3D blkcg_css();
> +	if (!css_tryget_online(css))	<---
> +		css =3D NULL;
> +	rcu_read_unlock();
> +
> +	bio_associate_blkcg_from_css(bio, css);
> +	if (css)
> +		css_put(css);
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg);

next:
Here you take (online) reference to the blkcg->css.

[return back to previous comment]


after:
Ideally, no tasks should be in offlined (blk)cgs, so the `current` would
not resolve to blkcg_css() returning an offlined blkcgs. OTOH, it's
generally good not to do _new_ associations to an offlined blkcg.
Which is why I think this logic would better fit to
bio_associate_blkcg_from_css()


0.02=E2=82=AC,
Michal


--ltojthlavrpt3nkl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCanRSRBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ahf+gEA5FtU8iXyQA9tlhJdWJEf
nyf1IBDUt4tisH7UDE8KiSEBAP5BK6FXkSftml/wn918ol1iwizfBzFhephd2gZc
e3UL
=GgwG
-----END PGP SIGNATURE-----

--ltojthlavrpt3nkl--
