Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8825A33A;
	Tue, 27 Jan 2026 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769502536; cv=none; b=rCjWnPVUuFf+llj/bnbopz3LRusTjECQZMHyuAtw0dZUdg7WrDdB2W0sKy6tLUlLJxWO97AjOmx4vy5kXq9YGn7Sz7At2K8e+R+PYyfWaKWT0wPvqm4Kpj/Sf2ex0wbEYwtQKMOPnsNJEmyov8Y/JpHQME49Q+SzDrGYZj6rM5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769502536; c=relaxed/simple;
	bh=x4cL0AzeWKbx1GoNQeXRpAw9R7xVEQg16Vg7Aa1g96w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aj8EsD9G1SwVw+MKrjbi+Mpv9dUakL4541oiF/Oa2+Gc2G0rRMCooKI0xAGQpLOIJR3TqldH8drh4y29Ogo4/lMID75Xn4ow8pm45R6Suy8RYltTznfu4okbnz75fa/+9xJaw8DBBHqEyBLtiFHOCjO2qeDaiwozt+1JC1C1wPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uASGgPbS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uASGgPbS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=exnd/z8vtDfcNbS0BtPWDxl38wt6jImwFjRrB8O1GBY=; b=uASGgPbSuvstoCFps4kxPEzbx1
	vJ94Q4RAn8gyd5Zpeh8NkDXDJSQdyZjdxh0FppRjgWBAZMSAnliZ0brhp4ZC0SOPQzt2MV6IMUXwQ
	1RiE6cRIBnEDexauH/rsr8Hax5fnNR5zn/eOUD9ed4HvYSu/vPlphge/9CUGHDr/UKy8GaUbZq8T/
	TpZV81OAco2fkzGrVrrSUHdKYC9hCH77XuDm/e6BREQmLWVe1RI7d1jfvE0HgQEzOGshAnunakxgX
	ci0G6PxmAje5k9jUfvTCfHdpcu2L6UrY/MqeINUsLej59PGzyOTwHWVRofeqUhATqrbgyAZPfbGBr
	INmIL7AA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkeRN-0000000DprF-0Ybl;
	Tue, 27 Jan 2026 08:28:49 +0000
Date: Tue, 27 Jan 2026 00:28:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida2026@163.com
Cc: colyli@fnnas.com, kent.overstreet@linux.dev, hch@infradead.org,
	axboe@kernel.dk, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: Re: [PATCH v3 1/2] bcache: remove dead code in
 detached_dev_do_request
Message-ID: <aXh3QfG60OmnaHNm@infradead.org>
References: <20260127082112.1114158-1-zhangshida2026@163.com>
 <20260127082112.1114158-2-zhangshida2026@163.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127082112.1114158-2-zhangshida2026@163.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 27, 2026 at 04:21:11PM +0800, zhangshida2026@163.com wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> bio_alloc_clone() with GFP_NOIO and a mempool will not return NULL.
> Remove the unnecessary NULL check.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

