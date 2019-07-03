From: Boaz Harrosh <openosd@gmail.com>
Subject: [PATCH] mm: Support madvise_willneed override by Filesystems
Date: Wed, 3 Jul 2019 04:04:57 +0300
Message-ID: <27171de5-430e-b3a8-16f1-7ce25b76c874@gmail.com>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel>
 <20190612230224.GJ14308@dread.disaster.area>
 <20190619082141.GA32409@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619082141.GA32409@quack2.suse.cz>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, Waiman Long <longman@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-bcache@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Zach Brown <zach.brown@ni.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 19/06/2019 11:21, Jan Kara wrote:
<>
> Yes, I have patch to make madvise(MADV_WILLNEED) go through ->fadvise() as
> well. I'll post it soon since the rest of the series isn't really dependent
> on it.
> 
> 								Honza
> 

Hi Jan

Funny I'm sitting on the same patch since LSF last. I need it too for other
reasons. I have not seen, have you pushed your patch yet?
(Is based on old v4.20)

~~~~~~~~~
From fddb38169e33d23060ddd444ba6f2319f76edc89 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <boazh@netapp.com>
Date: Thu, 16 May 2019 20:02:14 +0300
Subject: [PATCH] mm: Support madvise_willneed override by Filesystems

In the patchset:
	[b833a3660394] ovl: add ovl_fadvise()
	[3d8f7615319b] vfs: implement readahead(2) using POSIX_FADV_WILLNEED
	[45cd0faae371] vfs: add the fadvise() file operation

Amir Goldstein introduced a way for filesystems to overide fadvise.
Well madvise_willneed is exactly as fadvise_willneed except it always
returns 0.

In this patch we call the FS vector if it exists.

NOTE: I called vfs_fadvise(..,POSIX_FADV_WILLNEED);
      (Which is my artistic preference)

I could also selectively call
	if (file->f_op->fadvise)
		return file->f_op->fadvise(..., POSIX_FADV_WILLNEED);
If we fear theoretical side effects. I don't mind either way.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Boaz Harrosh <boazh@netapp.com>
---
 mm/madvise.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 6cb1ca93e290..6b84ddcaaaf2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -24,6 +24,7 @@
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/fadvise.h>
 
 #include <asm/tlb.h>
 
@@ -303,7 +304,8 @@ static long madvise_willneed(struct vm_area_struct *vma,
 		end = vma->vm_end;
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-	force_page_cache_readahead(file->f_mapping, file, start, end - start);
+	vfs_fadvise(file, start << PAGE_SHIFT, (end - start) << PAGE_SHIFT,
+		    POSIX_FADV_WILLNEED);
 	return 0;
 }
 
-- 
2.20.1
