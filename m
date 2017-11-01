From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: correct journal bucket reading
Date: Wed, 1 Nov 2017 15:54:46 -0700
Message-ID: <CAJ+L6qcu8s2+TLT+Rsk1qYqWkz0dm5UcL-AWw0M25cjSzx4SGg@mail.gmail.com>
References: <1509520213-10301-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1509520213-10301-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-block-owner@vger.kernel.org
To: Junhui Tang <tang.junhui@zte.com.cn>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Tang--

I think the scenario you listed can't happen, because the first bucket
we try in the hash-search is 0.  If the circular buffer has wrapped,
that will be detected immediately and we'll leave the loop with l=0.
We should add a comment that we need to try the first index first for
correctness so that we don't inadvertently change this behavior.

One thing took me a long time to convince myself was safe with the
original code:  If we have 'YYNYYYYYYY', we'll start at l=0, and then
we'll search across the N;  I think this is OK because sequence
numbers will cause us to do the right thing.

Mike

On Wed, Nov 1, 2017 at 12:10 AM,  <tang.junhui@zte.com.cn> wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
>
> Hello Mike, Coly
>
> I found this issue by code reading.
> It looks serious.
> May I am wrong.
> Please have a review.
>
> Thanks,
> Tang
>
>
