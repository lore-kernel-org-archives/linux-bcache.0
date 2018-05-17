From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] bcache: return 0 from bch_debug_init() if
 CONFIG_DEBUG_FS=n
Date: Thu, 17 May 2018 09:43:56 -0600
Message-ID: <b0eb269d-3b3f-2b14-12fd-055b91fe216a@kernel.dk>
References: <20180517153326.49271-1-colyli@suse.de>
 <20180517153326.49271-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180517153326.49271-2-colyli@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 5/17/18 9:33 AM, Coly Li wrote:
> Commit 539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
> returns the return value of debugfs_create_dir() to bcache_init(). When
> CONFIG_DEBUG_FS=n, bch_debug_init() always returns 1 and makes
> bcache_init() failedi.
> 
> This patch makes bch_debug_init() always returns 0 if CONFIG_DEBUG_FS=n,
> so bcache can continue to work for the kernels which don't have debugfs
> enanbled.

Applied, thanks.


-- 
Jens Axboe
