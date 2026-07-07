Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03650320CD9;
	Tue,  7 Jul 2026 08:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783413013; cv=none; b=QcRO6DCHhDqlFA/KrSmBnhY/bGCH6zGLkpp82bQJodJ3yhsR0gUYveHWWF8vK2A6kI4kenTDbQbRbWVQ7bhTtd3oeGz4hOZ4q+fJ4ecPQf0ppKJD2LO3X2qVyHghgSJyOFz+SaD3MkazSX+VeVlb5ETxADQt6XBRZqwmDGC6dJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783413013; c=relaxed/simple;
	bh=Ze+ANnQUIwr46aU74TbA7FHFUG8IWDdiP1FTqSPOwvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxIGKEkSob/lAnEUIW24lwFyy4b//cCcJkL5FRid/g00X92kP6SiMjYEAOeVpEyJw3p7zgNr8+DrPlPgiYPAssNuWCpYGHS39jGzAOcPebT01HfsjVugDvBNp/YUWcyAd+rXOcBpE/nCpVI5mcraxLfwsjXJ8IqZETEWuSH6nTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NkndNvuZ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NkndNvuZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783413011; x=1814949011;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ze+ANnQUIwr46aU74TbA7FHFUG8IWDdiP1FTqSPOwvU=;
  b=NkndNvuZ5QJyo7XJMJhjaEcasu7FIP+ATfaUrUJYhlIKIXZVlgZssslT
   T3lHcfLs5vX8eFmGX5Jxzg5v1SXXeXq6VJePB62hlZbkmty9y776ip0dU
   xeqSF/vZn+bBzlxev9tZLNjdltzdEreuTKaIwtJ1F562aLNC1z8mkY6ru
   7C7d6EHWc6Ka03lvBIZAKqpD05BdbL8Qji6/H52Fok7fXKXNCVK1WdO0w
   haZgaVbfUaJFcHnpiRJ5u1hSZPRX+gac0cA1hlkCBMmvnK6oxCvmSdsvI
   enDishHdT2Mn79J+0mXWuUQpfaEucomPE1M5f7d0kF03NNNBFJg0uqRNU
   Q==;
X-CSE-ConnectionGUID: 5lf8M+cSTp+1kE+45uArDA==
X-CSE-MsgGUID: BLpNwqvcTBmu90KEZxe7UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="83917431"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="83917431"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 01:30:10 -0700
X-CSE-ConnectionGUID: mkngk2JnRnSFUA3t3b2XFw==
X-CSE-MsgGUID: l7WTvBfYQWidl96AzgvsGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="254024832"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 07 Jul 2026 01:30:08 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wh1Bq-00000000F9r-29MM;
	Tue, 07 Jul 2026 08:30:03 +0000
Date: Tue, 7 Jul 2026 16:29:42 +0800
From: kernel test robot <lkp@intel.com>
To: Qiliang Yuan <realwujing@gmail.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	Jing Wu <realwujing@gmail.com>
Subject: Re: [PATCH RESEND v2] bcache: convert bch_register_lock to
 rw_semaphore
Message-ID: <202607071617.e4elNFQN-lkp@intel.com>
References: <20260706-feat-bcache-v2-1-70a4b6e246c0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706-feat-bcache-v2-1-70a4b6e246c0@gmail.com>

Hi Qiliang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 502d801f0ab03e4f32f9a33d203154ce84887921]

