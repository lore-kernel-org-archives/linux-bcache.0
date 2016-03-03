From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] bcache fixes for v4.5-rc6
Date: Wed, 2 Mar 2016 20:26:43 -0700
Message-ID: <56D7AEF3.3040508@kernel.dk>
References: <alpine.LRH.2.11.1602292216450.3635@mail.ewheeler.net>
 <56D5B8E3.9050000@kernel.dk>
 <alpine.LRH.2.11.1603021947130.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35368 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbcCCD0s (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 2 Mar 2016 22:26:48 -0500
Received: by mail-pf0-f181.google.com with SMTP id w128so6368453pfb.2
        for <linux-bcache@vger.kernel.org>; Wed, 02 Mar 2016 19:26:47 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1603021947130.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Marc MERLIN <marc@merlins.org>, linux-bcache@vger.kernel.org, Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>

On 03/02/2016 07:09 PM, Eric Wheeler wrote:
> On Tue, 1 Mar 2016, Jens Axboe wrote:
>
>> On 02/29/2016 06:08 PM, Eric Wheeler wrote:
>>> Hi Jens,
>>>
>>> Can we still get these in for 4.5?  One is a race, the other is just error
>>> handling.
>>>
>>> Please pull:
>>>     git pull https://bitbucket.org/ewheelerinc/linux.git
>>>     v4.5-rc6-bcache-fixes
>>>
>>> bcache: fix race of writeback thread starting before complete initialization
>>> bcache: cleaned up error handling around register_cache()
>>
>> They look simple enough, though I generally don't like collapsing things like
>> this:
>>
>> if ((ret = cache_alloc(sb, ca)) != 0)
>>
>> it's easy to screw up, doing
>>
>> ret = cache_alloc(sb, ca);
>> if (ret != 0)
>>      ...
>
> Done.  Rebased, fixed, and push --force'ed.

Cool, I will pull it in.

> BTW, Is there a better (preferred) way vs. push --force?  Some say push
> --force can break things.

If you rebased, there's really no way around that, other than spinning a 
new branch with the new changes. The rebase is what breaks things for 
people, the --force is just a side effect since you have to do that to 
push it to the same branch again. It's only really a concern if people 
are continually pulling from you and developing on top of your branch, 
for something like this, it's not a huge problem.

-- 
Jens Axboe
