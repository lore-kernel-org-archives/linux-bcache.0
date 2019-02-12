From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 06/19] bcache: treat stale && dirty keys as bad keys
Date: Wed, 13 Feb 2019 00:42:17 +0800
Message-ID: <7cc56107-e680-90ba-11ef-927a068d7c60@suse.de>
References: <20190209045311.15677-7-colyli@suse.de>
 <20190212132825.E476F217D9@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190212132825.E476F217D9@mail.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>, Tang Junhui <tang.junhui.linux@gmail.com>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org
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
>     149d0efada77 ("bcache: replace hard coded number with BUCKET_GC_GEN_MAX")
> 
> v4.14.98: Failed to apply! Possible dependencies:
>     1d316e658374 ("bcache: implement PI controller for writeback rate")
>     25d8be77e192 ("block: move bio_alloc_pages() to bcache")
>     27a40ab9269e ("bcache: add backing_request_endio() for bi_end_io")
>     2831231d4c3f ("bcache: reduce cache_set devices iteration by devices_max_used")
>     3b304d24a718 ("bcache: convert cached_dev.count from atomic_t to refcount_t")
>     3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
>     5138ac6748e3 ("bcache: fix misleading error message in bch_count_io_errors()")
>     539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
>     5fa89fb9a86b ("bcache: don't write back data if reading it failed")
>     6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
>     771f393e8ffc ("bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags")
>     7ba0d830dc0e ("bcache: set error_limit correctly")
>     7e027ca4b534 ("bcache: add stop_when_cache_set_failed option to backing device")
>     804f3c6981f5 ("bcache: fix cached_dev->count usage for bch_cache_set_error()")
>     a8500fc816b1 ("bcache: rearrange writeback main thread ratelimit")
>     b1092c9af9ed ("bcache: allow quick writeback when backing idle")
>     bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
>     c7b7bd07404c ("bcache: add io_disable to struct cached_dev")
> 
> v4.9.155: Failed to apply! Possible dependencies:
>     1d316e658374 ("bcache: implement PI controller for writeback rate")
>     2831231d4c3f ("bcache: reduce cache_set devices iteration by devices_max_used")
>     297e3d854784 ("blk-throttle: make throtl_slice tunable")
>     3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
>     4e4cbee93d56 ("block: switch bios to blk_status_t")
>     5138ac6748e3 ("bcache: fix misleading error message in bch_count_io_errors()")
>     6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
>     7e027ca4b534 ("bcache: add stop_when_cache_set_failed option to backing device")
>     87760e5eef35 ("block: hook up writeback throttling")
>     9e234eeafbe1 ("blk-throttle: add a simple idle detection")
>     c7b7bd07404c ("bcache: add io_disable to struct cached_dev")
>     cf43e6be865a ("block: add scalable completion tracking of requests")
>     e806402130c9 ("block: split out request-only flags into a new namespace")
>     fbbaf700e7b1 ("block: trace completion of all bios.")
> 
> v4.4.173: Failed to apply! Possible dependencies:
>     005411ea7ee7 ("doc: update block/queue-sysfs.txt entries")
>     1d316e658374 ("bcache: implement PI controller for writeback rate")
>     27489a3c827b ("blk-mq: turn hctx->run_work into a regular work struct")
>     2831231d4c3f ("bcache: reduce cache_set devices iteration by devices_max_used")
>     297e3d854784 ("blk-throttle: make throtl_slice tunable")
>     38f8baae8905 ("block: factor out chained bio completion")
>     3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
>     4e4cbee93d56 ("block: switch bios to blk_status_t")
>     511cbce2ff8b ("irq_poll: make blk-iopoll available outside the block layer")
>     5138ac6748e3 ("bcache: fix misleading error message in bch_count_io_errors()")
>     6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
>     7e027ca4b534 ("bcache: add stop_when_cache_set_failed option to backing device")
>     87760e5eef35 ("block: hook up writeback throttling")
>     8d354f133e86 ("blk-mq: improve layout of blk_mq_hw_ctx")
>     9467f85960a3 ("blk-mq/cpu-notif: Convert to new hotplug state machine")
>     9e234eeafbe1 ("blk-throttle: add a simple idle detection")
>     af3e3a5259e3 ("block: don't unecessarily clobber bi_error for chained bios")
>     ba8c6967b739 ("block: cleanup bio_endio")
>     c7b7bd07404c ("bcache: add io_disable to struct cached_dev")
>     cf43e6be865a ("block: add scalable completion tracking of requests")
>     e57690fe009b ("blk-mq: don't overwrite rq->mq_ctx")
>     fbbaf700e7b1 ("block: trace completion of all bios.")
> 
> v3.18.134: Failed to apply! Possible dependencies:
>     0f8087ecdeac ("block: Consolidate static integrity profile properties")
>     1b94b5567e9c ("Btrfs, raid56: use a variant to record the operation type")
>     1d316e658374 ("bcache: implement PI controller for writeback rate")
>     2831231d4c3f ("bcache: reduce cache_set devices iteration by devices_max_used")
>     2c8cdd6ee4e7 ("Btrfs, replace: write dirty pages into the replace target device")
>     326e1dbb5736 ("block: remove management of bi_remaining when restoring original bi_end_io")
>     3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
>     4246a0b63bd8 ("block: add a bi_error field to struct bio")
>     4e4cbee93d56 ("block: switch bios to blk_status_t")
>     5138ac6748e3 ("bcache: fix misleading error message in bch_count_io_errors()")
>     5a6ac9eacb49 ("Btrfs, raid56: support parity scrub on raid56")
>     6e9606d2a2dc ("Btrfs: add ref_count and free function for btrfs_bio")
>     6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
>     7e027ca4b534 ("bcache: add stop_when_cache_set_failed option to backing device")
>     8e5cfb55d3f7 ("Btrfs: Make raid_map array be inlined in btrfs_bio structure")
>     af8e2d1df984 ("Btrfs, scrub: repair the common data on RAID5/6 if it is corrupted")
>     b89e1b012c7f ("Btrfs, raid56: don't change bbio and raid_map")
>     c4cf5261f8bf ("bio: skip atomic inc/dec of ->bi_remaining for non-chains")
>     c7b7bd07404c ("bcache: add io_disable to struct cached_dev")
>     f90523d1aa3c ("Btrfs: remove noused bbio_ret in __btrfs_map_block in condition")
> 
> 
> How should we proceed with this patch?

Can we rebase this patch for stable kernels, and send them to stable
kernel maintainers separately? If this behavior is accepted for stable
kernel maintenance, I would suggest Junhui Tang to think about to rebase
for these stable kernels.

Thanks.

-- 

Coly Li
