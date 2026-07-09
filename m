Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BFE3E4C9F
	for <linux-bcache@vger.kernel.org>; Thu,  9 Jul 2026 10:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591373; cv=none; b=PHhH/dNaDF06BjD9cHX59UY8WY+Qg6/4gnW0d8iwOMmtDp49JjuB1qjcUVNrBH5tRq1l+WZ4O2Sb7Ie/RR+S9BSGtJSWP/FUNij4y5kb3VjZLJcCZCy5exW2kEruFr8P4wQm4vHtSicetghjSXxlM8BAivBBnJBnP9HldG/kuhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591373; c=relaxed/simple;
	bh=js3GOE6eNJYLE/SjBEOjGlHKW//nqpck89PQglEeI7I=;
	h=In-Reply-To:To:From:Content-Type:Subject:Date:References:Cc:
	 Message-Id:Mime-Version; b=ENXqto8Q4dcJDdi1ctFfNJXC8Y+PvQpbwnJsT60KUPSe8wCAlz0OjpdnmWb3k7ZQHPRqgR07hsCOfXW49X8p+qVF12cHejZEMuDHJewCrtzgbQSFJaunsSeSFvP1y3DXRDpwHLnCQRbgeumCQyncCGKUQ5GG5vZeX7OotRILWxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=G2/vTerT; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="G2/vTerT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783591358;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=js3GOE6eNJYLE/SjBEOjGlHKW//nqpck89PQglEeI7I=;
 b=G2/vTerTQHVKtUCxf0lbYJ0hD0o24yQuAOYZfOu3oqx72JtArWF+1mfZkEdVbxfzLDRz6q
 iiQOtwXK8oV5Vh/9rVAXL5YLZF8VWnRdHeaOabmwZea1CR0bqYShjrbgzlzaFe0NZFRjxI
 hYv7UTUuPNvUIxq+JdRwNMzlc6TWu+PrYMkaPTB+jnDBPHPqXG4k7YDqB9NkpeEMrRNksq
 f2qCNYH3u6vRGIexQcZr6CL9Tns4iH7Xj9i3DvNuq28JzCZr2DDSlhsKLB+9d0HNfutR3s
 A+wWC8WII7c2fSC96nXNxARmuT20KfUrCYssTMoQTjyRxqCZRmCo1zWRS6kabg==
In-Reply-To: <20260709061500.GE16504@lst.de>
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a4f71be+0de08c+vger.kernel.org+yukuai@fygo.io>
Subject: Re: [RFC PATCH v1 07/17] block: support non-blocking bio allocation with a bdev
Date: Thu, 9 Jul 2026 18:02:32 +0800
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-8-yukuai@kernel.org> <20260709061500.GE16504@lst.de>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Thu, 09 Jul 2026 10:02:37 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Cc: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Keith Busch" <kbusch@kernel.org>, "Sagi Grimberg" <sagi@grimberg.me>, 
	"Alasdair Kergon" <agk@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Dongsheng Yang" <dongsheng.yang@linux.dev>, 
	"Zheng Gu" <cengku@gmail.com>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-nvme@lists.infradead.org>, 
	<dm-devel@lists.linux.dev>, <linux-bcache@vger.kernel.org>
Message-Id: <ee70f959-b61e-45d2-b1f0-22bee85b0bdc@fygo.io>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/7/9 14:15, Christoph Hellwig =E5=86=99=E9=81=93:
> Maybe we should just move the blkcg allocation back to bio_submit where
> we know we can sleep?

This sounds good, I already switch blkg allocation just before submit_bio()
in some cases in this set.

Just one question, for nowait case, is it correct that we still can't sleep
during submit_bio()? If so, I still need to add nowait special case during
blkg creation. Or I can just return -AGAIN if blkg lookup failed, this is
much simplier.

>
--=20
Thanks,
Kuai
