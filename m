From: Coly Li <i@coly.li>
Subject: Re: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 26 Sep 2017 15:09:25 +0800
Message-ID: <6901224d-cee2-463b-c0bf-da83ea98598c@coly.li>
References: <20170906062602.50497-1-colyli@suse.de>
 <20170906062602.50497-5-colyli@suse.de>
 <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com>
 <F6531D8286A0B34FBC858F176F70796281EEAA@LGEVEXMBHQSVC1.LGE.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <F6531D8286A0B34FBC858F176F70796281EEAA@LGEVEXMBHQSVC1.LGE.NET>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: =?UTF-8?B?67CV67OR7LKgL+yEoOyehOyXsOq1rOybkC9TVyBQbGF0Zm9ybSjsl7ApQU9U?= =?UTF-8?B?7YyAKGJ5dW5nY2h1bC5wYXJrQGxnZS5jb20p?= <byungchul.park@lge.com>, Michael Lyle <mlyle@lyle.org>, Coly Li <colyli@suse.de>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, Eric Wheeler <bcache@lists.ewheeler.net>, Kent Overstreet <kent.overstreet@gmail.com>, "kernel-team@lge.com" <kernel-team@lge.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/9/26 下午2:39, 박병철/선임연구원/SW
Platform(연)AOT팀(byungchul.park@lge.com) wrote:
>> -----Original Message-----
>> From: Michael Lyle [mailto:mlyle@lyle.org]
>> Sent: Tuesday, September 26, 2017 1:38 PM
>> To: Coly Li
>> Cc: linux-bcache@vger.kernel.org; linux-block@vger.kernel.org;
>> axboe@kernel.dk; Eric Wheeler; Byungchul Park; Kent Overstreet
>> Subject: Re: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing
>> llist API
>>
>> I believe this introduces a critical bug.
>>
>> cl->list is used to link together the llists for both things waiting,
>> and for things that are being woken.
>>
>> If a closure that is woken decides to wait again, it will corrupt the
>> llist that __closure_wake_up is using.
>>
>> The previous iteration structure gets the next element of the list
>> before waking and is therefore safe.
> 
> Do you mean we have to use llist_for_each_entry_safe() instead of non-safe version?
> Is it ok if we use it instead?

Yes, we should use llist_for_each_entry_safe(), there is a quite
implicit race here.

-- 
Coly Li
