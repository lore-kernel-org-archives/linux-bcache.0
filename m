From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] bcache: ignore pending signals when creating gc and
 allocator thread
Date: Thu, 20 Feb 2020 08:38:03 -0800
Message-ID: <20200220163803.GA12147@infradead.org>
References: <20200213141207.77219-1-colyli@suse.de>
 <20200213141207.77219-2-colyli@suse.de>
 <20200219163200.GA18377@infradead.org>
 <1f6cd622-3476-068b-3593-f918ab011156@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f6cd622-3476-068b-3593-f918ab011156@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Feb 20, 2020 at 09:20:49PM +0800, Coly Li wrote:
> Therefore I need to explicitly call pending_signal() before calling
> kthread_run().

Right now you have to.  But the proper fix is to not require this and
fix kthread_run to work from a thread that has been selected by the OOM
killer.  In the most trivial version by moving your code into
kthread_run, but there probably are better ways as well.
