Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC339332629
	for <linux-bcache@vger.kernel.org>; Mon, 10 Aug 2026 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786397919; cv=pass; b=YIZE0NNPKKNEEdpxUHE7QWYC5wsE4i5+BFCpLRSdmGtRydDvh+DkYEdo+zzbkGrxBrcqaxRVGNXWTzIkfEK+vKaT9BSTYcBWqfm600awblRy5wUa/Ru344b+vc9gldSc/zqobpx/uqa0Si6sS5t89qp/uVmD+yln3D6++9KuPCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786397919; c=relaxed/simple;
	bh=B4PqLsNnfise4Oo9iSIYYP8RhbHNlrZrssB5s1H1srQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mf52QtjVNcNSx9IGn9++oXIxDeF5PH7troYXg06O6K/XdmwGmPWXcFS6UtJjMaBB4oHmyPvzGXuvQhoUhATcFrLE2pgoi7ROUTM5fyGiJLmn/VD+InOHVhWmYzAFFhZTrc5y54paFnKMmDnU2klu80QgIz6QSI4NirbIpAj3w54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XVXCW3Ez; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XVXCW3Ez"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so34161cf.1
        for <linux-bcache@vger.kernel.org>; Mon, 10 Aug 2026 14:38:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786397916; cv=none;
        d=google.com; s=arc-20260327;
        b=SkXsNrxe/PkD6h7zneqKZp9wIPk1DHydo5+YYPuAK1l7XoK4HKATmmRhKy7b4CLX1L
         A3gCGczOqIpgfSS4zVYrR30Wf9DHBx0D7g59fUIoosKINfxb08RxLJWqtdEySE2iaRbP
         BxfPnj+wQ1nGyXpAsqoExkQ2XKa/jyr5VBFIEPBFtWNNw2Wp6XW86lj+IpVY+T3vLjEd
         urxHlSaxoLl83/r4Sj7ocvklx7ObTOREFOl6+CkTBnCjh5gs9wvvQXOtj7VuPPuV1zwP
         7iikwzlSu8IxRq6+p9Yr3IjTAYNYVGAlUJbLmDzJgcGXuGXqOVN+yQimK9ubNWXCJvtk
         C1MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w2Ez9+gOwtlz1wpct3tCtRD3yFKVn5W3Jq+tYUZwRsc=;
        fh=9k3aeQZfOuZLpC5j0LWO4wZt9Vaw/MZIiuC46KHN94o=;
        b=kRnia4Mv9kOOueOG+S9OVIIztd/wy2Ur9ebxNFw937Es+Pn6XdarXJIagRLwW4R42j
         UCVYcLFtbh4GprnSFS1BVrFX2oaIdZJUSG1D6TC1a8Qwz8YaXFhhfpoFSGkUXE2jzP6D
         FsSP/UEh1YYeS0aKX5bNeY2yr6sknHFpilKpCiA5jB5litMw6AQe0oh4YRG9ClJXa8hl
         qcxAFb9q4s7yca199ogNYQz76jB0UllTA+1fMoPCRIAmNfIbt+KRvdlR3FbASc//puC7
         acK90gFqvcKMh+Hnn5LBe8uQugQtDP34BkB98lenOT2ILa3FrJdOwp2TUgMPYvn37GRb
         7BiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786397916; x=1787002716; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w2Ez9+gOwtlz1wpct3tCtRD3yFKVn5W3Jq+tYUZwRsc=;
        b=XVXCW3EzNVifOLjqLCiMSBnXzDBEsSNsF5Ukj8G5hz1D4k4xJrlyOXekzAg5+kuJms
         40EcKcWUbEqGSybWvNTheVaoV1Bou8KlVQ/+d8dy8mo5EmSAQGrMK3Nk0jhUzUAgGD5g
         0gCLDk49xwcYCmPxjwlqxJmvnobQvKAEyjK20NkZk6h5Fs62obrWkiCJ+1Dud0uJGwik
         fERccydLn3JmdfeDEyoQn93B0ABYP6m6+4Rj/udYLBn+/fk5/e5fkzoGkzKKBR7SGShY
         sSfixAlT3BMnrAOXCE1kYutovpWwRdWnkaAbwYcy+SUmlDVJRgjQRjtZOrvVooVn/aZH
         qoqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786397916; x=1787002716;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w2Ez9+gOwtlz1wpct3tCtRD3yFKVn5W3Jq+tYUZwRsc=;
        b=kvTB+qkQ6U96a9bWia75u1tm753v2uLrGxuvR/6QFD49x443rFzOXNP++wV81BDsja
         c4IIiF5obuvVXalqrGnOIpoVLu66HtChQmLqSBmzaWa+pEwmZbY8zJrEPmXTFBkxHjdi
         HHfG3u3x3IGTt7yfPUyJFyf11OXHDKjIbGnQb9lhAVAhyZygKiDmqOhT42KsOwqhgJAk
         gHVEpQAtasLDjDVnP8cCUIjtviNdbQGwYfzjhOYgSd908DQyvBoZYVnKO2E0OaUJPBue
         HgAtIqHJba6wipDaPdjNd7GunH+HzYjFbPVeySmcyqmrH2PG9J/C/gmhyRKdqxeBClol
         dg6g==
