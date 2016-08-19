From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] v4.8-rc2 bcache fixes
Date: Fri, 19 Aug 2016 14:03:47 -0600
Message-ID: <acd7cf13-fcf8-188c-0c09-e07457d76392@kernel.dk>
References: <alpine.LRH.2.11.1608182036520.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37550 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755641AbcHSUKP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 19 Aug 2016 16:10:15 -0400
Received: by mail-it0-f49.google.com with SMTP id f6so34487497ith.0
        for <linux-bcache@vger.kernel.org>; Fri, 19 Aug 2016 13:10:14 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1608182036520.10662@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org



On 08/19/2016 01:55 PM, Eric Wheeler wrote:
> Hello Jens,
>
> Please pull this bcache branch based on v4.8-rc2.  These fix one deadlock,
> one use blkdev_put() use counter, and one dmesg output with a better
> pr_err() description.
>
> git pull https://bitbucket.org/ewheelerinc/linux.git v4.8-rc2-bcache-fixes
>
>  drivers/md/bcache/super.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> 9070609 bcache: pr_err: more meaningful error message when nr_stripes is invalid
> acc9cf8 bcache: RESERVE_PRIO is too small by one when prio_buckets() is a power of two.
> d9dc170 bcache: register_bcache(): call blkdev_put() when cache_alloc() fails

Pulled, thanks.

-- 
Jens Axboe
