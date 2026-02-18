Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614D633373E
	for <linux-bcache@vger.kernel.org>; Wed, 18 Feb 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771424620; cv=none; b=NZkCwbqY0KVL36QyWqzSwOMVzVTLP8TXY8u8A2jFi0g+k+yduMhyPzBfCij+eVE1Sq5d8ld7ah1ONICKmjdXKv+L2+rx3PDDSISwfL27hlh56CGDcg1emhV2naa4o8wYKJ47aWSitDM1zmnx/05xNGMBx+Xf1zbqxea/3tmthak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771424620; c=relaxed/simple;
	bh=Yc1rdmS/FHCgJf2nuh5QlQ5h+WwwNOWeY8Ia3RiQEHM=;
	h=In-Reply-To:Mime-Version:Message-Id:Date:Content-Type:Cc:From:
	 Subject:References:To; b=nJeAobTTeXVT1oj9K9MDyS/fTtCWZoq9lNEYDZrPwreAsZIsuFefU2sL88PgmQX9cMTfKo3AdnQ7/xkPGjYXfnlKyAcYKEn/6VueuJWRPja0pWhCzmyTj3hLkP12aZzMTxRv4w1z5hLim094RxshjnuvlxRiHI0gojAKk6LVy6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=cfEJz12U; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="cfEJz12U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1771424606;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Yc1rdmS/FHCgJf2nuh5QlQ5h+WwwNOWeY8Ia3RiQEHM=;
 b=cfEJz12USRZ43BvBXgpDrKDqhTXVTcnwcZemULiiAS4CzJ5OGcn2otGN2H048JdTChPCn7
 0moqBdAEulk3qFPkgtepONCLSXQpUVKVMGIOkA9+iLhvtRZTiibV9bYo8BmBgfBibxZLQo
 k/24KzvBDdGFtGMYVLx3iZbi5luD37NaPhpmpqgDM9VjVJWRutWotASJzD7wBLtZ5VNDVp
 l7ulxXOU1ZGpy7MuqJs8rxsnHCkElg/Sf7I0eQvTOojTSBoKKQppFsgDURa9Eto6XW9WnX
 2cTB4Wim06DK/5S5bv2iuJhlmtw51IwAVD1ldpyPIg0TcrFGO/y4STZ0u4Ax0g==
In-Reply-To: <D31CD28C-7B6F-4D3E-89E7-966A06DFEAF0@139.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Original-From: Coly Li <colyli@fnnas.com>
Received: from smtpclient.apple ([120.245.65.52]) by smtp.feishu.cn with ESMTPS; Wed, 18 Feb 2026 22:23:23 +0800
Message-Id: <AD82E6AC-A1A6-4285-A204-A95D84A2995C@fnnas.com>
Date: Wed, 18 Feb 2026 22:23:12 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26995cb5c+1e5e00+vger.kernel.org+colyli@fnnas.com>
Cc: <linux-bcache@vger.kernel.org>, <colyli@suse.de>, 
	<kent.overstreet@gmail.com>
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [RFC/Feature Request] bcache: support io priority
Content-Transfer-Encoding: quoted-printable
References: <D31CD28C-7B6F-4D3E-89E7-966A06DFEAF0@139.com>
To: "yangliming" <liming.yang@139.com>

> 2026=E5=B9=B42=E6=9C=886=E6=97=A5 10:38=EF=BC=8Cyangliming <liming.yang@1=
39.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi bcache developers,
>=20
> Many business scenarios require different IO priorities. After setting IO=
 priorities, the goal is to have high-priority writes go to the SSD cache, =
while low-priority requests are bypassed to the HDD. Currently, the logic i=
s:
> ```
>=20
> if ((bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND))) {
>=20
> if (!(bio->bi_opf & (REQ_META|REQ_PRIO)) &&
>=20
> (dc->cache_readahead_policy !=3D BCH_CACHE_READA_ALL))
>=20
> goto skip;
>=20
> }=20
> ```
>=20
> This logic allows IO requests to bypass, but the request type cannot be c=
ontrolled in user space.
>=20
> Could you support setting bypass based on IO request priority? Is such a =
requirement reasonable?

We had patch for caching by I/O priorities, but the interface was too compl=
icated IMHO. For this suggestion, what is the user interface in your mind?

Thanks.

Coly Li
