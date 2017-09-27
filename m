From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] bcache: use llist_for_each_entry_safe() in
 __closure_wake_up()
Date: Wed, 27 Sep 2017 22:52:27 +0200
Message-ID: <90e74638-c396-a04f-da5c-72ae387f677d@kernel.dk>
References: <20170926095412.74028-1-colyli@suse.de>
 <20170926095412.74028-2-colyli@suse.de>
 <4c14e77e-577f-b7b7-d63a-b4b3a4d9e757@coly.li>
 <5986f13b-013d-5252-fc70-51dcd40e7335@kernel.dk>
 <CAJ+L6qeQu0A17gGb1RVu8g_JvzcvJ2uSDj+9vC-hsUEFqM-fAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:48906 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751708AbdI0Uwa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2017 16:52:30 -0400
Received: by mail-wm0-f41.google.com with SMTP id m127so22597340wmm.3
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2017 13:52:30 -0700 (PDT)
In-Reply-To: <CAJ+L6qeQu0A17gGb1RVu8g_JvzcvJ2uSDj+9vC-hsUEFqM-fAw@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 09/27/2017 10:48 PM, Michael Lyle wrote:
> Jens--
> 
> I think it's a race condition-- the individual closures remain valid.
> It's just that the list element has different meanings-- it's either a
> list actively being used to wake, or a linkage on one of several lists
> that is being used to await wake.  If a closure goes back to wait very
> quickly after being woken, it can end up connecting its new wait-list
> with the being-woken list.

Reading it a second time, looks like you are right. OK, then let's just
queue it up as-is, I'll add the Fixes line this time.

-- 
Jens Axboe
