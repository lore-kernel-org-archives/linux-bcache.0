From: Coly Li <i@coly.li>
Subject: Re: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 26 Sep 2017 15:46:00 +0800
Message-ID: <1433ecdd-3394-c65f-9588-4d2a20df25d5@coly.li>
References: <20170906062602.50497-1-colyli@suse.de>
 <20170906062602.50497-5-colyli@suse.de>
 <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:54804 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965798AbdIZHqK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 03:46:10 -0400
In-Reply-To: <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Eric Wheeler <bcache@lists.ewheeler.net>, Byungchul Park <byungchul.park@lge.com>, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/9/26 下午12:38, Michael Lyle wrote:
> I believe this introduces a critical bug.
> 
> cl->list is used to link together the llists for both things waiting,
> and for things that are being woken.
> 
> If a closure that is woken decides to wait again, it will corrupt the
> llist that __closure_wake_up is using.
> 
> The previous iteration structure gets the next element of the list
> before waking and is therefore safe.


Hi Michael and Byungchul,

This is my fault to suggest Byungchul to change his correct patch into
wrong one. But it's good to learn such an implicit race behind bcache
code. I just post a patch to explain how this race may happen and
corrupt the reverse list iteration. Could you please to review the fix ?

And thanks to Michael again to catch this bug.

-- 
Coly Li
