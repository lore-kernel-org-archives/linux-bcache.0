From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Re: [PATCH] update bucket_in_use in real time
Date: Tue, 24 Oct 2017 18:47:12 -0700
Message-ID: <CAJ+L6qdZx0g__+Jdey6AC9P2mQVvczXfVWP8pFVWYHL_0N_qhw@mail.gmail.com>
References: <1508894488-3624-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1508894488-3624-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: Junhui Tang <tang.junhui@zte.com.cn>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Oct 24, 2017 at 6:21 PM,  <tang.junhui@zte.com.cn> wrote:
>>> static void bch_btree_gc_finish(struct cache_set *c)
>> available should be removed and this function should return 0.
> I have changed this function to a void type, so nothing need return.

Sorry, I misread that. :)

>>> +             stats.in_use            = (c->nbuckets - c->avail_nbuckets) * 100 / c->nbuckets;
>>
>> This should instead call bch_update_bucket_in_use to avoid code duplication.
> OK, I will modify it and resend a v2 patch later.

OK, that's my only complaint.  Will be glad to add v2 to my staging tree.

>
>> Overall I think this is a good piece of progress.
> Thanks for your review and comments again.
>
> Tang Junhui

Thanks!

Mike
