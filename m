From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [416 PATCH 00/13] Bcache changes for 4.16
Date: Mon, 8 Jan 2018 13:42:41 -0700
Message-ID: <0692a21d-8465-9c1e-93a5-cf96dfb36cda@kernel.dk>
References: <20180108202130.31303-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35730 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756363AbeAHUmo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jan 2018 15:42:44 -0500
Received: by mail-io0-f177.google.com with SMTP id 14so16065007iou.2
        for <linux-bcache@vger.kernel.org>; Mon, 08 Jan 2018 12:42:44 -0800 (PST)
In-Reply-To: <20180108202130.31303-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 1/8/18 1:21 PM, Michael Lyle wrote:
> Jens,
> 
> Please pick up the following reviewed changes for 4.16.  There's some
> small cleanliness changes, a few minor bug fixes (some in preparation
> for larger work), and ongoing work on writeback performance:
> 
>  11 files changed, 303 insertions(+), 133 deletions(-)
> 
> Coly Li (2):
>       bcache: reduce cache_set devices iteration by devices_max_used
>       bcache: fix misleading error message in bch_count_io_errors()
> 
> Kent Overstreet (2):
>       bcache: Fix, improve efficiency of closure_sync()
>       bcache: mark closure_sync() __sched
> 
> Michael Lyle (3):
>       bcache: writeback: properly order backing device IO
>       bcache: allow quick writeback when backing idle
>       bcache: fix writeback target calc on large devices
> 
> Rui Hua (1):
>       bcache: ret IOERR when read meets metadata error
> 
> Tang Junhui (3):
>       bcache: stop writeback thread after detaching
>       bcache: segregate flash only volume write streams
>       bcache: fix wrong return value in bch_debug_init()
> 
> Vasyl Gomonovych (1):
>       bcache: Use PTR_ERR_OR_ZERO()
> 
> Zhai Zhaoxuan (1):
>       bcache: fix unmatched generic_end_io_acct() & generic_start_io_acct()

Looks good, thanks Mike. Applied for 4.16.

-- 
Jens Axboe