X-Gm-Message-State: AOJu0Yy+7BNW1AsJfro+CSa4IOfyLkINa2cHD5FYGT5ZRq1+SY4Fn7ub
	hqhqG7zFvtwS9Uny1fluJNc6VQOOwvZJzwwB4A/xyhGoMlSSv74mTpQlP8AJl6zLAgcz4uXgTy4
	IDer/M1MY9+uIM3BOocYWT0Acup4Z3qVnThptrvfb
X-Gm-Gg: AR+sD13akk7KvavNoxJV+nTJ8BigE1FPgJmSUdUy6JFitRGYvjV+0wUyEgwM4LlVi0i
	J8mIFu+2rcIhT59BAZV4msztruxjvLMDsPyK/5i8c5+aaBQ4J47BZTkKNBPyHF0FZT8EKf1AnVe
	4HI11kbG4kUCpXT/1zHv7DkB9iAkW5e4mwQZGq84cabaBCv0pNg2phIDBCf1rX2ZZyBRWcUXAtv
	4EuHYIz9oApHEPkcBjvl/6bbtWiG0CZDBwsPEe96QulzhR8EI5sz1CYDDPGW2FOGa+jPs6tClWf
	tMR9//w5TiMinE+LGFdJyY/HSp6OnS+L+CkKn7HnLtw=
X-Received: by 2002:a05:622a:992:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-52d53504d20mr1326701cf.5.1786397915401; Mon, 10 Aug 2026
 14:38:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113053630.54218-6-colyli@fnnas.com> <20260717005039.1953649-1-robertpang@google.com>
 <DD9682AB-F203-4106-8CF4-95F396A736D2@fygo.io> <CAJhEC07z6EmL42encTkdBsEhuXphwW08XkcrpdZseL4tx=B5mw@mail.gmail.com>
 <anQ3SNstTaytmxCn@studio.local>
In-Reply-To: <anQ3SNstTaytmxCn@studio.local>
From: Robert Pang <robertpang@google.com>
Date: Mon, 10 Aug 2026 14:38:24 -0700
X-Gm-Features: AUfX_mxEzhbO-4V64oCS1bxBaJxy9-bI0Be7EJADVsSnOwkj19tsIByoifEpyuI
Message-ID: <CAJhEC07hMrLgSvxh93AAPBFWHeV7S1v6jUfOtAbp-rCWisxgSQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] bcache: reduce gc latency by processing less nodes
 and sleep less time
To: Coly Li <colyli@fygo.io>
Cc: linux-bcache@vger.kernel.org, mingzhe.zou@easystack.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly

Thank you so much for taking the time to look into this and share your
insights and ease my concerns. Your explanation in this thread will
provide sufficient context for future reference, so I think we can
save the additional code comments.

Best regards
Robert Pang

