From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH 1/2] bcache: introduce ioprio-based bypass/writeback
 hints
Date: Wed, 28 Sep 2016 21:26:03 +0200
Message-ID: <20160928212603.441ff555@jupiter.sol.kaishome.de>
References: <S1754035AbcIZXgt/20160926233649Z+17415@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55635 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932299AbcI1T0Q (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Sep 2016 15:26:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1bpKUb-0006ur-Ad
        for linux-bcache@vger.kernel.org; Wed, 28 Sep 2016 21:26:09 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Mon, 26 Sep 2016 16:17:22 -0700
schrieb Eric Wheeler <git@linux.ewheeler.net>:

> Add support to bcache hinting functions and sysfs to hint by the
> ioprio of 'current' which can be configured with `ionice`.
> 
> Cache hinting is configurable by writing 'class,level' pairs to sysfs.
> These are the defaults:
> 	echo 2,7 > /sys/block/bcache0/bcache/ioprio_bypass
> 	echo 2,0 > /sys/block/bcache0/bcache/ioprio_writeback
> 
> (-p) IO Class	 (-n) Class level	Action
> -----------------------------------------------------
> (1) Realtime	  0-7				Writeback
> (2) Best-effort     0 				Writeback
> (2) Best-effort   1-6				Original bcache
> logic (2) Best-effort     7				Bypass
> cache (3) Idle          n/a				Bypass
> cache
> 
> See `man ionice` for more ioprio detail.

This patch fails to apply on 4.7.5... Is it possible to adapt for that
version?

> Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
> ---
>  drivers/md/bcache/bcache.h    |  3 +++
>  drivers/md/bcache/request.c   | 13 +++++++++++++
>  drivers/md/bcache/sysfs.c     | 45
> +++++++++++++++++++++++++++++++++++++++++++
> drivers/md/bcache/writeback.c |  3 +++ drivers/md/bcache/writeback.h
> | 13 +++++++++++++ 5 files changed, 77 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 6b420a5..bf945fa 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -367,6 +367,9 @@ struct cached_dev {
>  	unsigned		writeback_rate_update_seconds;
>  	unsigned		writeback_rate_d_term;
>  	unsigned		writeback_rate_p_term_inverse;
> +
> +	unsigned short		ioprio_writeback;
> +	unsigned short		ioprio_bypass;
>  };
>  
>  enum alloc_reserve {
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 4b177fe..0c0a2f6 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -375,6 +375,7 @@ static bool check_should_bypass(struct cached_dev
> *dc, struct bio *bio) unsigned sectors, congested =
> bch_get_congested(c); struct task_struct *task = current;
>  	struct io *i;
> +	struct io_context *ioc;
>  
>  	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
>  	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
> @@ -386,6 +387,18 @@ static bool check_should_bypass(struct
> cached_dev *dc, struct bio *bio) op_is_write(bio_op(bio))))
>  		goto skip;
>  
> +	/* If process ioprio is lower-or-equal to dc->ioprio_bypass,
> then
> +	 * hint for bypass. Note that a lower-priority IO class+value
> +	 * has a greater numeric value. */
> +	ioc = get_task_io_context(current, GFP_ATOMIC, NUMA_NO_NODE);
> +	if (ioc
> +		&& ioprio_valid(ioc->ioprio)
> +		&& ioprio_valid(dc->ioprio_writeback)
> +		&& ioc->ioprio >= dc->ioprio_bypass) {
> +		put_io_context(ioc);
> +		return true;
> +	}
> +
>  	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
>  	    bio_sectors(bio) & (c->sb.block_size - 1)) {
>  		pr_debug("skipping unaligned io");
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index b3ff57d..83ac010 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -106,6 +106,9 @@ rw_attribute(btree_shrinker_disabled);
>  rw_attribute(copy_gc_enabled);
>  rw_attribute(size);
>  
> +rw_attribute(ioprio_writeback);
> +rw_attribute(ioprio_bypass);
> +
>  SHOW(__bch_cached_dev)
>  {
>  	struct cached_dev *dc = container_of(kobj, struct cached_dev,
> @@ -182,6 +185,17 @@ SHOW(__bch_cached_dev)
>  		return strlen(buf);
>  	}
>  
> +	if (attr == &sysfs_ioprio_bypass)
> +		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
> +			IOPRIO_PRIO_CLASS(dc->ioprio_bypass),
> +			IOPRIO_PRIO_DATA(dc->ioprio_bypass));
> +
> +	if (attr == &sysfs_ioprio_writeback)
> +		return snprintf(buf, PAGE_SIZE-1, "%d,%ld\n",
> +			IOPRIO_PRIO_CLASS(dc->ioprio_writeback),
> +			IOPRIO_PRIO_DATA(dc->ioprio_writeback));
> +
> +
>  #undef var
>  	return 0;
>  }
> @@ -194,6 +208,8 @@ STORE(__cached_dev)
>  	unsigned v = size;
>  	struct cache_set *c;
>  	struct kobj_uevent_env *env;
> +	unsigned ioprio_class = 0; /* invalid initial ioprio values
> */
> +	unsigned ioprio_value = IOPRIO_BE_NR+1;
>  
>  #define d_strtoul(var)		sysfs_strtoul(var, dc->var)
>  #define d_strtoul_nonzero(var)	sysfs_strtoul_clamp(var,
> dc->var, 1, INT_MAX) @@ -282,6 +298,33 @@ STORE(__cached_dev)
>  	if (attr == &sysfs_stop)
>  		bcache_device_stop(&dc->disk);
>  
> +	if (attr == &sysfs_ioprio_writeback) {
> +		if (sscanf(buf, "%u,%u", &ioprio_class,
> &ioprio_value) != 2
> +			|| ioprio_class > IOPRIO_CLASS_IDLE
> +			|| ioprio_class < IOPRIO_CLASS_RT
> +			|| ioprio_value >= IOPRIO_BE_NR)
> +			pr_err("bcache: ioprio_writeback invalid
> ioprio class: %u data value: %u\n",
> +				ioprio_class, ioprio_value);
> +		else if (ioprio_class == IOPRIO_CLASS_IDLE)
> +			dc->ioprio_writeback =
> IOPRIO_PRIO_VALUE(ioprio_class, 0);
> +		else
> +			dc->ioprio_writeback =
> IOPRIO_PRIO_VALUE(ioprio_class, ioprio_value);
> +	}
> +
> +	if (attr == &sysfs_ioprio_bypass)
> +	{
> +		if (sscanf(buf, "%u,%u", &ioprio_class,
> &ioprio_value) != 2
> +			|| ioprio_class > IOPRIO_CLASS_IDLE
> +			|| ioprio_class < IOPRIO_CLASS_RT
> +			|| ioprio_value >= IOPRIO_BE_NR)
> +			pr_err("bcache: ioprio_bypass invalid ioprio
> class: %u data value: %u\n",
> +				ioprio_class, ioprio_value);
> +		else if (ioprio_class == IOPRIO_CLASS_IDLE)
> +			dc->ioprio_writeback =
> IOPRIO_PRIO_VALUE(ioprio_class, 0);
> +		else
> +			dc->ioprio_writeback =
> IOPRIO_PRIO_VALUE(ioprio_class, ioprio_value);
> +	}
> +
>  	return size;
>  }
>  
> @@ -334,6 +377,8 @@ static struct attribute *bch_cached_dev_files[] =
> { &sysfs_verify,
>  	&sysfs_bypass_torture_test,
>  #endif
> +	&sysfs_ioprio_bypass,
> +	&sysfs_ioprio_writeback,
>  	NULL
>  };
>  KTYPE(bch_cached_dev);
> diff --git a/drivers/md/bcache/writeback.c
> b/drivers/md/bcache/writeback.c index d9fd2a6..9772988 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -514,6 +514,9 @@ void bch_cached_dev_writeback_init(struct
> cached_dev *dc) dc->writeback_rate_d_term	= 30;
>  	dc->writeback_rate_p_term_inverse = 6000;
>  
> +	dc->ioprio_writeback = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0);
> +	dc->ioprio_bypass    = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
> IOPRIO_BE_NR-1); +
>  	INIT_DELAYED_WORK(&dc->writeback_rate_update,
> update_writeback_rate); }
>  
> diff --git a/drivers/md/bcache/writeback.h
> b/drivers/md/bcache/writeback.h index 301eaf5..a21fd87 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -43,6 +43,7 @@ static inline bool should_writeback(struct
> cached_dev *dc, struct bio *bio, unsigned cache_mode, bool would_skip)
>  {
>  	unsigned in_use = dc->disk.c->gc_stats.in_use;
> +	struct io_context *ioc;
>  
>  	if (cache_mode != CACHE_MODE_WRITEBACK ||
>  	    test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
> @@ -57,6 +58,18 @@ static inline bool should_writeback(struct
> cached_dev *dc, struct bio *bio, if (would_skip)
>  		return false;
>  
> +	/* If process ioprio is higher-or-equal to
> dc->ioprio_writeback, then
> +	 * hint for writeback. Note that a higher-priority IO
> class+value
> +	 * has a lesser numeric value. */
> +	ioc = get_task_io_context(current, GFP_ATOMIC, NUMA_NO_NODE);
> +	if (ioc
> +		&& ioprio_valid(ioc->ioprio)
> +		&& ioprio_valid(dc->ioprio_writeback)
> +		&& ioc->ioprio <= dc->ioprio_writeback) {
> +		put_io_context(ioc);
> +		return true;
> +	}
> +
>  	return bio->bi_opf & REQ_SYNC ||
>  		in_use <= CUTOFF_WRITEBACK;
>  }



-- 
Regards,
Kai

Replies to list-only preferred.
