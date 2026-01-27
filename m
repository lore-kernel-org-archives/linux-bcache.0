Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F5525A2A4;
	Tue, 27 Jan 2026 08:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769502139; cv=none; b=lGBW20tGYDKqJsCp2oTyMi+SHG0ETgwVhmYgO04zgp3G9mdibB7E7mro7Xi4Bej6aVQN0dlPuktBH+nHJ+M1YmXls9/4DMbZd0n9dYjVaLMgYLVD2NlptT9NCqKYxKM17FQ0lr1HaNDHE/mQXIh/zxrgaYzwiOP95XC2+pfD830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769502139; c=relaxed/simple;
	bh=57FZHE6FXv3qPQV9Kd9KgcwxBZWdSS6+PiWfE6PR3s4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gNwlqV17adkZXIucH7Ym/a4MiyVlp2TYFsKIaxmCHIz59WYrUhcj4tfHwTtJG8BcGFYESJRpm6XF3pCMpTemQgKhv+8sZEMLJIBr0ubeZYlreJobjucNF5jDFeTrD//fPwdGI9fWSjTru3e2kjyocQ0EL7DgRAVv2Ognzb2wBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=WS8SqQNX; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="WS8SqQNX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=bl
	kronDHXEpGjIL9Br1BlfqkPGldSBTPUEtaG3YoxMQ=; b=WS8SqQNXLOP2ntlwbt
	pssiVorXoHfomqAC/RREPxhWJAfo9L2Lu1kbyt0/Etq5193PVFRTnygKhMFtv2q2
	o/YtgcHR/39SA5/IrNfVQEDe9WOSHVl+LG/Blv3NUlTHAwRChxqUWn+DtNpWzlZn
	5/lpMS+yZeSti9FfVhcAZM640=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXP3iHdXhpOByCHw--.7542S4;
	Tue, 27 Jan 2026 16:21:37 +0800 (CST)
From: zhangshida2026@163.com
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	hch@infradead.org,
	axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 2/2] bcache: fix I/O accounting leak in detached_dev_do_request
Date: Tue, 27 Jan 2026 16:21:12 +0800
Message-Id: <20260127082112.1114158-3-zhangshida2026@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260127082112.1114158-1-zhangshida2026@163.com>
References: <20260127082112.1114158-1-zhangshida2026@163.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXP3iHdXhpOByCHw--.7542S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFyUXr47WFy3GFW5Gw1UAwb_yoWDXFc_G3
	WfuF92grZ8Cr1v9F4ayr1fZr4jga1DZFyrKF4vgr1fJw43uwnFgFWFvryDKFyxua18uF4x
	Aws3Ww1rAwnYkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYowZ7UUUUU==
X-CM-SenderInfo: x2kd0wxvklvtasqslqqrwthudrp/xtbC6BH5Bml4dZGH2AAA3s

From: Shida Zhang <zhangshida@kylinos.cn>

When a bcache device is detached, discard requests are completed
immediately. However, the I/O accounting started in
cached_dev_make_request() is not ended, leading to 100% disk
utilization reports in iostat. Add the missing bio_end_io_acct() call.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Acked-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/request.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index c2f38907a2a..3fa3b13a410 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,6 +1107,7 @@ static void detached_dev_do_request(struct bcache_device *d,
 
 	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
 	    !bdev_max_discard_sectors(dc->bdev)) {
+		bio_end_io_acct(orig_bio, start_time);
 		bio_endio(orig_bio);
 		return;
 	}
-- 
2.34.1

