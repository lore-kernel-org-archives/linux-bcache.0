Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC922B8DF
	for <linux-bcache@vger.kernel.org>; Tue, 21 Jul 2026 18:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660168; cv=pass; b=iOHcmuG/G4RKE2A6ICgRpKoM8VwO4SihDfpKXnNhb0sUHGAgo9K7eJqEFmqUkLTgcYQLnIvNpjFaoePDIxkfLUEMjVb/auXajYouHQ7IUo0CYkAKQ2NTi4BSae7SEEkEe8TkkMN9FhdjOjToAMSecyu+qpHir/EYQAIQLtWAk/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660168; c=relaxed/simple;
	bh=/4XN26JB1NGVCUDdRCT5jtSFI3AjzGs5/Z6w5N9Louk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jJ9nRN7F1mghKuU/DyXxY6heshyZ8ve0mNGcdVStepXhhj4dqXkEZyzINV2i0DWgdWtxe3Bar3zdJC/o2rYDjdSscmEUFUIyNJHrP5zCzw5EehfFmxmkJkQPKUvVVIEcedQlG3wFjwBBzsViUIwboOARiRGtg4zvhvZX2UPJ3hM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gq+Y7ZHR; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gq+Y7ZHR"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c15a5b265so1179801cf.0
        for <linux-bcache@vger.kernel.org>; Tue, 21 Jul 2026 11:56:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784660166; cv=none;
        d=google.com; s=arc-20260327;
        b=MhUJXAEetX6P9yjRvAyciqYOtzT3QdE/A6NQPCT8DfS5YRoY8rH9PKBVWxj8LPpqHb
         QLFf3/cc+mkiaYP/Qjiw7Pwf9wdC6/ecZnb9mXi922BvpnqiNyeuKBEyhQHTW2Ue3nL/
         cLColt8fUWE7xm0sD3biETO6clbl9KREV4Fq2j9sfUbYG2Ru717ftCHWbAb4cEQ9Thpm
         X3TfIC0Six0zJ/pm1nroPfij1OuDiCMt3YVsXGNtrBBZE8fLTz0nmJG8Q84Wbkvrvfnp
         wEkf0hhY6Ik7uwonra4QZEnmceU5zAt2zgFcMt+Ftmm509oLn4I6oUetO6PGOPD9EHzC
         sIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4CmAGbzkf1Q5qbPFWyLE6GiBmmjpAjO01vG4U8z8qn8=;
        fh=9k3aeQZfOuZLpC5j0LWO4wZt9Vaw/MZIiuC46KHN94o=;
        b=ksZ5R0acO/EX4SezYwywCTsxo0GMYUtdOiNvQtoS1BhDwkytOyEcWCzOP+dvqDNKmL
         yxIARaAZ6Bgonr5DO4IteC2yzywj9wBGbCP+pzff6E0s1TyB8yKYvGDqM8kovxdIEO0T
         aZQGpzLlL0nVI+iytg446ui/z2t6QkoSBOwdo7KyWjrDGkLpqlNNezqOUfdkWBOUNWyr
         +K60e3UaSAYzq8fpZwZE1o4cRPfjHlCGehjL/3uk+Zn7j9im/gJa0J9TMJNSPnmtRHDo
         5TVAOKctk9Els13Y/NMbCLwOKwplT3oI5wh+5AVc/8igLYPC8fXvgyqqCZOSz/082cwP
         /e6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784660166; x=1785264966; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4CmAGbzkf1Q5qbPFWyLE6GiBmmjpAjO01vG4U8z8qn8=;
        b=gq+Y7ZHRJ6VjaWY7GZnDQWqTQ7dcCj7Xym1r3Tk2TFUsZOsFTJXTRC5dPvuJGEXJIh
         R5vl2T0be2QXaQpM0o6lI8dJHmRBZXwrCJXa0ie/dEfO4oL11jejmxw9BO89M67nzORq
         vUmvNxQAXxhCDx6F9g2sjPxRitduKmyFpEPt65jczq0JcCKUNf12vebCHjEURq1BIfKE
         46mqVMiON2Cx4Wq7yObVn0VQ6gMmeldt6ZTxoKot7Cheyz+TeBfd7NIEeDnzCQxobrF7
         tXvjtkfUm46skorsHPCpGc0EJBJXgK5gLMIFcmofz2HXGDX6TBbwNhM5pecET35hk0N7
         rJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784660166; x=1785264966;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4CmAGbzkf1Q5qbPFWyLE6GiBmmjpAjO01vG4U8z8qn8=;
        b=Q2KUs4hrped5+hFldGvMNfQC0WvdyioAb+mCTRMK52fWiEtDdmsm+kczzMcP8ITarI
         pFBwL8wtV+KwiKkeT95TPT+RunrR+11PuUE3fBgkE9IvEihqM1nEk374hWnDhsHHnnQm
         whs4iOK1m4YuhEY/hLuU96ZVqQnVoz94btl9Hemqd4RNCCDEwT9myw183r9zIfWMPhN7
         HB95AOTVarwIKydzcvSlQkylj9uj5PbX6QNkdKeVDzsF9QWE1pM8RCO0wdlnA9MApR8x
         J+lzQFEzowwR8DwBcceg2ULywKjqamKcmCOKst5XPTbv1PxhjcA+vqhhme/2z69Dqss1
         nlNw==
