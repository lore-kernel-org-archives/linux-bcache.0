From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH 4/4] MAINTAINERS: mark bcache as orphan
Date: Tue, 24 May 2016 16:38:50 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1605241636520.31937@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1605241634270.31937@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

The submitted patches are not being reacted upon, and Jens is only picking 
up stable fixes on an rather ad-hoc basis.

Link: lkml.kernel.org/r/574462C5.40307@kernel.dk
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5f83015..c9906d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2288,7 +2288,7 @@ BCACHE (BLOCK LAYER CACHE)
 M:	Kent Overstreet <kent.overstreet@gmail.com>
 L:	linux-bcache@vger.kernel.org
 W:	http://bcache.evilpiepirate.org
-S:	Maintained
+S:	Orphan
 F:	drivers/md/bcache/
 
 BDISP ST MEDIA DRIVER

-- 
Jiri Kosina
SUSE Labs
