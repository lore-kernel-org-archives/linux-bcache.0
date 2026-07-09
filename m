Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A033CEBA9
	for <linux-bcache@vger.kernel.org>; Thu,  9 Jul 2026 06:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783578668; cv=none; b=PFDIbUEHfIlRaabPnjf97SEnzf3Eb5aIt3+n6ezEzLcaad9uGHFk5qLenk85CJr2+P0nLyjHak2rqRrq6R6NB3v1iemmRXFGefoQuLno4oxZkjibQlIERwybXe79Dw1foIgt34lhX0AqlpCbmNooWsvUrC2WlPNHLLuFRU+aPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783578668; c=relaxed/simple;
	bh=tfA18FZOnYPpQxz/k0O7WfsJGTE14cKdLg4TFkXHTXs=;
	h=Content-Type:From:Date:References:In-Reply-To:Cc:Message-Id:
	 Mime-Version:To:Subject; b=LiwKgO6tVga+10j/gD8jjXphRX1xsg91YGN3ktmQ/7yPb1rh366VA82WtuaUDrSmN6ecsQY0Nu2MvVLcxRFJEIqEcmCdm26oHEBWQm2kL9tazz5NlmbGm8zYivAuw+3uSBBnycQoBknnlTDbmAmyqd31WT2XqmN9dOtgK5SiG3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bTNQG94u; arc=none smtp.client-ip=209.127.231.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bTNQG94u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783578655;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4H3ENV8rb0vXQAFFJgvVw/RCxbNTkugc/uw49+mlQow=;
 b=bTNQG94unvm8SbWv0Oecf4HgnXJ4G1xV3k6LmTbib178NvyRNquSIBbDnQKW9eN+3fNugg
 o4RnfqGYXvRXVvYvAaBna86WKkfGoOt9tXw9I0AVGb80LbXc2j/sFNoFegoFbotzdz4PVc
 r77///KfVDaMcXqQq1bylQu7GTQPPLlpL89b1Aq2JuR96JfQrWs/NdfVNRZ28cbP7KC1Xg
 ZLGsj2NIwydR2KikLVTowIqQPSB5VmglKjNmjonqEyFCiT+o8U6CV+TxBrrsnKwtoYuGr5
 Wet23F9C8H/o1Its+Ta0MLW26eVhIvT39lZAX0KsNnQ+hmdg0FNTN0cY9aDPtw==
X-Original-From: Coly Li <colyli@fygo.io>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
Content-Type: text/plain; charset=UTF-8
From: "Coly Li" <colyli@fygo.io>
Date: Thu, 9 Jul 2026 14:30:41 +0800
References: <ak3Jf2ZUhQmDmA3A@studio.local> <20260709062330.16970-1-zhoujifeng@kylinos.com.cn>
X-Lms-Return-Path: <lba+26a4f401f+911e35+vger.kernel.org+colyli@fygo.io>
In-Reply-To: <20260709062330.16970-1-zhoujifeng@kylinos.com.cn>
Cc: <linux-bcache@vger.kernel.org>, <zhoujifeng@kylinsec.com.cn>
Message-Id: <5FF95998-80AD-4E84-8022-A2D0C75939B7@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Zhou Jifeng" <zhoujifeng@kylinos.com.cn>
Subject: Re: [PATCH RFC v4] bcache: flush backing device before cleaning the writeback dirty keys
Received: from smtpclient.apple ([120.245.64.95]) by smtp.larksuite.com with ESMTPS; Thu, 09 Jul 2026 06:30:54 +0000
Content-Transfer-Encoding: quoted-printable

