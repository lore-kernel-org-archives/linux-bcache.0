From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3 00/13] bcache: device failure handling improvement
Date: Fri, 26 Jan 2018 12:56:11 +0800
Message-ID: <f2034e77-d351-cb50-d8e0-853ddc48db59@suse.de>
References: <20180114144236.28213-1-colyli@suse.de>
 <87po5ykiaw.fsf@esperi.org.uk> <1664591662.20180125063516@pvgoran.name>
 <874ln9hilm.fsf@esperi.org.uk> <355593907.20180126071541@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751354AbeAZE4Y (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Jan 2018 23:56:24 -0500
In-Reply-To: <355593907.20180126071541@pvgoran.name>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pavel Goran <via-bcache@pvgoran.name>, Nix <nix@esperi.org.uk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 26/01/2018 12:15 PM, Pavel Goran wrote:
> Hello Nix,
> 
> Thursday, January 25, 2018, 9:57:25 PM, you wrote:
> 
>> On 25 Jan 2018, Pavel Goran told this:
> 
>>> Hello Nix,
>>>
>>> Thursday, January 25, 2018, 1:23:19 AM, you wrote:
>>>
>>>> This feels wrong to me. If a cache device is writethrough, the cache is
>>>> a pure optimization: having such a device fail should not lead to I/O
>>>> failures of any sort, but should only flip the cache device to 'none' so
>>>> that writes to the backing store simply don't get cached any more.
>>>
>>>> Anything else leads to a reliability reduction, since in the end cache
>>>> devices *will* fail.
>>>
>>> It's one of those choices: "if something can't work as intended, should it be
>>> allowed to work at all?"
> 
>> Given that the only difference between a bcache with a writearound cache
>> and a bcache with no cache is performance... is it really ever going to
>> beneficial to users to have a working system suddenly start throwing
>> write errors and probably become instantly nonfunctional because a
>> cache device has worn out, when it is perfectly possible to just
>> automatically dissociate the failed cache and slow down a bit?
> 
>> I would suggest that no user would ever want the former behaviour, since
>> it amounts to behaviour that worsens a slight slowdown into a complete
>> cessation of service (in effect, an infinite "slowdown"). Is it better
>> to have a system working correctly but more slowly than before, or one
>> that without warning stops working entirely? Is this really even in
>> question?!
> 
> Well, there is the "Fail-Fast" principle [1] and all that. For a home user
> (which is my case, for example), this approach doesn't make much sense.
> However, large-scale users, like cloud providers, can have a different point
> of view.
> 
> It's just a speculation on my part, but consider a bunch of bcache devices
> that serve as parts of a RAID6 array. It may be desirable to deactivate the
> bcache device that lost its caching capabilities, so that (1) the array would
> not slow down, (2) the array would report its degraded state to
> administrators.
> 
> Anyway, probably the author of this patch could explain it better. Maybe I
> completely misunderstand the intention.

Hi Pavel and Nix,

These days I am working on back porting and response emails a little bit
slowly.

Most of the intention is from our customers, and partners from data
base, cloud service, Ceph storage and so on. So yes, it is mostly
enterprise use cases focused.

I take Nix's suggestion in serious, and I will try to see whether it is
possible to add a default-disabled option. When it is enabled, cache set
retiring won't stop bcache devices if cache set is clean.

In order to make the failure handling simple and fast, I will not
distinct each bcache device whether it has dirty data on cache set. Once
the cache set is dirty, all attached bcache devices will be stopped.

It seems when this option is enabled by users, it should work for
writeback and writethrough, and no side effect to writearound and non.

Nix, how do you think of the above idea ?

Thanks for all your constructive discussion :-)

Coly Li
