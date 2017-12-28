From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Re: [for-416 PATCH 1/3] bcache: writeback: collapse contiguous IO better
Date: Wed, 27 Dec 2017 19:49:59 -0800
Message-ID: <CAJ+L6qfgQ6q0PfxsYN-FdhRVXFq_FCvuw-iAt1ik2ZHaJEzeDQ@mail.gmail.com>
References: <1514432852-3085-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1514432852-3085-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: Junhui Tang <tang.junhui@zte.com.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Wed, Dec 27, 2017 at 7:47 PM,  <tang.junhui@zte.com.cn> wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
>
> More importantly,
>> +    while (!kthread_should_stop() && next) {
>> ...
>> +            if (nk != 0 && !keys_contiguous(dc, keys[nk-1], next))
>> +                break;
>> +
>> +            size += KEY_SIZE(&next->key);
>> +            keys[nk++] = next;
>> +        } while ((next = bch_keybuf_next(&dc->writeback_keys)));
>
> if the "next" key does not satisfy the contiguous condition, does this
> key not write-back to the backend device?

I believe the current code is correct--- it is not written back *this
time* (since it is not contiguous), but will be written back the next
time through the loop (next is not changed).

Mike
