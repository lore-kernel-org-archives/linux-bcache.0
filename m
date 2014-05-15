From: Ross Anderson <rosander@dsotm.net>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Thu, 15 May 2014 12:29:53 -0500
Message-ID: <5374F991.8090802@dsotm.net>
References: <1398981150-27765-1-git-send-email-sp@daterainc.com> <CA+waHKU1Kaz4Bf=AogB_bXHLZ03tOYp2N5LL=JYH--Y3Yq4qow@mail.gmail.com> <537112A5.6040709@kieser.ca> <53747499.3070000@gmail.com> <5374E8DB.5050705@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from smtprelay0093.b.hostedemail.com ([64.98.42.93]:58854 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752759AbaEORj7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 15 May 2014 13:39:59 -0400
Received: from smtprelay.b.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave03.b.hostedemail.com (Postfix) with ESMTP id 34C251DC784
	for <linux-bcache@vger.kernel.org>; Thu, 15 May 2014 17:29:53 +0000 (UTC)
In-Reply-To: <5374E8DB.5050705@kieser.ca>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>, Francis Moreau <francis.moro@gmail.com>
Cc: kmo@daterainc.com, linux-bcache@vger.kernel.org, axboe@kernel.dk

On 5/15/2014 11:18 AM, Peter Kieser wrote:
>
> On 2014-05-15 1:02 AM, Francis Moreau wrote:
>> Eventually I would suggest to mark bcache as an experimental thing since
>> it's really not ready for production, just take a look at the bcache
>> mailing list to see why. At least people won't be disappointed when
>> they'll use bcache and see ton of koops.
>
> I'm going to second this request to mark bcache as experimental. XFS 
> performance has been stunted (almost DoS condition) since 3.10.4, 
> btrfs doesn't currently work and Kent is leaving it up to the btrfs 
> team to fix the bugs in either bcache or btrfs. Multiple 
> deadlocks/interruptible sleeps and corruption.
>
> -Peter
>
Greetings,

     First let me say I can empathize with your struggles and agree 
these bugs do need to be resolved. There's been a lot of work going into 
resolving the issues without avail. Sometimes the bugs are other teams 
issues as they are not following system that is outlined.
      I'd like to represent the other side of the coin here. I'm aware 
of numerous storage solution situations where bcache has been stable and 
in production for 18-24 months. I myself have over 20 systems in place 
with numerous file systems running without issues. There are storage 
vendors in the process of introducing into their next release. If it all 
possible, lets try to reach out to other developers and help Kent with 
getting these few issues tracked down. They are obviously tricky. Again 
it is up to others to decide.

Thanks,
Ross Anderson
