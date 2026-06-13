Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFA9184;
	Sat, 13 Jun 2026 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781363139; cv=none; b=a783QtmD9pg6/bNsaOR6nn9ShwZ/N+L53JCjdEjfWyegMzIFOHjQ4k6a+jK52x6C6byLMUept2QlYab6KkY2ZFPyYURIm7QGd32Msi1gRO9E9MLISGU89OuxBZu12dhN1asZUaG3MzgI3N7Cq6i2PDqRjqrJckJ18nk8Jl0eXWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781363139; c=relaxed/simple;
	bh=hmv24GLb7BcsKGplD+JKmBrW0aFmSzL0/jd7zCk7DgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CG0xDA08+y0dNdNkhPmlUIMvNMHTA/4ACBUY/fpd9D63EjY3B2KN49ri/j+JttpVZY8hDq4zfTig8mQ/uqu3x+E6le1tRVlStUKHIbCJepi6lQv8CaUj+6JNhzxavj7CfrHLJu2N6h6SmhdL4VJxi1Zkgs+Kxcj5zGTDxDhGi1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB081F000E9;
	Sat, 13 Jun 2026 15:05:35 +0000 (UTC)
From: colyli@fygo.io
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Coly Li <colyli@fygo.io>
Subject: [PATCH Resend] MAINTAINERS: Update Coly Li's email address
Date: Sat, 13 Jun 2026 23:04:58 +0800
Message-ID: <20260613150458.682707-1-colyli@fygo.io>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fygo.io>

I switch to colyli@fygo.io as my current email address.

Signed-off-by: Coly Li <colyli@fygo.io>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8856f10a72bd..d2aaa7dacf90 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4446,11 +4446,11 @@ F:	Documentation/networking/batman-adv.rst
 F:	include/uapi/linux/batadv_packet.h
 F:	include/uapi/linux/batman_adv.h
 F:	net/batman-adv/
 
 BCACHE (BLOCK LAYER CACHE)
-M:	Coly Li <colyli@fnnas.com>
+M:	Coly Li <colyli@fygo.io>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
 L:	linux-bcache@vger.kernel.org
 S:	Maintained
 W:	http://bcache.evilpiepirate.org
 C:	irc://irc.oftc.net/bcache
-- 
2.47.3

