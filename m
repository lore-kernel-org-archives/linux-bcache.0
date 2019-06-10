From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 04/12] mm: export find_get_pages()
Date: Mon, 10 Jun 2019 15:14:12 -0400
Message-ID: <20190610191420.27007-5-kent.overstreet@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610191420.27007-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Needed for bcachefs

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 mm/filemap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 93d7e0e686..617168474e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1899,6 +1899,7 @@ unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
 
 	return ret;
 }
+EXPORT_SYMBOL(find_get_pages_range);
 
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
-- 
2.20.1
