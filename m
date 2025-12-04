Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDD117BB21;
	Thu,  4 Dec 2025 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841133; cv=none; b=gUVYyk3ibcNkEp5PGYkZiE1fxUG7kGDQB1rNHuNYAoukw81k79whULe5LmUxyOD4fzKuIe2in6KvswRg98Ugz8eb9cr0F3dNzZ+QTvOsYzuUF60X/gj7YosOtryVuWBPNSJ7nfTfzXx5Q4T+C++339rONKHDB0BqDELpdG6OiWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841133; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yc2forE7rbHRropfl05iHaaNPw5ePMiU6lZcqJZmxlDwqsRm231jLYXujRp54lp/6RvcrJyjdIdfGH1qXNxatSnMMimtJh6YJ4nAWvmnM2T28P0dAqBVXrLyKzFYtp4n44VuiZO5Jk8X8Zq1zpq9g5DyREi9EvRkEufpuAMPauA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D2Bq/N8h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D2Bq/N8h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D2Bq/N8hg8h/gY6rR3tf+2amin
	kVPLr8NmRjuiwosf1Xu5LYlUeOnD9HIJM2mcqy2hTrqeagHaDM1vfKWwaGASQxCk0uFknSZAcvFVz
	FoT3p0FrZwPpUyjwVQrNnh3kGGvZHFo/wEwq8aCEbTRJqijxVYsQ7fmci/CM/R9dKxPgyOF6Z/ehG
	g46ekArB6lYfxD16KV287QdZ3lsxX/+DAc5MsZqSEdYmAa9QlcBhFPL8RklNAnBYbUsf1Y3zl2yfW
	ce8rLDP5JW+TvLzVrzZIo2PDy4QBotHtzNSa8Vt3JHElv9w2OXpt2S84flLZMwxdNCiKDpD0srhZy
	bi0/GWdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR5nT-00000007mLl-1sEp;
	Thu, 04 Dec 2025 09:38:47 +0000
Date: Thu, 4 Dec 2025 01:38:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com,
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, colyli@fnnas.com,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH v5 1/3] bcache: fix improper use of bi_end_io
Message-ID: <aTFWpzdbz8nfAd07@infradead.org>
References: <20251204024748.3052502-1-zhangshida@kylinos.cn>
 <20251204024748.3052502-2-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204024748.3052502-2-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

