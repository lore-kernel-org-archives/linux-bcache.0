From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] bcache: fix cache_set_flush() NULL pointer dereference on
 OOM
Date: Wed, 9 Mar 2016 09:23:52 -0700
Message-ID: <56E04E18.1060805@kernel.dk>
References: <alpine.LRH.2.11.1603072326410.11530@mail.ewheeler.net>
 <56DEFBC6.5040905@kernel.dk>
 <alpine.LRH.2.11.1603090330430.15354@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34764 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047AbcCIQXz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Mar 2016 11:23:55 -0500
Received: by mail-io0-f180.google.com with SMTP id m184so72083555iof.1
        for <linux-bcache@vger.kernel.org>; Wed, 09 Mar 2016 08:23:55 -0800 (PST)
In-Reply-To: <alpine.LRH.2.11.1603090330430.15354@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On 03/08/2016 08:36 PM, Eric Wheeler wrote:
> On Tue, 8 Mar 2016, Jens Axboe wrote:
>
>> On 03/07/2016 04:36 PM, Eric Wheeler wrote:
>>> Hi Jens,
>>>
>>> Here is another OOM fix for bcache.  Please pull:
>>>
>>>     git pull https://bitbucket.org/ewheelerinc/linux.git
>>>     v4.5-rc7-bcache-fixes
>>>
>>>    # git diff --stat v4.5-rc7
>>>    drivers/md/bcache/super.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>
>> I pulled this and the previous, but for 4.6. They are all marked stable, so
>> that should be fine.
>>
>> Note that your 2nd patch in the -rc6 branch, this one:
>>
>> bcache: cleaned up error handling around register_cache()
>>
>> had a 4 cases of trailing white space. Please ensure that future patches are
>> cleaned up, I fixed that one up.
>
> Interesting, do you mean whitespace at the end of a line with code or
> empty lines containing whitespace or both?  Something matched by [ ]+$  ?

Both. You had both trailing white space at the end of a line, and a 
space at the start of a new line.

> Is it acceptable to have empty likes whith whitespace leading up to the
> indent level?  eg:
> 	if (1) {
> 		foo
> 		<<whitespace-to-here but line is blank
> 		bar
> 	}

Nope

-- 
Jens Axboe
