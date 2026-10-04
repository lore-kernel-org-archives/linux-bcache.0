Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929693EB7F4
	for <linux-bcache@vger.kernel.org>; Sun,  4 Oct 2026 23:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791156927; cv=none; b=ixKmjV1oksPcX3NOuEZxrLD5xpkU0uKfaWg96Y7jGC8Z6+HngNfoW2XOZa5mhbLLgQq0c9fyev8UuJ92A57Ry/qdhq9/pwl5WyzPAc/XrVAddPoTIPMUN9RYYUEmqjcNz0vS+W3dig5wh4mPe3iB5G19MXc5uMEbCMPnU4uETt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791156927; c=relaxed/simple;
	bh=84oNTtoU5TRwLXpVP/C4e/RdQ+WXtPYh57/ceGuME94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ljp/0AZPvKEGfm05Jvev+fNYsUhd6x4jbyzRsa0ZMiA5m8jWsfFvDk18HDf/D7/KKvqoNVEwzgD1gdSUXJMQG8YU8JlU3bS3p3K5NZT7VZRt4K1qVNgzNn+2uXtFZPtLwi7hvg8UmfhL2XabmpgU5CfEDT33pTqn/rD0j9yQvJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NTpjoFTL; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NTpjoFTL"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-351224e684dso1270949eec.1
        for <linux-bcache@vger.kernel.org>; Sun, 04 Oct 2026 16:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791156926; x=1791761726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z0geCidlObjDwsqjGR3bZHWylINcXP3kfe/2o2o6fpA=;
        b=NTpjoFTLlYM7sRg/L3XOdp1t55LqJBUMQLftf/+zfkp+LebieQPcBwFL4x0rKIba6Z
         IWRVP6MZYjDSR49HD6P2f5ES5Zh/0yj0RRZTh3Zwl1RF8ABLX8lkXlQooG3os8cgQQgb
         jVaHxlHbDbO23HMsr4mx+l172oBgVOPRh6kdoPE51R5VWhBjQfA9SpehR/D/3MvkFg6R
         5cyOleMYOUJJtRMYv5wqZYJOus18IpLpbMJRdpoB+nWVfcyrpID7P+97/MrR2GBAAxiT
         gKC8IUgQtvfDljsC8iGTc/zQ+IvqFHpOwdYb93crPM7D5wAF+J3FJgNSPXgUnniBZaVX
         figw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791156926; x=1791761726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z0geCidlObjDwsqjGR3bZHWylINcXP3kfe/2o2o6fpA=;
        b=wOUUui4xubN8Iae19dvRI4Z6wjEyi7tT0FozOuemlZ8AH99uSHilSxrMP39f0Pv9RF
         d8mYIzSSc3FAGUqFubXtyB3NYfwVrOPcuUn3FOxI5DzVmqMQBAr9MbfQ8BaJhmvwp5jc
         MudvZFEV9yEnidUX3W4UnetWhzBt2hmZ7aL1Z/0kgKhAk35LWN3R4BGNXWShp3xuEVwo
         HwGw0u0t7VJrXKp6cb22ugegq1MBVvQvn+UgcKWEkqxntdbH5sCLwnjysRvDUmN+Vv1e
         sNJoNJ6avzeABB0c9RsmrL4MoGuZLvx9iT6gstJNGGYtBVzIvAta9dWCI6beTXWNB1mm
         QFfg==
X-Gm-Message-State: AFq9FYJDbynCFbO9u4p8N5lFyGMxfifjslF6S2ZrBzeYaRxx4jiM2gBL
	+uJgk0oe05J/+exy6pKTTe9/wh370Oz1/zKcNodYYkD9EgDL8Ol4xH2A8QWBGAt2
X-Gm-Gg: AYBFou0O+NBa4lzDd2H/vV+3BRoJitICOqJI99kGgdsAIobOFMKJg48hdR1E3VOSIY0
	HUge6K7PpTtFEoeGS7u6xp/TSzY3V6JiAFVoWGvUpn0b7Z36lrxOInduQ/VYPqez1oZXOlHArKD
	PeNxUm1EyRUgcR+RaBUns/Ecced4gawW4RodWlLfaHlYaVmuPRWISbjYQIMwK56C3/XIHiK5io4
	4080YoQNzE8v1vCvcP/MNoO7lmN3p5pHkYZlAANZeLZIFG8gMSCIXBxaWtgixNozVlUXKPrTT75
	vYvQ6iFH3oQy+vRLIbjHJCGsUk8/bneKhIY4zfSbBaYiUvHXHmVrRDU+ZOH8LfKTRw5x06wjgdo
	waEIu5nBMWJBbn/TAUHdH2oypFaAREj7rUW4hnQEBDd1JR2wplH5S2U6IZ8kBpluzz/x/DGSvMF
	jIRKQlSDCpMtS6FuibENn1Kq77AMbK6M3ivMPIqnRBn+COenw0I030VycGmzyZ4zNafa2tGCbDQ
	aXB6WiVo1J7MmFWrXe414TbfahVhlGR5np3Xw9vbz0ALerXLPb6umrKtUlB4roXJLwSUhrffSyb
	OplKvAOr0txC5hsF6o+DSK3kq2z6RKnWHaojHm3LbHBdBK+V
X-Received: by 2002:a05:7301:db82:b0:351:245b:d1e7 with SMTP id 5a478bee46e88-351245bd4aemr3769432eec.0.1791156925455;
        Sun, 04 Oct 2026 16:35:25 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35126f01924sm7960360eec.0.2026.10.04.16.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 16:35:24 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bcache: fix kernel-doc warning on CLOSURE_CALLBACK
Date: Sun,  4 Oct 2026 16:35:23 -0700
Message-ID: <20261004233523.516891-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bch_data_insert() is defined through the CLOSURE_CALLBACK() macro, which
kernel-doc cannot see through, so the kernel-doc comment above it
produces:

  request.c:308 function parameter 'bch_data_insert' not described in 'CLOSURE_CALLBACK'
  request.c:308 expecting prototype for bch_data_insert(). Prototype was for CLOSURE_CALLBACK() instead

Turn it into a regular block comment, and drop the @cl line along
with the kernel-doc markup.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/md/bcache/request.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3fa3b13a410f..e7f097346d64 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -285,9 +285,8 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
 	}
 }
 
-/**
+/*
  * bch_data_insert - stick some data in the cache
- * @cl: closure pointer.
  *
  * This is the starting point for any data to end up in a cache device; it could
  * be from a normal write, or a writeback write, or a write to a flash only
-- 
2.56.0

