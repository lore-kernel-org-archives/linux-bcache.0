From: Ross Anderson <rosander@dsotm.net>
Subject: Re: bcache_gc: BUG: soft lockup - CPU#4 stuck for 22s!
Date: Fri, 12 Sep 2014 12:51:15 -0500
Message-ID: <54133293.3000901@dsotm.net>
References: <54127040.7090309@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0113.b.hostedemail.com ([64.98.42.113]:53319 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751150AbaILR62 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 12 Sep 2014 13:58:28 -0400
Received: from smtprelay.b.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave05.b.hostedemail.com (Postfix) with ESMTP id 9B7292B2E6D
	for <linux-bcache@vger.kernel.org>; Fri, 12 Sep 2014 17:51:18 +0000 (UTC)
In-Reply-To: <54127040.7090309@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe <s.priebe@profihost.ag>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Greetings,

This was supposed to be corrected in the 3.17 push. I haven't seen it on 
my systems over the past few weeks of testing. Can you provide more 
details what was running when this occurred? What FS, hardware etc.

Ross Anderson

On 9/11/2014 11:02 PM, Stefan Priebe wrote:
> Hi,
>
> while trying to use bcache on 3.17-rc4 i got those messages and a load 
> of 1000.
>
> Is this a known problem?
>
> 14-09-12 02:32:22     BUG: soft lockup - CPU#4 stuck for 23s! 
> [bcache_gc:1585]
> 2014-09-12 02:31:54     INFO: rcu_sched self-detected stall on CPU { 
> 4} (t=150009 jiffies g=1762124 c=1762123 q=235323)
> 2014-09-12 02:31:42     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:31:14     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:30:46     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:30:18     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:29:50     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:29:22     BUG: soft lockup - CPU#4 stuck for 23s! 
> [bcache_gc:1585]
> 2014-09-12 02:28:54     INFO: rcu_sched self-detected stall on CPU { 
> 4} (t=105006 jiffies g=1762124 c=1762123 q=209365)
> 2014-09-12 02:28:42     BUG: soft lockup - CPU#4 stuck for 23s! 
> [bcache_gc:1585]
> 2014-09-12 02:28:14     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:27:46     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:27:18     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:26:50     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:26:22     BUG: soft lockup - CPU#4 stuck for 22s! 
> [bcache_gc:1585]
> 2014-09-12 02:25:54     INFO: rcu_sched self-detected stall on CPU { 
> 4} (t=60003 jiffies g=1762124 c=1762123 q=136221)
> 2014-09-12 02:25:42     BUG: soft lockup - CPU#4 stuck for 23s! 
> [bcache_gc:1585]
> 2014-09-12 02:25:14     BUG: soft lockup - CPU#4 stuck for 23s! 
> [bcache_gc:1585]
> 2014-09-12 02:24:46     BUG: soft lockup - CPU#4 stuck for 23s! 
> [bcache_gc:1585]
>
>
> Stefan
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
