From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 08/10] bcache: fix misleading error message in
 bch_count_io_errors()
Date: Mon, 8 Jan 2018 08:27:54 +0100
Message-ID: <9216d1c3-7f52-b90c-0be5-ed03e3cb13f3@suse.de>
References: <20180103140325.63175-1-colyli@suse.de>
 <20180103140325.63175-9-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755278AbeAHH17 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 02:27:59 -0500
In-Reply-To: <20180103140325.63175-9-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, mlyle@lyle.org, tang.junhui@zte.com.cn

On 01/03/2018 03:03 PM, Coly Li wrote:
> Bcache only does recoverable I/O for read operations by calling
> cached_dev_read_error(). For write opertions there is no I/O recovery for
> failed requests.
> 
> But in bch_count_io_errors() no matter read or write I/Os, before errors
> counter reaches io error limit, pr_err() always prints "IO error on %,
> recoverying". For write requests this information is misleading, because
> there is no I/O recovery at all.
> 
> This patch adds a parameter 'is_read' to bch_count_io_errors(), and only
> prints "recovering" by pr_err() when the bio direction is READ.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/bcache.h    |  2 +-
>  drivers/md/bcache/io.c        | 13 +++++++++----
>  drivers/md/bcache/super.c     |  4 +++-
>  drivers/md/bcache/writeback.c |  4 +++-
>  4 files changed, 16 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
