From: Coly Li <i@coly.li>
Subject: Re: [PATCH 1/1] bcache: use llist_for_each_entry_safe() in
 __closure_wake_up()
Date: Thu, 28 Sep 2017 08:46:04 +0800
Message-ID: <4d5dbd25-e1f3-9dc1-1124-26ba9bd7d8c1@coly.li>
References: <20170926095412.74028-1-colyli@suse.de>
 <20170926095412.74028-2-colyli@suse.de>
 <4c14e77e-577f-b7b7-d63a-b4b3a4d9e757@coly.li>
 <5986f13b-013d-5252-fc70-51dcd40e7335@kernel.dk>
 <CAJ+L6qeQu0A17gGb1RVu8g_JvzcvJ2uSDj+9vC-hsUEFqM-fAw@mail.gmail.com>
 <90e74638-c396-a04f-da5c-72ae387f677d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <90e74638-c396-a04f-da5c-72ae387f677d@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2017/9/28 上午4:52, Jens Axboe wrote:
> On 09/27/2017 10:48 PM, Michael Lyle wrote:
>> Jens--
>>
>> I think it's a race condition-- the individual closures remain valid.
>> It's just that the list element has different meanings-- it's either a
>> list actively being used to wake, or a linkage on one of several lists
>> that is being used to await wake.  If a closure goes back to wait very
>> quickly after being woken, it can end up connecting its new wait-list
>> with the being-woken list.
> 
> Reading it a second time, looks like you are right. OK, then let's just
> queue it up as-is, I'll add the Fixes line this time.
> 
Hi Jens,

Copied, next time for similar situation, Fixes will be there.

Thanks for doing this.

-- 
Coly Li
