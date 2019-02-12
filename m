From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 19/19] bcache: use (REQ_META|REQ_PRIO) to indicate bio for
 metadata
Date: Wed, 13 Feb 2019 00:48:33 +0800
Message-ID: <7fc65caf-8982-61d2-776b-ab08cb29711e@suse.de>
References: <20190209045311.15677-20-colyli@suse.de>
 <20190212132824.1D1502084E@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190212132824.1D1502084E@mail.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-bcache@vger.kernel.org

On 2019/2/12 9:28 下午, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v4.20.7, v4.19.20, v4.14.98, v4.9.155, v4.4.173, v3.18.134.
> 
> v4.20.7: Build OK!
> v4.19.20: Failed to apply! Possible dependencies:
>     752f66a75aba ("bcache: use REQ_PRIO to indicate bio for metadata")
> 
> v4.14.98: Failed to apply! Possible dependencies:
>     752f66a75aba ("bcache: use REQ_PRIO to indicate bio for metadata")
>     b41c9b0266e8 ("bcache: update bio->bi_opf bypass/writeback REQ_ flag hints")
> 
> v4.9.155: Failed to apply! Possible dependencies:
>     752f66a75aba ("bcache: use REQ_PRIO to indicate bio for metadata")
>     83b5df67c509 ("bcache: use op_is_sync to check for synchronous requests")
>     b41c9b0266e8 ("bcache: update bio->bi_opf bypass/writeback REQ_ flag hints")
> 
> v4.4.173: Failed to apply! Possible dependencies:
>     09cbfeaf1a5a ("mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release} macros")
>     1c2e54e1ed6f ("dm thin: bump thin and thin-pool target versions")
>     1eff9d322a44 ("block: rename bio bi_rw to bi_opf")
>     202bae52934d ("dm thin: unroll issue_discard() to create longer discard bio chains")
>     38f252553300 ("block: add __blkdev_issue_discard")
>     3dba53a958a7 ("dm thin: use __blkdev_issue_discard for async discard support")
>     4e49ea4a3d27 ("block/fs/drivers: remove rw argument from submit_bio")
>     83b5df67c509 ("bcache: use op_is_sync to check for synchronous requests")
>     9082e87bfbf8 ("block: remove struct bio_batch")
>     a6111d11b8b5 ("btrfs: raid56: Use raid_write_end_io for scrub")
>     b41c9b0266e8 ("bcache: update bio->bi_opf bypass/writeback REQ_ flag hints")
>     bbd848e0fade ("block: reinstate early return of -EOPNOTSUPP from blkdev_issue_discard")
>     c3667cc61904 ("dm thin: consistently return -ENOSPC if pool has run out of data space")
>     c8d93247f1d0 ("bcache: use op_is_write instead of checking for REQ_WRITE")
>     d57d611505d9 ("kernel/fs: fix I/O wait not accounted for RW O_DSYNC")
> 
> v3.18.134: Failed to apply! Possible dependencies:
>     1b94b5567e9c ("Btrfs, raid56: use a variant to record the operation type")
>     1eff9d322a44 ("block: rename bio bi_rw to bi_opf")
>     2c8cdd6ee4e7 ("Btrfs, replace: write dirty pages into the replace target device")
>     326e1dbb5736 ("block: remove management of bi_remaining when restoring original bi_end_io")
>     4245215d6a8d ("Btrfs, raid56: fix use-after-free problem in the final device replace procedure on raid56")
>     5a6ac9eacb49 ("Btrfs, raid56: support parity scrub on raid56")
>     6e9606d2a2dc ("Btrfs: add ref_count and free function for btrfs_bio")
>     83b5df67c509 ("bcache: use op_is_sync to check for synchronous requests")
>     8e5cfb55d3f7 ("Btrfs: Make raid_map array be inlined in btrfs_bio structure")
>     af8e2d1df984 ("Btrfs, scrub: repair the common data on RAID5/6 if it is corrupted")
>     b41c9b0266e8 ("bcache: update bio->bi_opf bypass/writeback REQ_ flag hints")
>     b7c44ed9d2fc ("block: manipulate bio->bi_flags through helpers")
>     b89e1b012c7f ("Btrfs, raid56: don't change bbio and raid_map")
>     c4cf5261f8bf ("bio: skip atomic inc/dec of ->bi_remaining for non-chains")
>     c8d93247f1d0 ("bcache: use op_is_write instead of checking for REQ_WRITE")
>     f90523d1aa3c ("Btrfs: remove noused bbio_ret in __btrfs_map_block in condition")
> 
> 
> How should we proceed with this patch?

Can I rebase this patch for each stable kernel, and send the patch to
stable@vger.kernel.org ?

Thanks.

-- 

Coly Li
