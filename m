From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Mon, 25 Sep 2017 21:38:09 -0700
Message-ID: <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
References: <20170906062602.50497-1-colyli@suse.de> <20170906062602.50497-5-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170906062602.50497-5-colyli@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Eric Wheeler <bcache@lists.ewheeler.net>, Byungchul Park <byungchul.park@lge.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

I believe this introduces a critical bug.

cl->list is used to link together the llists for both things waiting,
and for things that are being woken.

If a closure that is woken decides to wait again, it will corrupt the
llist that __closure_wake_up is using.

The previous iteration structure gets the next element of the list
before waking and is therefore safe.

Mike
