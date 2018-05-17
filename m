From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v3] bcache: return 0 from bch_debug_init() if
 CONFIG_DEBUG_FS=n
Date: Thu, 17 May 2018 10:48:28 -0400
Message-ID: <20180517144828.GA8223@kmo-pixel>
References: <20180517143254.48670-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180517143254.48670-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Thu, May 17, 2018 at 10:32:54PM +0800, Coly Li wrote:
> Commit 539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
> returns the return value of debugfs_create_dir() to bcache_init(). When
> CONFIG_DEBUG_FS=n, bch_debug_init() always returns 1 and makes
> bcache_init() failedi.
> 
> This patch makes bch_debug_init() always returns 0 if CONFIG_DEBUG_FS=n,
> so bcache can continue to work for the kernels which don't have debugfs
> enanbled.
> 
> Fixes: Commit 539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Coly Li <colyli@suse.de>
> Reported-by: Massimo B. <massimo.b@gmx.net>
> Reported-by: Kai Krakow <kai@kaishome.de>
> Tested-by: Kai Krakow <kai@kaishome.de>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>

Acked-by: Kent Overstreet <kent.overstreet@gmail.com>
