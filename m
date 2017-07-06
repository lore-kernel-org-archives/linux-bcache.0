From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/19 v2] bcache: update bio->bi_opf bypass/writeback
 REQ_ flag hints
Date: Thu, 6 Jul 2017 08:24:38 -0700
Message-ID: <20170706152438.GA18245@infradead.org>
References: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
 <1499122284-11016-1-git-send-email-bcache@lists.ewheeler.net>
 <20170705184814.GB3234@infradead.org>
 <060c352f-894b-57e0-cdf9-6af716376cb9@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <060c352f-894b-57e0-cdf9-6af716376cb9@coly.li>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Christoph Hellwig <hch@infradead.org>, bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

On Thu, Jul 06, 2017 at 03:35:48PM +0800, Coly Li wrote:
> Then gfs2 breaks the above rule ?  in gfs2_metapath_ra() and
> gfs2_dir_readahead(), only REQ_META is used in submit_bh(). It seems an
> extra REQ_PRIO should be there.

Or maybe not.  E.g. XFS absolutely avoids using REQ_PRIO for any of
the buffer writeback as it does not have priority.  You'll need to
ask gfs2 folks if they want this I/O to have priority or not.
