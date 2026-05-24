Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8253ADB94
	for <linux-bcache@vger.kernel.org>; Sun, 24 May 2026 16:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779641933; cv=none; b=uW4y5pRsfx9zFQCt9u2A+NNOW8UrCgWUX0x2IxoYX8+Sn84TUtLbIKWdH2SHYbwvPZ9k6Jo9DPfYw/PFE6V7ZizclMCwaefj788E1kVbk4yQfxW1ZXA4RpGIECpgcoBdiBBLGu51tixPyQaewEGBwSs8bXrullDPBwHTAmR7Npo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779641933; c=relaxed/simple;
	bh=zMnlkg6mtIRYlThB6tVAx8UUoK65gDBTDtNCJ4wiUtU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pCYnQLHYnCqr0HovJfBtI/uEWBiy97IJlp8gVjsfX0AE7fRg9O4i4pcgz8tHS66YBrG/PyZDTxBAa7GbbsWimAdbD2bvimcBaz0YQ0yynITXWq6wS1YZLmB3V+Pdl9Z+Ylhe2Sj7fFCR/9/d3m9TXh82jO09o0hocIesZCbBs4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56A11F000E9;
	Sun, 24 May 2026 16:58:50 +0000 (UTC)
From: colyli@fygo.io
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	Coly Li <colyli@fygo.io>
Subject: [PATCH] MAINTAINERS: Update Coly Li's E-mail address
Date: Mon, 25 May 2026 00:58:46 +0800
Message-ID: <20260524165846.243264-1-colyli@fygo.io>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fygo.io>

Change to my new email address on fygo.io

Signed-off-by: Coly Li <colyli@fygo.io>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b539be153f6a..fe6b12ab669c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4445,11 +4445,11 @@ F:	Documentation/networking/batman-adv.rst
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