On Thu, Aug 6, 2026 at 1:36=E2=80=AFAM Coly Li <colyli@fygo.io> wrote:
>
> On Tue, Jul 21, 2026 at 11:55:53AM +0800, Robert Pang wrote:
> > On Fri, Jul 17, 2026 at 9:20=E2=80=AFPM Coly Li <colyli@fygo.io> wrote:
> > >
> > > > 2026=E5=B9=B47=E6=9C=8817=E6=97=A5 08:50=EF=BC=8CRobert Pang <rober=
tpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > Hi Coly,
> > > >
> > > > I was reviewing this patch again and noticed that btree_gc_min_node=
s() reads the
> > > > atomic counter 'search_inflight'. This counter is incremented and d=
ecremented by
> > > > clients issuing front-side I/O. In this scenario, should we add a m=
emory barrier
> > > > (such as `smp_mb__before_atomic`) prior to `atomic_read()`?
> > > >
> > > > My concern is that if btree_gc_min_nodes() is inlined in the caller
> > > > btree_gc_recurse(), the compiler might hoist the `atomic_read()` ou=
tside of the
> > > > while loop where btree_gc_min_nodes() is inlined, preventing us fro=
m fetching the
> > > > latest counter value. Adding the barrier would guarantee we read th=
e updated
> > > > value.
> > > >
> > > > What are your thoughts on this?
> > >
> > > Hi Robert,
> > >
> > > At the first glance I feel the code was fine. But, it was almost 8 mo=
nths ago, to
> > > make sure I understand you correctly, can you place your comments wit=
h the exact
> > > code together, then let me response you more accurately.
> > >
> > > Thanks for the review.
> > >
> > > Coly Li
> >
> > Hi Coly
> >
> > My apology for missing the code context in the earlier email. Here are
> > the code snippets where my comments relate:
> >
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 210b59007d98..5d922d301ab6 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> >
> > @@ -1578,29 +1579,29 @@ static unsigned int btree_gc_count_keys(struct =
btree *b)
> >
> >  static size_t btree_gc_min_nodes(struct cache_set *c)
> >  {
> > - size_t min_nodes;
> > + size_t min_nodes =3D GC_NODES_MIN;
> >
> > - /*
> > - * Since incremental GC would stop 100ms when front
> > - * side I/O comes, so when there are many btree nodes,
> > - * if GC only processes constant (100) nodes each time,
> > - * GC would last a long time, and the front side I/Os
> > - * would run out of the buckets (since no new bucket
> > - * can be allocated during GC), and be blocked again.
> > - * So GC should not process constant nodes, but varied
> > - * nodes according to the number of btree nodes, which
> > - * realized by dividing GC into constant(100) times,
> > - * so when there are many btree nodes, GC can process
> > - * more nodes each time, otherwise, GC will process less
> > - * nodes each time (but no less than MIN_GC_NODES)
> > - */
> > - min_nodes =3D c->gc_stats.nodes / MAX_GC_TIMES;
> > - if (min_nodes < MIN_GC_NODES)
> > - min_nodes =3D MIN_GC_NODES;
> > + if (atomic_read(&c->search_inflight) =3D=3D 0) {
> > + size_t n =3D c->gc_stats.nodes >> MAX_GC_TIMES_SHIFT;
> > +
>
> If atomic_read(&c->search_inflight) =3D=3D 0, it means currently
> no front end I/O. Then the gc nodes can be a bit more for a
> more aggressive garbage collection.
>
> Because the front end I/Os compete btree locks with gc threads,
> I set a more aggresive garbage collection only when there is no
> front I/O coming.
>
>
> > + if (min_nodes < n)
> > + min_nodes =3D n;
> > + }
> >
> >   return min_nodes;
> >  }
> >
> > In the above code change of this patch, btree_gc_min_nodes() reads the
> > atomic counter 'search_inflight'. And this counter is incremented and
> > decremented by clients issuing front-side I/O below:
> >
> > drivers/md/bcache/request.c:
> >
> > static CLOSURE_CALLBACK(search_free)
> > {
> >   closure_type(s, struct search, cl);
> >
> >   atomic_dec(&s->iop.c->search_inflight);
> >
> >   if (s->iop.bio)
> >     bio_put(s->iop.bio);
> >
> >   bio_complete(s);
> >   closure_debug_destroy(cl);
> >   mempool_free(s, &s->iop.c->search);
> > }
> >
> > static inline struct search *search_alloc(struct bio *bio,
> > struct bcache_device *d, struct block_device *orig_bdev,
> > unsigned long start_time)
> > {
> >   struct search *s;
> >
> >   s =3D mempool_alloc(&d->c->search, GFP_NOIO);
> >
> >   closure_init(&s->cl, NULL);
> >   do_bio_hook(s, bio, request_endio);
> >   atomic_inc(&d->c->search_inflight);
> >   ...
> > }
> >
> > My concern is that if btree_gc_min_nodes() is inlined in the caller
> > btree_gc_recurse() below, the compiler might hoist the `atomic_read()`
> > outside of the while loop where btree_gc_min_nodes() is inlined,
> > preventing us from fetching the latest counter value after each btree
> > node is traversed.
> >
>
> It is possible, but I do this on purpose. Because accurately catching
> zero inflight counter is unncessary. Let me explain in next text block.
>
> > drivers/md/bcache/btree.c:
> >
> > static int btree_gc_recurse(struct btree *b, struct btree_op *op,
> >     struct closure *writes, struct gc_stat *gc)
> > {
> >   int ret =3D 0;
> >   bool should_rewrite;
> >   struct bkey *k;
> >   struct btree_iter_stack iter;
> >   struct gc_merge_info r[GC_MERGE_NODES];
> >   struct gc_merge_info *i, *last =3D r + ARRAY_SIZE(r) - 1;
> >
> >   bch_btree_iter_stack_init(&b->keys, &iter, &b->c->gc_done);
> >
> >   for (i =3D r; i < r + ARRAY_SIZE(r); i++)
> >     i->b =3D ERR_PTR(-EINTR);
> >
> >   while (1) {
> >     k =3D bch_btree_iter_next_filter(&iter.iter, &b->keys,
> >        bch_ptr_bad);
> >     ...
> >     if (gc->nodes >=3D (gc->nodes_pre + btree_gc_min_nodes(b->c))) {
> >       gc->nodes_pre =3D  gc->nodes;
> >       ret =3D -EAGAIN;
> >       break;
> >     }
> >     ..
> > }
> >
> > In this scenario, should we add a memory barrier (such as
> > `smp_mb__before_atomic`) prior to `atomic_read()` to guarantee we read
> > the updated value? I.e.
> >
>
> Such memory barrier hurts performance, and for hot I/O path, it might
> introduce obviouos negative performance impect. Fortunately for the
> condition you are concerned, it works well without memory barrier.
>
>
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 377052cbde5c..659b8706031a 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -1582,6 +1582,8 @@ static size_t btree_gc_min_nodes(struct cache_set=
 *c)
> >  {
> >         size_t min_nodes =3D GC_NODES_MIN;
> >
> > +       /* Fetch latest search_inflight count */
> > +       smp_mb__before_atomic();
> >         if (atomic_read(&c->search_inflight) =3D=3D 0) {
> >                 size_t n =3D c->gc_stats.nodes >> MAX_GC_TIMES_SHIFT;
> >
> > What are your thoughts on this?
>
> The motivation is, when the bcache device is idle (no front end I/Os),
> make garbage collection be more aggressive by scanning more btree nodes
> in each iteration. This is a try-best effort, the inflight counter is
> unncessary to be accurate 0. If the check in btree_gc_min_nodes(),
>         atomic_read(&c->search_inflight) =3D=3D 0
> fails, then just fails. And if the bcache device is really idle for a
> while, finally the above check will be true and a larger min_nodes will
> be returned from btree_gc_min_nodes().
>
> But if adding a single memory barrier only in btree_gc_min_nodes(), indee=
d
> it does't help too much. Memory barrier is also necessary for locations
> where the inflight counter are changed. Then this is why I name it as
> negative performance impact in previous text block.
>
> Maybe I need to add code comments to explain why memory barrier is
> unncessary in current btree_gc_min_nodes(). Does it help?
>
> Thanks for the quesiton.
>
> Coly Li
