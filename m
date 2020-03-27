From: Jens Axboe <axboe@kernel.dk>
Subject: Re: simplify queue allocation
Date: Fri, 27 Mar 2020 10:18:51 -0600
Message-ID: <21bb5f8e-d395-c8fe-bf08-00e4f37cbb69@kernel.dk>
References: <20200327083012.1618778-1-hch@lst.de>
 <b1123d19-0c4a-5d3d-d0d4-0a412830c2b0@kernel.dk>
 <20200327161754.GA19480@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl1-f179.google.com ([209.85.214.179]:40038 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0QSy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 12:18:54 -0400
Received: by mail-pl1-f179.google.com with SMTP id h11so3618044plk.7
        for <linux-bcache@vger.kernel.org>; Fri, 27 Mar 2020 09:18:54 -0700 (PDT)
In-Reply-To: <20200327161754.GA19480@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 3/27/20 10:17 AM, Christoph Hellwig wrote:
> On Fri, Mar 27, 2020 at 09:53:16AM -0600, Jens Axboe wrote:
>> On 3/27/20 2:30 AM, Christoph Hellwig wrote:
>>> Hi Jens,
>>>
>>> this series ensures all allocated queues have a valid ->make_request_fn
>>> and also nicely consolidates the code for allocating queues.
>>
>> This seems fine to me, but might be a good idea to shuffle 4/5 as the
>> last one, and do that one inside the merge window to avoid any potential
>> silly merge conflicts.
> 
> they should be trivial to reorder if you want to skip patch 4 for now.
> But looking at current linux-next there isn't any conflict yet,
> and I don't expect one as most block drivers go through the block
> tree anyway.

Yeah I guess so, and any potential conflict would be trivial. I'll apply
it and hope for the best.

-- 
Jens Axboe
