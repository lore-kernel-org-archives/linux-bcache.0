From: Jens Axboe <axboe@kernel.dk>
Subject: Re: simplify queue allocation
Date: Fri, 27 Mar 2020 09:53:16 -0600
Message-ID: <b1123d19-0c4a-5d3d-d0d4-0a412830c2b0@kernel.dk>
References: <20200327083012.1618778-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf1-f182.google.com ([209.85.210.182]:47082 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgC0PxU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 11:53:20 -0400
Received: by mail-pf1-f182.google.com with SMTP id q3so4669917pff.13
        for <linux-bcache@vger.kernel.org>; Fri, 27 Mar 2020 08:53:19 -0700 (PDT)
In-Reply-To: <20200327083012.1618778-1-hch@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 3/27/20 2:30 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series ensures all allocated queues have a valid ->make_request_fn
> and also nicely consolidates the code for allocating queues.

This seems fine to me, but might be a good idea to shuffle 4/5 as the
last one, and do that one inside the merge window to avoid any potential
silly merge conflicts.

-- 
Jens Axboe
