From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: bch_writeback_thread() is not freezable
Date: Tue, 24 May 2016 08:18:45 -0600
Message-ID: <574462C5.40307@kernel.dk>
References: <alpine.LNX.2.00.1604191421130.27368@cbobk.fhfr.pm>
 <alpine.LNX.2.00.1605020916001.27942@cbobk.fhfr.pm>
 <alpine.LNX.2.00.1605181727480.31937@cbobk.fhfr.pm>
 <alpine.LNX.2.00.1605240103090.31937@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35818 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEXOSs (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 24 May 2016 10:18:48 -0400
Received: by mail-ig0-f177.google.com with SMTP id bi2so53120854igb.0
        for <linux-bcache@vger.kernel.org>; Tue, 24 May 2016 07:18:47 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.00.1605240103090.31937@cbobk.fhfr.pm>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Wheeler <bcache@lists.ewheeler.net>

On 05/23/2016 05:05 PM, Jiri Kosina wrote:
> On Wed, 18 May 2016, Jiri Kosina wrote:
>
>>>> bch_writeback_thread() is calling try_to_freeze(), but that's just an
>>>> expensive no-op given the fact that the thread is not marked freezable.
>>>>
>>>> I/O helper kthreads, exactly such as the bcache writeback thread, actually
>>>> shouldn't be freezable, because they are potentially necessary for
>>>> finalizing the image write-out.
>>>>
>>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>>>
>>> Let's send a friendly ping on these three patches after two weeks...
>>
>> After a month, I think, it's time for another ping.
>
> [ adding Jens to CC ]
>
> Ok, I call it officially ridiculous now. I guess I'll be resending through
> akpm.

You can just send it to me, I've funneled bcache stable fixes before.

> Is it a time to claim (by MAINTAINERS entry) the in-tree bcache orphaned?

I think so.

-- 
Jens Axboe