X-Gm-Message-State: AOJu0YwHR9Xc8wFRAXLaRdA94XGY0ULK4XW7V3Q0WLBYuDVrx7qYBp0o
	qrWhsyj+Ov0C7tSmP8C4BQVv/ra89rHrp9PC5N+jipI6Yp7NcSlIrcSSOnKPFmlXc/MvYhpk2VM
	WddGWYNHELpXfNHo/845OudVKvdcl2nnuvikcbVTwPtXwucGXQUXIBQRl0D4=
X-Gm-Gg: AfdE7clyV+G3FQxMheDAg99Sv+vljO4pvYI7I+99uCEpk4HFKh6vKXHXbcqLtPh4Q+8
	yIKElool/9/l0gv3HR/CeY/G/SFGODyjvVYJ90nmtJjjNFm0I7I02u4c2MwKWP0sG5zP09n/kpL
	G3DAUUS+nGHe+QczIe/pd4XtjiXWLojigKYnWXvvpV3MoG9yVAcwEO3KaceuXiq25nC2XV4eM1P
	nbeL+ti35CgEQWrIgsgDxjRuJGeun4F4ApY2rh/3O8sWOAzNLXw53PvmqY9twawVbUpWPhS6scQ
	1XFow1dMR64Z4Bc7
X-Received: by 2002:a05:622a:aa43:10b0:51b:fe30:b8c5 with SMTP id
 d75a77b69052e-527c209bf65mr1382791cf.6.1784660165151; Tue, 21 Jul 2026
 11:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113053630.54218-6-colyli@fnnas.com> <20260717005039.1953649-1-robertpang@google.com>
 <DD9682AB-F203-4106-8CF4-95F396A736D2@fygo.io>
In-Reply-To: <DD9682AB-F203-4106-8CF4-95F396A736D2@fygo.io>
From: Robert Pang <robertpang@google.com>
Date: Tue, 21 Jul 2026 11:55:53 -0700
X-Gm-Features: AUfX_myOYwqcc3tzlLRFrLMDv8WdI66hBaVHrsLF8p1DQVLUGQdlsyxIDbuLy1o
Message-ID: <CAJhEC07z6EmL42encTkdBsEhuXphwW08XkcrpdZseL4tx=B5mw@mail.gmail.com>
Subject: Re: [PATCH 5/9] bcache: reduce gc latency by processing less nodes
 and sleep less time
To: Coly Li <colyli@fygo.io>
Cc: linux-bcache@vger.kernel.org, mingzhe.zou@easystack.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 9:20=E2=80=AFPM Coly Li <colyli@fygo.io> wrote:
>
> > 2026=E5=B9=B47=E6=9C=8817=E6=97=A5 08:50=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly,
> >
> > I was reviewing this patch again and noticed that btree_gc_min_nodes() =
reads the
> > atomic counter 'search_inflight'. This counter is incremented and decre=
mented by
> > clients issuing front-side I/O. In this scenario, should we add a memor=
y barrier
> > (such as `smp_mb__before_atomic`) prior to `atomic_read()`?
> >
> > My concern is that if btree_gc_min_nodes() is inlined in the caller
> > btree_gc_recurse(), the compiler might hoist the `atomic_read()` outsid=
e of the
> > while loop where btree_gc_min_nodes() is inlined, preventing us from fe=
tching the
> > latest counter value. Adding the barrier would guarantee we read the up=
dated
> > value.
> >
> > What are your thoughts on this?
>
> Hi Robert,
>
> At the first glance I feel the code was fine. But, it was almost 8 months=
 ago, to
> make sure I understand you correctly, can you place your comments with th=
e exact
> code together, then let me response you more accurately.
>
> Thanks for the review.
>
> Coly Li

