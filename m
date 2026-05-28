Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060F83783C0;
	Thu, 28 May 2026 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779985665; cv=none; b=p2fM8xvw7IAsVKKpkKoFirYhMsfu6v3IFQ8kyIy7Wlo34HyEy/1lnF6JnviFCgkL8/twqAvo/4b2YM1pMHPqUSw0JcAoz7I6E4euFQQ9Vz0Um8RU9nXdzNVTEB7Z6W9udTvxU9PhqzKf5v8ct0PhSl8y8PPaK/23MyRDUMRVBK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779985665; c=relaxed/simple;
	bh=akDKoEDbwCYrdot1BALPs65WXR21GFYdJV9t/087EPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bUejwRhYpZWZ3ux8rX30aoCTIlzfsU/7NL9nyIxQhH2ClV7RMXrrXOUgD0OVw0qU/Q9UXyC2RZQvxbiGoPRM/MBjPuoC/zzNM6q3YeNyQcpOPHPDyApZhFaABb421sGtNQ3GVyZ+a4YIK3GnvJWo/EWKXabMb1ztv6PfS/OuOLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B071F000E9;
	Thu, 28 May 2026 16:27:42 +0000 (UTC)
From: colyli@fygo.io
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Coly Li <colyli@fygo.io>
Subject: [PATCH RESEND] MAINTAINERS: Update Coly Li's E-mail address
Date: Fri, 29 May 2026 00:27:35 +0800
Message-ID: <20260528162735.53348-1-colyli@fygo.io>
X-Mailer: git-send-email 2.54.0
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
index 461a3eed6129..3167c5925381 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4447,7 +4447,7 @@ F:	include/uapi/linux/batman_adv.h
 F:	net/batman-adv/
 
 BCACHE (BLOCK LAYER CACHE)
-M:	Coly Li <colyli@fnnas.com>
+M:	Coly Li <colyli@fygo.io>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
 L:	linux-bcache@vger.kernel.org
 S:	Maintained
-- 
2.50.1 (Apple Git-155)

