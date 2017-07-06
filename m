From: Coly Li <i@coly.li>
Subject: Re: [PATCH 09/19 v2] bcache: update bio->bi_opf bypass/writeback REQ_
 flag hints
Date: Thu, 6 Jul 2017 15:35:48 +0800
Message-ID: <060c352f-894b-57e0-cdf9-6af716376cb9@coly.li>
References: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
 <1499122284-11016-1-git-send-email-bcache@lists.ewheeler.net>
 <20170705184814.GB3234@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170705184814.GB3234@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, bcache@lists.ewheeler.net
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

On 2017/7/6 上午2:48, Christoph Hellwig wrote:
> REQ_META should be purely a hint for blktrace, please don't use it
> in the I/O path - that's what REQ_PRIO is for.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Christoph,

Then gfs2 breaks the above rule ?  in gfs2_metapath_ra() and
gfs2_dir_readahead(), only REQ_META is used in submit_bh(). It seems an
extra REQ_PRIO should be there.

I see 'commit 70246286e94c3 ("block: get rid of bio_rw and READA")' is
from you, could you please provide your point on adding REQ_PRIO on the
above 2 locations ?

IMHO another patch to add REQ_PRIO to gfs2 meta data read ahead code
path should be necessary.

Thanks.


-- 
Coly Li
