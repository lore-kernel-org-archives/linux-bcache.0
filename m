From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] bcache: use llist_for_each_entry_safe() in
 __closure_wake_up()
Date: Wed, 27 Sep 2017 22:27:47 +0200
Message-ID: <5986f13b-013d-5252-fc70-51dcd40e7335@kernel.dk>
References: <20170926095412.74028-1-colyli@suse.de>
 <20170926095412.74028-2-colyli@suse.de>
 <4c14e77e-577f-b7b7-d63a-b4b3a4d9e757@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:53558 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbdI0U1u (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 16:27:50 -0400
Received: by mail-wm0-f49.google.com with SMTP id r136so40843wmf.2
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2017 13:27:50 -0700 (PDT)
In-Reply-To: <4c14e77e-577f-b7b7-d63a-b4b3a4d9e757@coly.li>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 09/27/2017 09:16 PM, Coly Li wrote:
> Hi Jens,
> 
> Could you please take a look on this patch? It will be helpful if we can
> have it in 4.14, then we can fix a bug introduced in 4.14-rc1.
> 
> This patch is reported by Michael Lyle, reviewed by Byungchul Park, and
> finally verified by Michael Lyle after I posted the patch.

It looks fine to me, I'll get it queued up. BTW, it's technically
a use-after-free bug, not a race condition.

-- 
Jens Axboe