Hi Coly

My apology for missing the code context in the earlier email. Here are
the code snippets where my comments relate:

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 210b59007d98..5d922d301ab6 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c

@@ -1578,29 +1579,29 @@ static unsigned int btree_gc_count_keys(struct btre=
e *b)

 static size_t btree_gc_min_nodes(struct cache_set *c)
 {
- size_t min_nodes;
+ size_t min_nodes =3D GC_NODES_MIN;

- /*
- * Since incremental GC would stop 100ms when front
- * side I/O comes, so when there are many btree nodes,
- * if GC only processes constant (100) nodes each time,
- * GC would last a long time, and the front side I/Os
- * would run out of the buckets (since no new bucket
- * can be allocated during GC), and be blocked again.
- * So GC should not process constant nodes, but varied
- * nodes according to the number of btree nodes, which
- * realized by dividing GC into constant(100) times,
- * so when there are many btree nodes, GC can process
- * more nodes each time, otherwise, GC will process less
- * nodes each time (but no less than MIN_GC_NODES)
- */
- min_nodes =3D c->gc_stats.nodes / MAX_GC_TIMES;
- if (min_nodes < MIN_GC_NODES)
- min_nodes =3D MIN_GC_NODES;
+ if (atomic_read(&c->search_inflight) =3D=3D 0) {
+ size_t n =3D c->gc_stats.nodes >> MAX_GC_TIMES_SHIFT;
+
+ if (min_nodes < n)
+ min_nodes =3D n;
+ }

  return min_nodes;
 }

In the above code change of this patch, btree_gc_min_nodes() reads the
atomic counter 'search_inflight'. And this counter is incremented and
decremented by clients issuing front-side I/O below:

drivers/md/bcache/request.c:

static CLOSURE_CALLBACK(search_free)
{
  closure_type(s, struct search, cl);

  atomic_dec(&s->iop.c->search_inflight);

  if (s->iop.bio)
    bio_put(s->iop.bio);

  bio_complete(s);
  closure_debug_destroy(cl);
  mempool_free(s, &s->iop.c->search);
}

static inline struct search *search_alloc(struct bio *bio,
struct bcache_device *d, struct block_device *orig_bdev,
unsigned long start_time)
{
  struct search *s;

  s =3D mempool_alloc(&d->c->search, GFP_NOIO);

  closure_init(&s->cl, NULL);
  do_bio_hook(s, bio, request_endio);
  atomic_inc(&d->c->search_inflight);
  ...
}

My concern is that if btree_gc_min_nodes() is inlined in the caller
btree_gc_recurse() below, the compiler might hoist the `atomic_read()`
outside of the while loop where btree_gc_min_nodes() is inlined,
preventing us from fetching the latest counter value after each btree
node is traversed.

drivers/md/bcache/btree.c:

static int btree_gc_recurse(struct btree *b, struct btree_op *op,
    struct closure *writes, struct gc_stat *gc)
{
  int ret =3D 0;
  bool should_rewrite;
  struct bkey *k;
  struct btree_iter_stack iter;
  struct gc_merge_info r[GC_MERGE_NODES];
  struct gc_merge_info *i, *last =3D r + ARRAY_SIZE(r) - 1;

  bch_btree_iter_stack_init(&b->keys, &iter, &b->c->gc_done);

  for (i =3D r; i < r + ARRAY_SIZE(r); i++)
    i->b =3D ERR_PTR(-EINTR);

  while (1) {
    k =3D bch_btree_iter_next_filter(&iter.iter, &b->keys,
       bch_ptr_bad);
    ...
    if (gc->nodes >=3D (gc->nodes_pre + btree_gc_min_nodes(b->c))) {
      gc->nodes_pre =3D  gc->nodes;
      ret =3D -EAGAIN;
      break;
    }
    ..
}

In this scenario, should we add a memory barrier (such as
`smp_mb__before_atomic`) prior to `atomic_read()` to guarantee we read
the updated value? I.e.

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 377052cbde5c..659b8706031a 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1582,6 +1582,8 @@ static size_t btree_gc_min_nodes(struct cache_set *c)
 {
        size_t min_nodes =3D GC_NODES_MIN;

+       /* Fetch latest search_inflight count */
+       smp_mb__before_atomic();
        if (atomic_read(&c->search_inflight) =3D=3D 0) {
                size_t n =3D c->gc_stats.nodes >> MAX_GC_TIMES_SHIFT;

What are your thoughts on this?

Best regards
Robert Pang
