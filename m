Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E392868B2;
	Tue, 27 Jan 2026 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769502544; cv=none; b=Q2goCtkRR54VLatbZwOljNcz7RBYuy+XOLjFJwvoeN5hc3h78st02j8YukQwVgCHSvNDmiSl7pUcbmHl6sc8G67+SUzUG5Nc1yWERmcIiujxpcK4N2BsAVZp/31HebgK5S93KzY7kb01GXE4Yp/z4y9k0AYehwqWRWCoOaMVClM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769502544; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBUg+QeQIWamJ/xS6a16cINDaYWxc7aeT2GFiwFRbTws2DQJcm70bcqr24ieKr1N/NO2OIWzSzix5bKEjdVyjFy71jj4nEPZPk59GfyUtFs2IyAD2sBdo5dpFqf93an+huPA3QjyGFlWtYwdpx+atcj/I57Z7v0H2uGxXfYbxjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p7QJcKZj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p7QJcKZj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=p7QJcKZjgxywl3K69e7W/gzlJW
	oLMsDqeXbUbz9QD38Xg26HATtcoFSA030lypzsugTCNfPuQnOEXoe782gXemrc5hds2z4bbMBLj5x
	ScnpY4QikpHxrLuhLgtP1bx3wW6u7Nb5JLzx+gfrQiDXl+N4OaLRiTXmjmgCPwN/je4K33j0Zlh0A
	lIwnToK8xTuJM/VR8cgB5tB1vSBNXenETFIjZO4O4pFXW4o3x4FPqG1o8n64EoEe7XtFZOeFKXEwU
	w6B5E5xNkHyAlREFcMwzK0/cPXbZCw76JHR0/hvP0WvCnGVNfWW45TXPlIhPmlIYmStm86MaqgctN
	1qx9OcTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkeRZ-0000000Dprk-2nNy;
	Tue, 27 Jan 2026 08:29:01 +0000
Date: Tue, 27 Jan 2026 00:29:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida2026@163.com
Cc: colyli@fnnas.com, kent.overstreet@linux.dev, hch@infradead.org,
	axboe@kernel.dk, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: Re: [PATCH v3 2/2] bcache: fix I/O accounting leak in
 detached_dev_do_request
Message-ID: <aXh3TbdYZTkcMjrQ@infradead.org>
References: <20260127082112.1114158-1-zhangshida2026@163.com>
 <20260127082112.1114158-3-zhangshida2026@163.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127082112.1114158-3-zhangshida2026@163.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

