From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] bcache: fix cache_set_flush() NULL pointer dereference on
 OOM
Date: Tue, 8 Mar 2016 09:20:22 -0700
Message-ID: <56DEFBC6.5040905@kernel.dk>
References: <alpine.LRH.2.11.1603072326410.11530@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:32901 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbcCHQUZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 8 Mar 2016 11:20:25 -0500
Received: by mail-io0-f174.google.com with SMTP id n190so32167769iof.0
        for <linux-bcache@vger.kernel.org>; Tue, 08 Mar 2016 08:20:25 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1603072326410.11530@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org, kent.overstreet@gmail.com

On 03/07/2016 04:36 PM, Eric Wheeler wrote:
> Hi Jens,
>
> Here is another OOM fix for bcache.  Please pull:
>
>    git pull https://bitbucket.org/ewheelerinc/linux.git v4.5-rc7-bcache-fixes
>
>   # git diff --stat v4.5-rc7
>   drivers/md/bcache/super.c | 3 +++
>   1 file changed, 3 insertions(+)

I pulled this and the previous, but for 4.6. They are all marked stable, 
so that should be fine.

Note that your 2nd patch in the -rc6 branch, this one:

bcache: cleaned up error handling around register_cache()

had a 4 cases of trailing white space. Please ensure that future patches 
are cleaned up, I fixed that one up.

-- 
Jens Axboe
