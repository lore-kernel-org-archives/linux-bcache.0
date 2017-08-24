From: "Jorg Bornschein" <jb@capsec.org>
Subject: Re: Can't register existing backing devices anymore
Date: Thu, 24 Aug 2017 21:02:07 +0000
Message-ID: <57184e735953122aedea2ba28d38942c@313bd276ddca>
References: <alpine.LRH.2.11.1708242036250.13126@mail.ewheeler.net>
 <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02>
 <5eb849fa-8f0b-776a-b635-e3f5af122d75@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:37999 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753835AbdHXVCC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Aug 2017 17:02:02 -0400
In-Reply-To: <alpine.LRH.2.11.1708242036250.13126@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org

August 24, 2017 9:37 PM, "Eric Wheeler" <bcache@lists.ewheeler.net> wrote:

>> A fast fix can be:
>> @@ -404,7 +404,8 @@ long bch_bucket_alloc(struct cache *ca, unsigned
>> reserve, bool wait)
>> 
>> finish_wait(&ca->set->bucket_wait, &w);
>> out:
>> - wake_up_process(ca->alloc_thread);
>> + if (ca->alloc_thread)
>> + wake_up_process(ca->alloc_thread);
>> 
>> trace_bcache_alloc(ca, reserve);
>> 
>> But for a proper fix, we should not open user space access interface
>> before necessary resources are ready.
> 
> Great catch!
> 
> Jorg, does this fix it?

Hi!

I hopefully find some time over the weekend and try it -- it's a bit painful because the machine is
headless and I have to move a monitor around to see the results...


   j
