Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8ED24E4B5
	for <linux-bcache@vger.kernel.org>; Sat, 18 Jul 2026 04:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784348558; cv=none; b=KNIG9iczAFVLfwc92CA8lry+vccoZUTrC2aR0B9ZesQT2Rn5QSAwe7co7ghUh2rbGcYxKxn1dfQ3fQH3qHU/0Hp06h5rx7i+B8CMQ383JuCN7sgqGCmvKPcyUjEZIh5VkWLLVJq6y4ipswfbwqM2OPpx5zSUDYmJblKFVt/M/Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784348558; c=relaxed/simple;
	bh=rpZE6YQl3LNUlkZWH8A+/UtXmawY4+W+P9I7uMOpeb8=;
	h=Content-Type:In-Reply-To:References:To:Subject:From:Message-Id:
	 Mime-Version:Cc:Date; b=FA589i2WbPNBXP1BKgk2UJfqvXZ4gzH3QOjVpwbbo7M9yJ42sWk1O0ywvbUPL74R27NkSV8JN1gw1GJNsU6ZaHQpzT7SVdQBqPzywFC4T/wcAS8wwv4wijeYgSTUt9Euude6etMbDC6mhV5ZhmHNbZvH+uQdgjCkoBaRLYk9Kg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ZMA1PG47; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ZMA1PG47"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784348428;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rpZE6YQl3LNUlkZWH8A+/UtXmawY4+W+P9I7uMOpeb8=;
 b=ZMA1PG47+MclSOFei5GdJLXANVOpcmAFcNGTaYU8Py7hvelrSgkhdEGOVHM/7A/1F5h/Xm
 9gG1v8YMq5kpNnUhVU5O6S6Al0SP8jn92iV/1GZk/Gn9RAM4t5WGQGVjnyoaqBZgm4kkt1
 pIuRRSKro1OBmBpXnhcOwSpZblJjf70vVvrA3xeXCnZcUC6Pz+aqN9VPuC+hQhZ5LHs4+z
 biBqSwO01rF5SddKyJmGFn19q6tjXFCtz0ueotMptZsVJYyYWOwYjpkIj5J+Tx1pfW8atv
 hZVNA6AwB6bCDfCo9EPr0BExQgGZG/ILQ7ZMSeoBHyzbOxi5nLUxHHg42mOeyQ==
X-Original-From: Coly Li <colyli@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260717005039.1953649-1-robertpang@google.com>
Received: from smtpclient.apple ([120.245.64.95]) by smtp.larksuite.com with ESMTPS; Sat, 18 Jul 2026 04:20:27 +0000
References: <20251113053630.54218-6-colyli@fnnas.com> <20260717005039.1953649-1-robertpang@google.com>
To: "Robert Pang" <robertpang@google.com>
Subject: Re: [PATCH 5/9] bcache: reduce gc latency by processing less nodes and sleep less time
X-Lms-Return-Path: <lba+26a5aff0b+33e6f3+vger.kernel.org+colyli@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Mailer: Apple Mail (2.3864.600.51.1.1)
From: "Coly Li" <colyli@fygo.io>
Message-Id: <DD9682AB-F203-4106-8CF4-95F396A736D2@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <linux-bcache@vger.kernel.org>, <mingzhe.zou@easystack.cn>
Date: Sat, 18 Jul 2026 12:20:14 +0800

> 2026=E5=B9=B47=E6=9C=8817=E6=97=A5 08:50=EF=BC=8CRobert Pang <robertpang@=
google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> I was reviewing this patch again and noticed that btree_gc_min_nodes() re=
ads the
> atomic counter 'search_inflight'. This counter is incremented and decreme=
nted by
> clients issuing front-side I/O. In this scenario, should we add a memory =
barrier
> (such as `smp_mb__before_atomic`) prior to `atomic_read()`?=20
>=20
> My concern is that if btree_gc_min_nodes() is inlined in the caller
> btree_gc_recurse(), the compiler might hoist the `atomic_read()` outside =
of the
> while loop where btree_gc_min_nodes() is inlined, preventing us from fetc=
hing the
> latest counter value. Adding the barrier would guarantee we read the upda=
ted
> value.
>=20
> What are your thoughts on this?

Hi Robert,

At the first glance I feel the code was fine. But, it was almost 8 months a=
go, to
make sure I understand you correctly, can you place your comments with the =
exact
code together, then let me response you more accurately.

Thanks for the review.

Coly Li
