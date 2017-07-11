From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 09/19 v2] bcache: update bio->bi_opf bypass/writeback REQ_
 flag hints
Date: Tue, 11 Jul 2017 11:48:41 +0800
Message-ID: <e5bf5af0-4374-6d1c-2b57-3529d0e73e92@suse.de>
References: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
 <1499122284-11016-1-git-send-email-bcache@lists.ewheeler.net>
 <20170705184814.GB3234@infradead.org>
 <060c352f-894b-57e0-cdf9-6af716376cb9@coly.li>
 <20170706152438.GA18245@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50852 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753810AbdGKDst (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Jul 2017 23:48:49 -0400
In-Reply-To: <20170706152438.GA18245@infradead.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: bcache@lists.ewheeler.net, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>

On 2017/7/6 下午11:24, Christoph Hellwig wrote:
> On Thu, Jul 06, 2017 at 03:35:48PM +0800, Coly Li wrote:
>> Then gfs2 breaks the above rule ?  in gfs2_metapath_ra() and
>> gfs2_dir_readahead(), only REQ_META is used in submit_bh(). It seems an
>> extra REQ_PRIO should be there.
> 
> Or maybe not.  E.g. XFS absolutely avoids using REQ_PRIO for any of
> the buffer writeback as it does not have priority.  You'll need to
> ask gfs2 folks if they want this I/O to have priority or not.
> 

I see. Just sent a RFC patch to gfs2 development list, and wait for
response.

Thanks for the hint.