> 2026=E5=B9=B47=E6=9C=889=E6=97=A5 14:23=EF=BC=8CZhou Jifeng <zhoujifeng@k=
ylinos.com.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Zhou Jifeng <zhoujifeng@kylinsec.com.cn>
>=20
> Currently, when writeback dirty data completes, write_dirty_finish()
> immediately inserts the clean key into the btree.  If a power failure
> occurs after the clean-key insert but before the backing device has
> flushed its volatile write cache, the btree contains a clean key that
> points at backing data that never reached stable media.  On the next
> read, bcache serves stale data from the backing device.
>=20
> Fix this by deferring the clean-key btree insert until after an
> explicit backing-device flush (REQ_PREFLUSH).  Written keys are first
> parked in a new rbtree (writeback_flush_pending) keyed by START_KEY.
> After enough read_dirty() passes, a full btree scan, or a wrap-around
> in refill_dirty(), writeback_finish_batch() issues a synchronous
> backing-device flush, and only on success inserts the clean keys into
> the btree and removes them from the pending tree.  On flush failure
> the entries are re-inserted into the current tree for a later retry.
>=20
> Key changes:
>=20
> - Introduce struct writeback_pending (separate kmalloc'd allocation,
>  decoupled from the dirty_io closure so the closure can be freed
>  immediately and the pending entry lives until the flush).
>=20
> - Add __writeback_pending_insert() =E2=80=94 inserts into the START_KEY-
>  ordered rbtree with overlap detection.  The rbtree is also used as
>  an interval tree by bch_writeback_drop_pending() for front-end
>  write overlap queries; that search is correct only because dirty
>  btree keys are pairwise disjoint, an invariant enforced at insert
>  time.
>=20
> - writeback_add_to_pending() parks a key after successful writeback
>  IO.  Uses GFP_NOIO because the caller runs on the WQ_MEM_RECLAIM
>  writeback workqueue.  kmalloc failure silently drops the key (it
>  stays dirty and is re-selected by the next scan).
>=20
> - writeback_finish_batch() detaches the entire pending tree into a
>  local list under spinlock, issues writeback_flush(), then either
>  cleans the keys (on success) or re-inserts them (on failure).
>=20
> - writeback_flush() open-codes blkdev_issue_flush() to call
>  bch_count_backing_io_errors() on failure.
>=20
> - bch_writeback_drop_pending() drops overlapping entries from the
>  pending tree.  Called from cached_dev_write() alongside the
>  existing bch_keybuf_check_overlapping(); overlapping front-end
>  writes now force writeback instead of bypassing the cache.
>=20
> - refill_dirty() now returns enum writeback_scan_result (PARTIAL,
>  PARTIAL_WRAP, FULL_SEARCHED) instead of a boolean.  Before
>  wrapping around for a second scan pass, it flushes the pending
>  tree so the wrap scan won't re-select keys that are still
>  KEY_DIRTY in the btree but already written to backing and
>  awaiting flush.  writeback_lock may be transiently released
>  mid-function during this pre-wrap flush.
>=20
> - refill_full_stripes() no longer wraps internally; it returns
>  at the end of the stripe range and delegates the wrap to
>  refill_dirty().  buf->last_scanned is no longer rewound past
>  the current position to avoid re-selecting keys already in
>  writeback_flush_pending.
>=20
> - read_dirty() gates deferred flush-and-clean on PASS_PER_FLUSH
>  (default 5) passes, a full btree scan, or a PARTIAL_WRAP.  It
>  accepts the scan_result from refill_dirty() as a parameter.
>=20
> - write_dirty_finish() is simplified: it no longer inserts clean
>  keys inline; it only calls writeback_add_to_pending().
>=20
> - BDEV_STATE_CLEAN eligibility in the main loop now also requires
>  writeback_pending_empty(), so a device is not marked clean while
>  entries are still in the pending tree.
>=20
> - Thread exit: the workqueue is destroyed first, then a final
>  writeback_finish_batch() is attempted (skipped when the cache
>  set is disabled or the device is detaching), then any remaining
>  pending entries are drained.  The exit path intentionally does
>  NOT set BDEV_STATE_CLEAN because it lacks the WB_SCAN_FULL_SEARCHED
>  gate that the in-loop check requires; a kthread_stop mid-scan
>  (e.g. from bch_cached_dev_attach's error path) must not mark a
>  still-dirty device clean.
>=20
> Signed-off-by: Coly Li <colyli@fygo.io>
> Signed-off-by: Zhou Jifeng <zhoujifeng@kylinsec.com.cn>

You cannot add my SOB for me. I know you mean the base idea of this version=
 was
from me, but it is fine to only do your own SOB. I am good with this, since=
 you already
do a lot of analysis and testing.

The v4 version format is much more easier to review.
I will try my best to response you soon.

Thanks for the fix up and testing.

Coly Li
