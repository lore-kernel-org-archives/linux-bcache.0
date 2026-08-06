Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A3C41A928
	for <linux-bcache@vger.kernel.org>; Thu,  6 Aug 2026 08:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786005412; cv=none; b=iiP995KWBq16YU/cVyFUIvtumUolJfmtd3zToc0fZzOxbx9s7tc49y/7hX4909/XTAJCfQbD4Og2EiZelu5KxzlkYYCA6vNpUWgJhglcbNdBEOo3SJySRvQTLHNH7grqjyYDT0FMEBCaq2Jo9uEBz7N2BTpPC87Rm39wbOkCZeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786005412; c=relaxed/simple;
	bh=GuyHZ+UTAySEwbsM4CZAdonq1dmhm7LRR7bw6zYXYHM=;
	h=Subject:Date:References:Content-Type:To:Cc:From:Mime-Version:
	 Message-Id:Content-Disposition:In-Reply-To; b=bzi1+vk+Svc/UjTNnIEGJHk2MzvaMVqDbAxHJMrPvl5+PWstK+KPxsF/eYYTNu5MkotRm5v37nSaF/EEg61nRyUF5n9LF3uZ8us9otatOMjJY60Bha4X5UAepEY1rKgQX3fojD4DFk5/4CfdhIF9gUdFAMWUmz/Cm+Q5PJM8j9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=l6Lv4dSD; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="l6Lv4dSD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786005383;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ctyHbJ15EdXGldV2RZV5oF+IUsn3jEHq8Baf6W9MCqE=;
 b=l6Lv4dSDHS0a5/lQDuR6WDsTZ6GMtVDv7yJPXI3eL17jNHiuAVKtnyuibfFPN0ChWON0Lb
 lmIuPyHxfgO8otmibRFDq2auf+tk1VzUDaF0Oyo6Vnkt9aTDjwQW7eSMg13LbzJuM0Bjdq
 PeragevkuCnA7kGgospea9Kg4N6IC4B/3j6DbIOupktbinUd5iBtWLQrnB7qt0eAB/hIUO
 uFjnmTt6FniWs9KJvkZ1cJSDOkC2lq7v4wjXyprG6NlxLs7A77cXyOI/0ozGNVcamFYVJr
 7S8ucLloLO+7A+pcPsG30xNe5XUGQ9ZN0PHO7h1rmTcpmDP9XlvwPDmUmDsJ7w==
Subject: Re: [PATCH 5/9] bcache: reduce gc latency by processing less nodes and sleep less time
Date: Thu, 6 Aug 2026 16:36:19 +0800
References: <20251113053630.54218-6-colyli@fnnas.com> <20260717005039.1953649-1-robertpang@google.com> <DD9682AB-F203-4106-8CF4-95F396A736D2@fygo.io> <CAJhEC07z6EmL42encTkdBsEhuXphwW08XkcrpdZseL4tx=B5mw@mail.gmail.com>
X-Original-From: Coly Li <colyli@fygo.io>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Received: from studio.local ([120.245.64.97]) by smtp.larksuite.com with ESMTPS; Thu, 06 Aug 2026 08:36:21 +0000
X-Lms-Return-Path: <lba+26a744786+3682a0+vger.kernel.org+colyli@fygo.io>
To: "Robert Pang" <robertpang@google.com>
Cc: <linux-bcache@vger.kernel.org>, <mingzhe.zou@easystack.cn>
From: "Coly Li" <colyli@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <anQ3SNstTaytmxCn@studio.local>
Content-Disposition: inline
In-Reply-To: <CAJhEC07z6EmL42encTkdBsEhuXphwW08XkcrpdZseL4tx=B5mw@mail.gmail.com>

