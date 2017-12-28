From: tang.junhui@zte.com.cn
Subject: Re: Re: Re: [for-416 PATCH 1/3] bcache: writeback: collapse contiguous IO better
Date: Thu, 28 Dec 2017 12:14:09 +0800
Message-ID: <1514434449-3731-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

>>
>> More importantly,
>>> +    while (!kthread_should_stop() && next) {
>>> ...
>>> +            if (nk != 0 && !keys_contiguous(dc, keys[nk-1], next))
>>> +                break;
>>> +
>>> +            size += KEY_SIZE(&next->key);
>>> +            keys[nk++] = next;
>>> +        } while ((next = bch_keybuf_next(&dc->writeback_keys)));
>>
>> if the "next" key does not satisfy the contiguous condition, does this
>> key not write-back to the backend device?
>
>I believe the current code is correct--- it is not written back *this
>time* (since it is not contiguous), but will be written back the next
>time through the loop (next is not changed).
>
Oh, yes, that's right. I read the wrong while{} loop.


Thanks,
Tang
