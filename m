From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] bcache fixes for v4.5-rc6
Date: Tue, 1 Mar 2016 08:44:35 -0700
Message-ID: <56D5B8E3.9050000@kernel.dk>
References: <alpine.LRH.2.11.1602292216450.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34887 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbcCAPom (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 1 Mar 2016 10:44:42 -0500
Received: by mail-ob0-f171.google.com with SMTP id xx9so56676295obc.2
        for <linux-bcache@vger.kernel.org>; Tue, 01 Mar 2016 07:44:42 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1602292216450.3635@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Marc MERLIN <marc@merlins.org>, linux-bcache@vger.kernel.org, Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>

On 02/29/2016 06:08 PM, Eric Wheeler wrote:
> Hi Jens,
>
> Can we still get these in for 4.5?  One is a race, the other is just error
> handling.
>
> Please pull:
>    git pull https://bitbucket.org/ewheelerinc/linux.git v4.5-rc6-bcache-fixes
>
> bcache: fix race of writeback thread starting before complete initialization
> bcache: cleaned up error handling around register_cache()

They look simple enough, though I generally don't like collapsing things 
like this:

if ((ret = cache_alloc(sb, ca)) != 0)

it's easy to screw up, doing

ret = cache_alloc(sb, ca);
if (ret != 0)
     ...

is a lot more readable and harder to screw up. Can we get that cleaned 
up? We can still make 4.5, I've got a bunch pending that's going out 
today, and these two would have missed the boat for today anyway. But 
that doesn't mean we can't get them out later this week.

-- 
Jens Axboe
