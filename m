Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD7E1E502;
	Thu, 28 Aug 2025 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756396121; cv=none; b=GzAeMD2jSzh1gmEUaYzpSbNZU6XEITSYH2SwznLXScUjr2XQMKoB7S46NLxjj7bZRRie8mEEaWx0M/nJAVNWYIxN1eaffXllRSXlISfY98nULSZLO6jhbjlixQ23KgfAmLnrYEbdU8WqS1UbujcioZyaqJFPKxvxNM8obt7vv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756396121; c=relaxed/simple;
	bh=nvcSPsxVhXHWYMHhzR0t5AkQ9R5jbui7m1YleTWP8RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qLYRT6QgeyodLqLJ7N8oEM/5rZtJDL5CVN7do6U92wa9+dSElDvqkq/Qm9ULA3rZPvZjUX/gl3ubklQhGBCBfwSSr/XaKXv/EqnQXPdQuCeB1qyZM9GTMy7plDhGGr6CkmJLtZNlyC7fRtQxMChdhCaQ38ABF/R6LWV/c3vo9IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dW5SqLlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dW5SqLlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B09C4CEED;
	Thu, 28 Aug 2025 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756396121;
	bh=nvcSPsxVhXHWYMHhzR0t5AkQ9R5jbui7m1YleTWP8RQ=;
	h=From:To:Cc:Subject:Date:From;
	b=dW5SqLlbYymqsLefre5G3mFxAt2F9SgS7SAWWdaCiQtzKX+M/8Yi0c6/+c8z0flud
	 HHigEwHQ20HzDqIHGYghbtd73kwemeQU8dMwIS9yxyy7uzptdXFYHEUG0AQCPphTfM
	 JxrynJwfwkR64FhuvEJMfslxLb6obHgT6eCYmsKqFMYkGyqvZ1OYmpeHZGMrJDSmuP
	 DUReYsM5aW2I2YgGL7u17JRfELHqeMaJjW7RNZoch3QDNFbEyrINp4qGAHB3LQtInO
	 ZwSJITTAFCJjojL02xAjnnTiwgnWhBnAaDZFAKLqdXFvgbTg18W4T8FlwJdbT+M8UA
	 yJ2/j/4u7CbWg==
From: colyli@kernel.org
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH] bcache: change maintainer's email address
Date: Thu, 28 Aug 2025 23:48:35 +0800
Message-ID: <20250828154835.32926-1-colyli@kernel.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@suse.de>

Change to my new email address on fnnas.com.

Signed-off-by: Coly Li <colyli@fnnas.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fed6cd812d79..fcd6c26575d0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4205,7 +4205,7 @@ W:	http://www.baycom.org/~tom/ham/ham.html
 F:	drivers/net/hamradio/baycom*
 
 BCACHE (BLOCK LAYER CACHE)
-M:	Coly Li <colyli@kernel.org>
+M:	Coly Li <colyli@fnnas.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
 L:	linux-bcache@vger.kernel.org
 S:	Maintained
-- 
2.39.5

