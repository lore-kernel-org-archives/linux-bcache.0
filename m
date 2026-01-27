Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2A525A2A4;
	Tue, 27 Jan 2026 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769502150; cv=none; b=p3hPXoi+MIXlSlQTPkbwfC7MTymSGMz0/0uPdA6txmV7PQTGgy+x+OkcgBkH+Ip4uUath32CTIJtcuTlfdGqzcSvXU5nf6hKdacNYl5ybwFh6BYqic/BbywZyBvrUThiBzLJsvRt7E4Vy4Far6b3tU8ebChAobw/2YbAIcipwEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769502150; c=relaxed/simple;
	bh=LNOeSlA/7t14bzt1sxQjODjo+dLWaOOMbBYmrw8LEwo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G6PW6BaFpnQWn6HJ3YlMIBQ8TU8fz4rIEWTmYJyNFdAb5VSsBrs1f8oChMogIxOeMzvN1EH3JbVLM+TdOX0ZJM3ZbkqYtyjjtiEvuOB9KbWLHe6fJJ/19bgNsoVgSkm2B/PNo69klFcryfZQTvBUcy+4m9Ulv+bX+HcqRe4IzYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TqKFAHBE; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TqKFAHBE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=c6
	8Kldp9tU8NPlH0XbUeenwY3wNmWp/ksOtFpsJ4750=; b=TqKFAHBExzRAThHO1e
	F2e6UzClShyKaQ41IKVdv7q7YkhAq11shAWYQjVMo22puvLpX1+NVSxGBV0m+OSS
	/pShyy6bK1w6xkmGd4lkE6y/h27GNLJR7TxDNP4ZONRQsctplCiizHtiVrwDWgHl
	U2F6ln8yARP422vMW7ijeL5fE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXP3iHdXhpOByCHw--.7542S2;
	Tue, 27 Jan 2026 16:21:29 +0800 (CST)
From: zhangshida2026@163.com
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	hch@infradead.org,
	axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 0/2] bcache: fix I/O accounting leak
Date: Tue, 27 Jan 2026 16:21:10 +0800
Message-Id: <20260127082112.1114158-1-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXP3iHdXhpOByCHw--.7542S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUhNtIUUUUU
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC5wn3BGl4dYmJjQAA30

From: Shida Zhang <zhangshida@kylinos.cn>

This series addresses an I/O accounting leak where detached bcache
devices could report 100% utilization in iostat after completion
of discard requests.

Changes since v2:
- Omitting the dead NULL check for bio_alloc_clone() (suggested by hch).
- Updated the Fixes tag for the accounting leak.

Shida Zhang (2):
  bcache: remove dead code in detached_dev_do_request
  bcache: fix I/O accounting leak in detached_dev_do_request

 drivers/md/bcache/request.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

-- 
2.34.1

