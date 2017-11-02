From: tang.junhui@zte.com.cn
Subject: Re: Re: [PATCH] bcache: correct journal bucket reading
Date: Thu, 2 Nov 2017 09:43:07 +0800
Message-ID: <1509586987-24765-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:37890 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933083AbdKBBnR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Nov 2017 21:43:17 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Mike

> I think the scenario you listed can't happen, because the first bucket
> we try in the hash-search is 0.  If the circular buffer has wrapped,
> that will be detected immediately and we'll leave the loop with l=0.
> We should add a comment that we need to try the first index first for
> correctness so that we don't inadvertently change this behavior.
> 
Yes, I read the code again, it's true that hash-search begin with the first
bucket, so it's OK when circular buffer has wrapped, but another scenario:
NNNYYYY, I think the last bucket would be lost, since it would get the 7th bucket
as an invalid bucket (due to return value of 
find_next_bit(bitmap, ca->sb.njournal_buckets, l + 1)), and would read journal 
start with the 6th bucket in reverse order, how do you think about?

> One thing took me a long time to convince myself was safe with the
> original code:  If we have 'YYNYYYYYYY', we'll start at l=0, and then
> we'll search across the N;  I think this is OK because sequence
> numbers will cause us to do the right thing.

As I see, this scenario is OK, because in the step 2, it will try to get the third
bucket, and then read journal form the second bucket, so no invalid bucket reading 
across would happen, the reason is in step 2, these buckets after the third bucket 
can not satisfy the condition:
if (seq != list_entry(list->prev, struct journal_replay,list)->j.seq)
so it would get the third bucket as an invalid bucket, and the second bucket as the
latest valid bucket.

Thanks,
Tang
