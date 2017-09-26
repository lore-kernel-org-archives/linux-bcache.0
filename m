From: Coly Li <i@coly.li>
Subject: Re: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 26 Sep 2017 15:08:50 +0800
Message-ID: <761ebe34-99c3-8865-3fc6-c4f7e6e3b29a@coly.li>
References: <20170906062602.50497-1-colyli@suse.de>
 <20170906062602.50497-5-colyli@suse.de>
 <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Eric Wheeler <bcache@lists.ewheeler.net>, Byungchul Park <byungchul.park@lge.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

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
>

Hi Mike,

Good catch! I see llist_del_all() but forget cl->list can be modified in
closure_wait(). Yes there is potential chance to mislead
llist_for_each_entry() to iterate wrong list.
llist_for_each_entry_safe() should be used here. I will send a fix to
Jens, hope to catch up 4.14 still.

Thanks!
-- 
Coly Li