On Tue, Jul 21, 2026 at 11:55:53AM +0800, Robert Pang wrote:
> On Fri, Jul 17, 2026 at 9:20=E2=80=AFPM Coly Li <colyli@fygo.io> wrote:
> >
> > > 2026=E5=B9=B47=E6=9C=8817=E6=97=A5 08:50=EF=BC=8CRobert Pang <robertp=
ang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi Coly,
> > >
> > > I was reviewing this patch again and noticed that btree_gc_min_nodes(=
) reads the
> > > atomic counter 'search_inflight'. This counter is incremented and dec=
remented by
> > > clients issuing front-side I/O. In this scenario, should we add a mem=
ory barrier
> > > (such as `smp_mb__before_atomic`) prior to `atomic_read()`?
> > >
> > > My concern is that if btree_gc_min_nodes() is inlined in the caller
> > > btree_gc_recurse(), the compiler might hoist the `atomic_read()` outs=
ide of the
> > > while loop where btree_gc_min_nodes() is inlined, preventing us from =
fetching the
> > > latest counter value. Adding the barrier would guarantee we read the =
updated
> > > value.
> > >
> > > What are your thoughts on this?
> >
> > Hi Robert,
> >
> > At the first glance I feel the code was fine. But, it was almost 8 mont=
hs ago, to
> > make sure I understand you correctly, can you place your comments with =
the exact
> > code together, then let me response you more accurately.
> >
> > Thanks for the review.
> >
> > Coly Li
>=20
> Hi Coly
>=20
> My apology for missing the code context in the earlier email. Here are
> the code snippets where my comments relate:
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 210b59007d98..5d922d301ab6 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
>=20
> @@ -1578,29 +1579,29 @@ static unsigned int btree_gc_count_keys(struct bt=
ree *b)
>=20
>  static size_t btree_gc_min_nodes(struct cache_set *c)
>  {
> - size_t min_nodes;
> + size_t min_nodes =3D GC_NODES_MIN;
>=20
> - /*
> - * Since incremental GC would stop 100ms when front
> - * side I/O comes, so when there are many btree nodes,
> - * if GC only processes constant (100) nodes each time,
> - * GC would last a long time, and the front side I/Os
> - * would run out of the buckets (since no new bucket
> - * can be allocated during GC), and be blocked again.
> - * So GC should not process constant nodes, but varied
> - * nodes according to the number of btree nodes, which
> - * realized by dividing GC into constant(100) times,
> - * so when there are many btree nodes, GC can process
> - * more nodes each time, otherwise, GC will process less
> - * nodes each time (but no less than MIN_GC_NODES)
> - */
> - min_nodes =3D c->gc_stats.nodes / MAX_GC_TIMES;
> - if (min_nodes < MIN_GC_NODES)
> - min_nodes =3D MIN_GC_NODES;
> + if (atomic_read(&c->search_inflight) =3D=3D 0) {
> + size_t n =3D c->gc_stats.nodes >> MAX_GC_TIMES_SHIFT;
> +

If atomic_read(&c->search_inflight) =3D=3D 0, it means currently
no front end I/O. Then the gc nodes can be a bit more for a
more aggressive garbage collection.

Because the front end I/Os compete btree locks with gc threads,
I set a more aggresive garbage collection only when there is no
front I/O coming.


> + if (min_nodes < n)
> + min_nodes =3D n;
> + }
>=20
>   return min_nodes;
>  }
>=20
> In the above code change of this patch, btree_gc_min_nodes() reads the
> atomic counter 'search_inflight'. And this counter is incremented and
> decremented by clients issuing front-side I/O below:
>=20
> drivers/md/bcache/request.c:
>=20
> static CLOSURE_CALLBACK(search_free)
> {
>   closure_type(s, struct search, cl);
>=20
>   atomic_dec(&s->iop.c->search_inflight);
>=20
>   if (s->iop.bio)
>     bio_put(s->iop.bio);
>=20
>   bio_complete(s);
>   closure_debug_destroy(cl);
>   mempool_free(s, &s->iop.c->search);
> }
>=20
> static inline struct search *search_alloc(struct bio *bio,
> struct bcache_device *d, struct block_device *orig_bdev,
> unsigned long start_time)
> {
>   struct search *s;
>=20
>   s =3D mempool_alloc(&d->c->search, GFP_NOIO);
>=20
>   closure_init(&s->cl, NULL);
>   do_bio_hook(s, bio, request_endio);
>   atomic_inc(&d->c->search_inflight);
>   ...
> }
>=20
> My concern is that if btree_gc_min_nodes() is inlined in the caller
> btree_gc_recurse() below, the compiler might hoist the `atomic_read()`
> outside of the while loop where btree_gc_min_nodes() is inlined,
> preventing us from fetching the latest counter value after each btree
> node is traversed.
>=20

It is possible, but I do this on purpose. Because accurately catching
zero inflight counter is unncessary. Let me explain in next text block.

> drivers/md/bcache/btree.c:
>=20
> static int btree_gc_recurse(struct btree *b, struct btree_op *op,
>     struct closure *writes, struct gc_stat *gc)
> {
>   int ret =3D 0;
>   bool should_rewrite;
>   struct bkey *k;
>   struct btree_iter_stack iter;
>   struct gc_merge_info r[GC_MERGE_NODES];
>   struct gc_merge_info *i, *last =3D r + ARRAY_SIZE(r) - 1;
>=20
>   bch_btree_iter_stack_init(&b->keys, &iter, &b->c->gc_done);
>=20
>   for (i =3D r; i < r + ARRAY_SIZE(r); i++)
>     i->b =3D ERR_PTR(-EINTR);
>=20
>   while (1) {
>     k =3D bch_btree_iter_next_filter(&iter.iter, &b->keys,
>        bch_ptr_bad);
>     ...
>     if (gc->nodes >=3D (gc->nodes_pre + btree_gc_min_nodes(b->c))) {
>       gc->nodes_pre =3D  gc->nodes;
>       ret =3D -EAGAIN;
>       break;
>     }
>     ..
> }
>=20
> In this scenario, should we add a memory barrier (such as
> `smp_mb__before_atomic`) prior to `atomic_read()` to guarantee we read
> the updated value? I.e.
>=20

Such memory barrier hurts performance, and for hot I/O path, it might
introduce obviouos negative performance impect. Fortunately for the
condition you are concerned, it works well without memory barrier.


> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 377052cbde5c..659b8706031a 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1582,6 +1582,8 @@ static size_t btree_gc_min_nodes(struct cache_set *=
c)
>  {
>         size_t min_nodes =3D GC_NODES_MIN;
>=20
> +       /* Fetch latest search_inflight count */
> +       smp_mb__before_atomic();
>         if (atomic_read(&c->search_inflight) =3D=3D 0) {
>                 size_t n =3D c->gc_stats.nodes >> MAX_GC_TIMES_SHIFT;
>=20
> What are your thoughts on this?

The motivation is, when the bcache device is idle (no front end I/Os),
make garbage collection be more aggressive by scanning more btree nodes
in each iteration. This is a try-best effort, the inflight counter is
unncessary to be accurate 0. If the check in btree_gc_min_nodes(),
	atomic_read(&c->search_inflight) =3D=3D 0
fails, then just fails. And if the bcache device is really idle for a
while, finally the above check will be true and a larger min_nodes will
be returned from btree_gc_min_nodes().

But if adding a single memory barrier only in btree_gc_min_nodes(), indeed
it does't help too much. Memory barrier is also necessary for locations
where the inflight counter are changed. Then this is why I name it as
negative performance impact in previous text block.

Maybe I need to add code comments to explain why memory barrier is
unncessary in current btree_gc_min_nodes(). Does it help?

Thanks for the quesiton.

Coly Li
