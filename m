From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/3] bcache: make bch_btree_check() to be multiple threads
Date: Thu, 20 Feb 2020 21:21:47 +0800
Message-ID: <6f0d6571-bd01-528b-649c-1365ad2a4910@suse.de>
References: <20200215082858.128025-1-colyli@suse.de>
 <20200215082858.128025-3-colyli@suse.de>
 <20200219163015.GE10644@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbgBTNV6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Feb 2020 08:21:58 -0500
In-Reply-To: <20200219163015.GE10644@infradead.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2020/2/20 12:30 上午, Christoph Hellwig wrote:
> maybe s/be multiple threads/multithreaded/ in the subject?
> 

Sure, I will do it in next version.

Thanks.

-- 

Coly Li
