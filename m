From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bcache request for pull
Date: Fri, 13 Oct 2017 14:56:13 -0600
Message-ID: <c5dbbc89-6190-302d-d302-a1fb40e11592@kernel.dk>
References: <5ddf80d7-d887-4a64-53bb-de9074757333@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:43424 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdJMU4S (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 16:56:18 -0400
Received: by mail-pg0-f42.google.com with SMTP id s75so1254621pgs.0
        for <linux-bcache@vger.kernel.org>; Fri, 13 Oct 2017 13:56:18 -0700 (PDT)
In-Reply-To: <5ddf80d7-d887-4a64-53bb-de9074757333@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-next@vger.kernel.org
Cc: linux-bcache@vger.kernel.org

On 10/13/2017 02:54 PM, Michael Lyle wrote:
> Hi--
> 
> I'm stepping up as new maintainer of bcache and have put together a git
> repository of patches targeting the next merge window.  Can it please be
> added to the set of repositories that linux-next pulls from?
> 
> it's https://github.com/mlyle/linux.git bcache-for-next

First of all, you need to send the patches out for review. When they are
properly reviewed, they can be added to the block tree for inclusion
in the next merge window. Once they are added there, they will show
up in linux-next automatically.

-- 
Jens Axboe
