From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: [PATCH v3 00/13] bcache: device failure handling improvement
Date: Fri, 26 Jan 2018 07:15:41 +0300
Message-ID: <355593907.20180126071541@pvgoran.name>
References: <20180114144236.28213-1-colyli@suse.de> <87po5ykiaw.fsf@esperi.org.uk> <1664591662.20180125063516@pvgoran.name> <874ln9hilm.fsf@esperi.org.uk>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:33743 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbeAZEPq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Jan 2018 23:15:46 -0500
In-Reply-To: <874ln9hilm.fsf@esperi.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hello Nix,

Thursday, January 25, 2018, 9:57:25 PM, you wrote:

> On 25 Jan 2018, Pavel Goran told this:

>> Hello Nix,
>>
>> Thursday, January 25, 2018, 1:23:19 AM, you wrote:
>>
>>> This feels wrong to me. If a cache device is writethrough, the cache is
>>> a pure optimization: having such a device fail should not lead to I/O
>>> failures of any sort, but should only flip the cache device to 'none' so
>>> that writes to the backing store simply don't get cached any more.
>>
>>> Anything else leads to a reliability reduction, since in the end cache
>>> devices *will* fail.
>>
>> It's one of those choices: "if something can't work as intended, should it be
>> allowed to work at all?"

> Given that the only difference between a bcache with a writearound cache
> and a bcache with no cache is performance... is it really ever going to
> beneficial to users to have a working system suddenly start throwing
> write errors and probably become instantly nonfunctional because a
> cache device has worn out, when it is perfectly possible to just
> automatically dissociate the failed cache and slow down a bit?

> I would suggest that no user would ever want the former behaviour, since
> it amounts to behaviour that worsens a slight slowdown into a complete
> cessation of service (in effect, an infinite "slowdown"). Is it better
> to have a system working correctly but more slowly than before, or one
> that without warning stops working entirely? Is this really even in
> question?!

Well, there is the "Fail-Fast" principle [1] and all that. For a home user
(which is my case, for example), this approach doesn't make much sense.
However, large-scale users, like cloud providers, can have a different point
of view.

It's just a speculation on my part, but consider a bunch of bcache devices
that serve as parts of a RAID6 array. It may be desirable to deactivate the
bcache device that lost its caching capabilities, so that (1) the array would
not slow down, (2) the array would report its degraded state to
administrators.

Anyway, probably the author of this patch could explain it better. Maybe I
completely misunderstand the intention.

Pavel Goran

[1] https://en.wikipedia.org/wiki/Fail-fast
