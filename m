From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] bcache: remove dupplicated declaration from btree.h
Date: Tue, 24 Mar 2020 19:57:28 -0600
Message-ID: <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
References: <20200325013057.114340-1-colyli@suse.de>
 <20200325013057.114340-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200325013057.114340-2-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, kbuild test robot <lkp@intel.com>
List-Id: linux-bcache@vger.kernel.org

On 3/24/20 7:30 PM, Coly Li wrote:
> Commit ab544165dc2d ("bcache: move macro btree() and btree_root()
> into btree.h") makes two duplicated declaration into btree.h,
> 	typedef int (btree_map_keys_fn)();
> 	int bch_btree_map_keys();
> 
> The kbuild test robot <lkp@intel.com> detects and reports this
> problem and this patch fixes it by removing the duplicated ones.
> 
> Fixes: ab544165dc2d ("bcache: move macro btree() and btree_root() into btree.h")

Applied, but I fixed up the commit sha, not sure where yours is from?

-- 
Jens Axboe
