From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] bcache: use llist_for_each_entry_safe() in
 __closure_wake_up()
Date: Wed, 27 Sep 2017 22:29:06 +0200
Message-ID: <abf60c6e-f735-739d-7341-280659760f61@kernel.dk>
References: <20170926095412.74028-1-colyli@suse.de>
 <20170926095412.74028-2-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170926095412.74028-2-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 09/26/2017 11:54 AM, Coly Li wrote:
> Commit 09b3efec ("bcache: Don't reinvent the wheel but use existing llist
> API") replaces the following while loop by llist_for_each_entry(),

If it's fixing a specific commit, please add a proper

Fixes: sha ("title")

line to your patch. That way automated scripts can pick it up, if they
backport the problematic patch.

Also, as mentioned in the other email, this is technically a
use-after-free problem, not a race.

Can you resend with commit message fixed up?

-- 
Jens Axboe
