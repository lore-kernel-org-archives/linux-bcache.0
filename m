From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 08/10] block: move bio_alloc_pages() to bcache
Date: Tue, 9 Jan 2018 09:21:52 +0800
Message-ID: <20180109012151.GA31067@ming.t460p>
References: <20171208131409.11889-1-ming.lei@redhat.com>
 <20171208131409.11889-9-ming.lei@redhat.com>
 <c388724b-45eb-445c-8a93-cf25c313fa65@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c388724b-45eb-445c-8a93-cf25c313fa65@lyle.org>
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-bcache <linux-bcache@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Jan 08, 2018 at 10:05:09AM -0800, Michael Lyle wrote:
> On 12/08/2017 05:14 AM, Ming Lei wrote:
> > bcache is the only user of bio_alloc_pages(), and all users should use
> > bio_add_page() instead, so move this function into bcache, and avoid
> > it misused in future.
> 
> Can things like this -please- be sent to the bcache list and bcache
> maintainers?  I'm preparing my patch set for Jens and I'm surprised by
> merge conflicts from stuff in my queue.  (Just showed up in next to show
> the conflict in the past couple of days).

OK, will do next time.

-- 
Ming
