From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/3] bcache: move macro btree() and btree_root() into
 btree.h
Date: Thu, 20 Feb 2020 21:21:29 +0800
Message-ID: <356c8b1c-d748-ce8d-ba4b-e498ce46fe03@suse.de>
References: <20200215082858.128025-1-colyli@suse.de>
 <20200215082858.128025-2-colyli@suse.de>
 <20200219162945.GD10644@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgBTNVl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Feb 2020 08:21:41 -0500
In-Reply-To: <20200219162945.GD10644@infradead.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2020/2/20 12:29 上午, Christoph Hellwig wrote:
> On Sat, Feb 15, 2020 at 04:28:56PM +0800, Coly Li wrote:
>> In order to accelerate bcache registration speed, the macro btree()
>> and btree_root() will be referenced out of btree.c. This patch moves
>> them from btree.c into btree.h with other relative function declaration
>> in btree.h, for the following changes.
> 
> Can you give them a bcache_ prefix?  That names are awfully generic
> and bound to clash sooner or later.
> 

Sure I will do it in next version.

Thanks.

-- 

Coly Li
