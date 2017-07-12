From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 09/19 v2] bcache: update bio->bi_opf bypass/writeback REQ_
 flag hints
Date: Wed, 12 Jul 2017 17:18:21 +0800
Message-ID: <100f0052-c382-1688-0706-7c3a81e31c4e@suse.de>
References: <a4f5a7e5-97aa-4245-5f96-2df2045fb2a4@coly.li>
 <1499122284-11016-1-git-send-email-bcache@lists.ewheeler.net>
 <20170705184814.GB3234@infradead.org>
 <060c352f-894b-57e0-cdf9-6af716376cb9@coly.li>
 <20170706152438.GA18245@infradead.org>
 <e5bf5af0-4374-6d1c-2b57-3529d0e73e92@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751237AbdGLJSa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Jul 2017 05:18:30 -0400
In-Reply-To: <e5bf5af0-4374-6d1c-2b57-3529d0e73e92@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, bcache@lists.ewheeler.net, Eric Wheeler <git@linux.ewheeler.net>, Eric Wheeler <bcache@linux.ewheeler.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, axboe@kernel.dk

On 2017/7/11 上午11:48, Coly Li wrote:
> On 2017/7/6 下午11:24, Christoph Hellwig wrote:
>> On Thu, Jul 06, 2017 at 03:35:48PM +0800, Coly Li wrote:
>>> Then gfs2 breaks the above rule ?  in gfs2_metapath_ra() and
>>> gfs2_dir_readahead(), only REQ_META is used in submit_bh(). It seems an
>>> extra REQ_PRIO should be there.
>>
>> Or maybe not.  E.g. XFS absolutely avoids using REQ_PRIO for any of
>> the buffer writeback as it does not have priority.  You'll need to
>> ask gfs2 folks if they want this I/O to have priority or not.
>>
> 
> I see. Just sent a RFC patch to gfs2 development list, and wait for
> response.
> 
> Thanks for the hint.

Hi Eric,

By comments from Christoph, I think the original version is correct
enough. gfs2 is the only file system uses REQ_READAHEAD for metadata
readahead, if gfs2 developers agree to add REQ_PRIO when issue metadata
bio, we can use another patch to cache its metadata in bcache. Currently
we can just let this patch go ahead.

Thanks for your patient explaining to my question, and thanks to
Christoph to correct the concept of REQ_META and REQ_PRIO.

Please add Reviewed-by: Coly Li <colyli@suse.de> to your original
version patch.


Coly Li
