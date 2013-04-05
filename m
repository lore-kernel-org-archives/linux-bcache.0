From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache memleaks
Date: Fri, 5 Apr 2013 14:07:45 -0700
Message-ID: <20130405210745.GB15749@google.com>
References: <20130401190958.GA18634@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130401190958.GA18634-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Apr 01, 2013 at 03:09:58PM -0400, Mike Snitzer wrote:
> FYI, here are some leaks that kmemleak caught when I tested Jens'
> for-next with test_git_extract_bcache_quick from the thinp-test-suite:

Thanks - looks like it was all the same allocation. Just pushed the fix:


commit 671963671170880beed71378f51124433ffeebb8
Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date:   Fri Apr 5 13:46:13 2013 -0700

    bcache: Fix a minor memory leak on device teardown
    
    Reported-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f47ecb5..5fa3cd2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -64,9 +64,11 @@ struct workqueue_struct *bcache_wq;
 
 static void bio_split_pool_free(struct bio_split_pool *p)
 {
+	if (p->bio_split_hook)
+		mempool_destroy(p->bio_split_hook);
+
 	if (p->bio_split)
 		bioset_free(p->bio_split);
-
 }
 
 static int bio_split_pool_init(struct bio_split_pool *p)
