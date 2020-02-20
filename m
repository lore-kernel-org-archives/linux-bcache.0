From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/3] bcache: ignore pending signals when creating gc and
 allocator thread
Date: Fri, 21 Feb 2020 00:47:56 +0800
Message-ID: <b2f997ce-3b47-19ec-439d-e29a35ff7ef4@suse.de>
References: <20200213141207.77219-1-colyli@suse.de>
 <20200213141207.77219-2-colyli@suse.de>
 <20200219163200.GA18377@infradead.org>
 <1f6cd622-3476-068b-3593-f918ab011156@suse.de>
 <20200220163803.GA12147@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200220163803.GA12147@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2020/2/21 12:38 上午, Christoph Hellwig wrote:
> On Thu, Feb 20, 2020 at 09:20:49PM +0800, Coly Li wrote:
>> Therefore I need to explicitly call pending_signal() before calling
>> kthread_run().
> 
> Right now you have to.  But the proper fix is to not require this and
> fix kthread_run to work from a thread that has been selected by the OOM
> killer.  In the most trivial version by moving your code into
> kthread_run, but there probably are better ways as well.
> 

Yes I see. Let me think about it, at this moment kthread_run() is still
not very clear in my mind.

Thanks for the hint.

-- 

Coly Li
