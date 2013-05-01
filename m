From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [GIT PULL] Bcache fixes for 3.10
Date: Wed, 1 May 2013 09:26:16 +0200
Message-ID: <20130501072616.GH7800@kernel.dk>
References: <20130430195214.GH9931@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130430195214.GH9931-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Apr 30 2013, Kent Overstreet wrote:
> Hey Jens, this is everything I've got ready for 3.10 - there's _still_
> one more bug I'm trying to track down.
> 
> Andrew - I've got patches that rip out the pkey() and pbtree() macros,
> but they're somewhat tied up with some other nontrivial refactorings so
> I think I'm going to wait a bit on those.
> 
> The following changes since commit cef5279735d3f6f0243e626963e6d5c84efade0a:
> 
>   bcache: Disable broken btree fuzz tester (2013-04-08 13:33:49 -0700)
> 
> are available in the git repository at:
> 
>   http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> 
> for you to fetch changes up to cd66f1f69ed40270bb34e20b25a8111bc72a1b2a:
> 
>   bcache: Use bd_link_disk_holder() (2013-04-24 13:15:17 -0700)
> 
> ----------------------------------------------------------------
> Kent Overstreet (8):
>       bcache: Take data offset from the bdev superblock.
>       bcache: Set ra_pages based on backing device's ra_pages
>       bcache: Hack around stuff that clones up to bi_max_vecs
>       bcache: Correctly check against BIO_MAX_PAGES
>       bcache: Fix merge_bvec_fn usage for when it modifies the bvm
>       bcache: Make sure blocksize isn't smaller than device blocksize
>       bcache: Allocator cleanup/fixes
>       bcache: Use bd_link_disk_holder()
> 
>  drivers/md/bcache/alloc.c   |  74 +++++++++++++-------
>  drivers/md/bcache/bcache.h  |  48 ++++++++++---
>  drivers/md/bcache/btree.c   |   8 +--
>  drivers/md/bcache/io.c      |  35 ++++++----
>  drivers/md/bcache/request.c |   2 +-
>  drivers/md/bcache/super.c   | 166 +++++++++++++++++++++++++++-----------------
>  6 files changed, 215 insertions(+), 118 deletions(-)

This is what I got, when I pulled it in:

Merge made by the 'recursive' strategy.
 drivers/md/bcache/alloc.c   |  72 +++++++++++++------
 drivers/md/bcache/bcache.h  |  47 ++++++++++---
 drivers/md/bcache/btree.c   |   3 +-
 drivers/md/bcache/io.c      |  35 ++++++----
 drivers/md/bcache/request.c |   2 +-
 drivers/md/bcache/super.c   | 166 +++++++++++++++++++++++++++-----------------
 6 files changed, 213 insertions(+), 112 deletions(-)

I only see the same 8 commits there. What happened? Please check
for-3.10/drivers and verify it looks as you expect.

-- 
Jens Axboe
