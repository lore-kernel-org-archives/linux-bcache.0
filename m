From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/19 v2] bcache: update bio->bi_opf bypass/writeback
 REQ_ flag hints
Date: Wed, 5 Jul 2017 11:48:14 -0700
Message-ID: <20170705184814.GB3234@infradead.org>
References: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
 <1499122284-11016-1-git-send-email-bcache@lists.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499122284-11016-1-git-send-email-bcache@lists.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: bcache@lists.ewheeler.net
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, hch@infradead.org, axboe@kernel.dk, i@coly.li, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>
List-Id: linux-bcache@vger.kernel.org

REQ_META should be purely a hint for blktrace, please don't use it
in the I/O path - that's what REQ_PRIO is for.
