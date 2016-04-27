From: ching lu <lsching17@gmail.com>
Subject: Re: writeback mode behaviour on proper shut down
Date: Wed, 27 Apr 2016 09:45:22 +0800
Message-ID: <CACHiF8C0A+Gmr5xYCRhB+dm0zLu3iyYysuQXNYAVLOmDUix5hg@mail.gmail.com>
References: <CACHiF8AEZ0Ppoa9mzou76o8j5UC-gXyjt25EDvnqq9S-Kk0B8Q@mail.gmail.com>
	<alpine.LRH.2.11.1604261953230.21555@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:36653 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbcD0BpX (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 26 Apr 2016 21:45:23 -0400
Received: by mail-ob0-f196.google.com with SMTP id ds1so2075924obc.3
        for <linux-bcache@vger.kernel.org>; Tue, 26 Apr 2016 18:45:23 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1604261953230.21555@mx.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

is there any command for forcing flushing cache or invalidate cache?

On Wed, Apr 27, 2016 at 3:57 AM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> On Tue, 26 Apr 2016, ching lu wrote:
>
>> Hi all,
>>
>> if i have 1 SSD caching 1 HDD using bcache, the cache mode is writeback
>>
>> if the PC shutdown/unmount normally, will all dirty data in the cache
>> be flushed to backing device before poweroff?
>
> No, it will remain in the cache.
>
>> i am afraid that SSD lose data if left without power for a long time.
>> e.g. hoilday.
>
> Wouldn't your data be retained if you used the SSD alone?  SSDs should be
> stable in a powered off state unless it is a bad device.
>
> There exist RAM-based disks that may be volatile, but that is unlikely to
> be your situation.
>
> --
> Eric Wheeler
>
>>
>> Thanks in advance,
>> C
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