url:    https://github.com/intel-lab-lkp/linux/commits/Qiliang-Yuan/bcache-convert-bch_register_lock-to-rw_semaphore/20260706-212031
base:   502d801f0ab03e4f32f9a33d203154ce84887921
patch link:    https://lore.kernel.org/r/20260706-feat-bcache-v2-1-70a4b6e246c0%40gmail.com
patch subject: [PATCH RESEND v2] bcache: convert bch_register_lock to rw_semaphore
config: arc-allmodconfig (https://download.01.org/0day-ci/archive/20260707/202607071617.e4elNFQN-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260707/202607071617.e4elNFQN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607071617.e4elNFQN-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/md/bcache/sysfs.c: In function 'bch_cached_dev_show':
>> drivers/md/bcache/sysfs.c:290:28: warning: unused variable 'dc' [-Wunused-variable]
     290 |         struct cached_dev *dc = container_of(kobj, struct cached_dev,
         |                            ^~


vim +/dc +290 drivers/md/bcache/sysfs.c

   178	
   179		if (attr == &sysfs_cache_mode)
   180			return bch_snprint_string_list(buf, PAGE_SIZE,
   181						       bch_cache_modes,
   182						       BDEV_CACHE_MODE(&dc->sb));
   183	
   184		if (attr == &sysfs_readahead_cache_policy)
   185			return bch_snprint_string_list(buf, PAGE_SIZE,
   186						      bch_reada_cache_policies,
   187						      dc->cache_readahead_policy);
   188	
   189		if (attr == &sysfs_stop_when_cache_set_failed)
   190			return bch_snprint_string_list(buf, PAGE_SIZE,
   191						       bch_stop_on_failure_modes,
   192						       dc->stop_when_cache_set_failed);
   193	
   194	
   195		sysfs_printf(data_csum,		"%i", dc->disk.data_csum);
   196		var_printf(verify,		"%i");
   197		var_printf(bypass_torture_test,	"%i");
   198		var_printf(writeback_metadata,	"%i");
   199		var_printf(writeback_running,	"%i");
   200		var_printf(writeback_consider_fragment,	"%i");
   201		var_print(writeback_delay);
   202		var_print(writeback_percent);
   203		sysfs_hprint(writeback_rate,
   204			     wb ? atomic_long_read(&dc->writeback_rate.rate) << 9 : 0);
   205		sysfs_printf(io_errors,		"%i", atomic_read(&dc->io_errors));
   206		sysfs_printf(io_error_limit,	"%i", dc->error_limit);
   207		sysfs_printf(io_disable,	"%i", dc->io_disable);
   208		var_print(writeback_rate_update_seconds);
   209		var_print(writeback_rate_i_term_inverse);
   210		var_print(writeback_rate_p_term_inverse);
   211		var_print(writeback_rate_fp_term_low);
   212		var_print(writeback_rate_fp_term_mid);
   213		var_print(writeback_rate_fp_term_high);
   214		var_print(writeback_rate_minimum);
   215	
   216		if (attr == &sysfs_writeback_rate_debug) {
   217			char rate[20];
   218			char dirty[20];
   219			char target[20];
   220			char proportional[20];
   221			char integral[20];
   222			char change[20];
   223			s64 next_io;
   224	
   225			/*
   226			 * Except for dirty and target, other values should
   227			 * be 0 if writeback is not running.
   228			 */
   229			bch_hprint(rate,
   230				   wb ? atomic_long_read(&dc->writeback_rate.rate) << 9
   231				      : 0);
   232			bch_hprint(dirty, bcache_dev_sectors_dirty(&dc->disk) << 9);
   233			bch_hprint(target, dc->writeback_rate_target << 9);
   234			bch_hprint(proportional,
   235				   wb ? dc->writeback_rate_proportional << 9 : 0);
   236			bch_hprint(integral,
   237				   wb ? dc->writeback_rate_integral_scaled << 9 : 0);
   238			bch_hprint(change, wb ? dc->writeback_rate_change << 9 : 0);
   239			next_io = wb ? div64_s64(dc->writeback_rate.next-local_clock(),
   240						 NSEC_PER_MSEC) : 0;
   241	
   242			return sprintf(buf,
   243				       "rate:\t\t%s/sec\n"
   244				       "dirty:\t\t%s\n"
   245				       "target:\t\t%s\n"
   246				       "proportional:\t%s\n"
   247				       "integral:\t%s\n"
   248				       "change:\t\t%s/sec\n"
   249				       "next io:\t%llims\n",
   250				       rate, dirty, target, proportional,
   251				       integral, change, next_io);
   252		}
   253	
   254		sysfs_hprint(dirty_data,
   255			     bcache_dev_sectors_dirty(&dc->disk) << 9);
   256	
   257		sysfs_hprint(stripe_size,	 ((uint64_t)dc->disk.stripe_size) << 9);
   258		var_printf(partial_stripes_expensive,	"%u");
   259	
   260		var_hprint(sequential_cutoff);
   261	
   262		sysfs_print(running,		atomic_read(&dc->running));
   263		sysfs_print(state,		states[BDEV_STATE(&dc->sb)]);
   264	
   265		if (attr == &sysfs_label) {
   266			memcpy(buf, dc->sb.label, SB_LABEL_SIZE);
   267			buf[SB_LABEL_SIZE + 1] = '\0';
   268			strcat(buf, "\n");
   269			return strlen(buf);
   270		}
   271	
   272		if (attr == &sysfs_backing_dev_name) {
   273			snprintf(buf, BDEVNAME_SIZE + 1, "%pg", dc->bdev);
   274			strcat(buf, "\n");
   275			return strlen(buf);
   276		}
   277	
   278		if (attr == &sysfs_backing_dev_uuid) {
   279			/* convert binary uuid into 36-byte string plus '\0' */
   280			snprintf(buf, 36+1, "%pU", dc->sb.uuid);
   281			strcat(buf, "\n");
   282			return strlen(buf);
   283		}
   284	
   285	#undef var
   286		return 0;
   287	}
   288	SHOW(bch_cached_dev)
   289	{
 > 290		struct cached_dev *dc = container_of(kobj, struct cached_dev,
   291						     disk.kobj);
   292		ssize_t ret;
   293	
   294		/*
   295		 * Statistics attributes like dirty_data read atomic variables and
   296		 * can be shown without holding the global bch_register_lock.
   297		 */
   298		if (attr == &sysfs_dirty_data ||
   299		    attr == &sysfs_writeback_rate_debug)
   300			return __bch_cached_dev_show(kobj, attr, buf);
   301	
   302		down_read(&bch_register_lock);
   303		ret = __bch_cached_dev_show(kobj, attr, buf);
   304		up_read(&bch_register_lock);
   305	
   306		return ret;
   307	}
   308	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
