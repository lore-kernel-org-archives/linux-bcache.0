Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07696330D58;
	Mon, 26 Jan 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769439776; cv=none; b=tdvfJUlrqdam/qjFzLhftz2CVOwhxt6Liaadws+MWFRANugWde96ZxZo3JobpBMhZskgyoSrf2XgVvSVOwi3LbKbOLAknOEZivFePzJ5sWtcG+H82f1dkhjvLtDPN+bPvsHXaTIHn32ASfwZWUXyFKQwRlnPCJ9GzDSgKM94yxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769439776; c=relaxed/simple;
	bh=CXbINP3NaxiVeTCET/VZ1X+Ya+AkfDVDRTk7bL3kGhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6eATbefUOxk+SJW04UyyfMX/wu9NKheHL546R8CmeOV6e42dgkm01GXfO5np++yaPjZT5/0eCM0lETTAoK6e7p2/s24hNbUA0SL3GAm+hyfxH7/eJ6JxVs3tNXYMcaSEc4bm2y3u+0IPgrk+ZhRut5ekxDuJZBKUUatH+d4Uf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=APVD8qu0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="APVD8qu0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m+wYWA70+Ng6eIa+ZYyiCV+OKFjJCFaLBtxvIdbpA8E=; b=APVD8qu0Guac8TiIGmd74X2baU
	+6OhfSxMHY9Mt1p5GbyWdE+dXud2phUH9+ChBrziIBveKByPIh8nZMQAxH+c29vYo5m9MUG5HwI1z
	t1wmxr9P4Kn3CBQThBFbEbYQLxQGB5hVIIf69QgzkN3QSIScMcT5zNPuyJvrX374XQb7bscmWUXXV
	pHhYQAII2m86wUF6O9EstKHGV5lATij5v3e5FgCgVeJDeBVAgKUHHEp1PoKVgqpaxVMYqU7yOmvX0
	yhlpW52aHfLqZnuSc/9prrIZhlVLb6Hkzd7nRI7d+E/aVBwLbj04jbq+losm4mZcTgr41wWju9lWE
	8sumdaLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkO77-0000000Cjui-1XHF;
	Mon, 26 Jan 2026 15:02:49 +0000
Date: Mon, 26 Jan 2026 07:02:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, zhangshida2026@163.com,
	kent.overstreet@linux.dev, axboe@kernel.dk, osandov@fb.com,
	bvanassche@acm.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: Re: [PATCH v2] bcache: fix I/O accounting leak in
 detached_dev_do_request
Message-ID: <aXeCGcsQ3XnwWaOK@infradead.org>
References: <20260126092854.971870-1-zhangshida2026@163.com>
 <aXdjqueZ8d8Se61A@infradead.org>
 <aXd_QlcF1h9qeULs@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXd_QlcF1h9qeULs@studio.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 26, 2026 at 11:00:56PM +0800, Coly Li wrote:
> > I don't think that is correct.  This was just a trivial calling
> > convention change.
> > 
> 
> Hi Shida,
> 
> This Fixes tag is misleading. The correct to-be-fixed patch is commit
> 3ef825dfd4e4 ("bcache: use bio cloning for detached device requests")
> in linux-block/block-6.19 branch.

Not really.  The missing accounting was present before for the no-op
discard case.  See my reply for what I think is the culprit.
