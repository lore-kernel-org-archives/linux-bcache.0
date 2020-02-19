From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] bcache: ignore pending signals when creating gc and
 allocator thread
Date: Wed, 19 Feb 2020 08:32:00 -0800
Message-ID: <20200219163200.GA18377@infradead.org>
References: <20200213141207.77219-1-colyli@suse.de>
 <20200213141207.77219-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34100 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgBSQcA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Feb 2020 11:32:00 -0500
Content-Disposition: inline
In-Reply-To: <20200213141207.77219-2-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On Thu, Feb 13, 2020 at 10:12:05PM +0800, Coly Li wrote:
> +	/*
> +	 * In case previous btree check operation occupies too many
> +	 * system memory for bcache btree node cache, and the
> +	 * registering process is selected by OOM killer. Here just
> +	 * ignore the SIGKILL sent by OOM killer if there is, to
> +	 * avoid kthread_run() being failed by pending signals. The
> +	 * bcache registering process will exit after the registration
> +	 * done.
> +	 */
> +	if (signal_pending(current))
> +		flush_signals(current);
> +
> +	k = kthread_run(bch_allocator_thread, ca, "bcache_allocator");

This really needs to go into the kthread code itself instead of
requiring cargo culting in the callers.
