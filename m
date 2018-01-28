From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: [PATCH v4 13/13] bcache: add stop_when_cache_set_failed to struct cached_dev
Date: Sun, 28 Jan 2018 08:55:51 +0300
Message-ID: <1693067263.20180128085551@pvgoran.name>
References: <20180127142406.89741-1-colyli@suse.de> <20180127142406.89741-14-colyli@suse.de> <772947374.20180128063333@pvgoran.name> <167389b2-3cd1-26e0-a75b-6c4b382296ae@suse.de>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:58479 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbeA1Fz4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 28 Jan 2018 00:55:56 -0500
In-Reply-To: <167389b2-3cd1-26e0-a75b-6c4b382296ae@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Nix <nix@esperi.org.uk>, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>

Hello Coly,

Sunday, January 28, 2018, 7:32:09 AM, you wrote:

>>> Current bcache failure handling code will stop all attached bcache devices
>>> when the cache set is broken or disconnected. This is desired behavior for
>>> most of enterprise or cloud use cases, but maybe not for low end
>>> configuration. Nix <nix@esperi.org.uk> points out, users may still want to
>>> access the bcache device after cache device failed, for example on laptops.
>> 
>> In the current state, this functionality is rather user-unfriendly.
>> 
>> 1. The new "stop_when_cache_set_failed" option doesn't seem to be persistent.
>> (At least, I did not see any explicit mechanism of saving/restoring it.) That
>> is, users will have to set it on each system startup.
>> 
>> 2. If the new option is set to zero, it will (supposedly) lead to data
>> corruption/loss when cache set of a "dirty" bcache device is detached. The
>> option that an average home user may want to switch shouldn't be a way to
>> shoot oneself in the foot!
>> > As a remedy, the option could be changed to have the states "always" and
>> "auto" instead of "1" and "0", so that "auto" would still stop the bcache
>> device if it (or the entire cache set) is "dirty". (Alternatively, it could be
>> renamed to "force_stop_when_cache_set_failed" or
>> "always_stop_when_cache_set_failed" with values "1" and "0", if string values
>> are undesirable.)
>> 
>> Also, the printed warning is somewhat misleading: it says "To disable this
>> warning message, please set /sys/block/%s/bcache/stop_when_cache_set_failed to
>> 1", whereas the suggested change would lead to behaviour change rather that to
>> just disabling the warning.
>> 
>> 3. If (2) is implemented, the default value for the option could be changed to
>> "auto". (The rationale is that enterprise users who want it enabled are better
>> prepared to tune their device settings on startup.) However, this is only
>> important if (1) is not implemented.
>> 

> Hi Pavel,

> I don't like "auto" since its behavior is unpredictable, sometimes whole
> things are gone, sometimes bcache device exists but slower, for large
> scale deployed environment, it is confused and misleading.

In fact, during normal operations, this mode can be made rather predictable:
the device is stopped if it's "writeback", the device isn't stopped if it's
"writearound" or "writethrough". The only time it's unpredictable is when the
device is being transitioned from "writeback" to other mode.

However, I can see how this adds a certain informational inconsistency to the
picture: an administrator won't be able to say "everything is good" just
because all bcache devices work; he'll have to be aware that non-writeback
devices get special handling.

> After thinking for a while, I feel the "auto"/"always" options can make
> both enterprise and home users get an agreement. I am not able to find
> other better solution so far, thank you for the hint, brilliant!

> Personally I intend to set "always" as the default option, because I
> maintain bcache for enterprise workloads. The persistent option problem
> pointed by you does make sense, I will think how to solve it later
> (probably from user space tools).

Providing persistency via user-space tools looks like a bad idea. User-space
tools tend to lag behind kernel, so users will not see the new functionality
in their distributions for several months or several years. Also, if you're
talking about setting the option from user space on each startup, then
additionally there is a problem of different incompatible init systems, which
will further make things more complicated.

Is there a way to save the option somewhere in bcache superblock, like the
cache mode is saved?

> How do you think of this ?

Actually, I'd love to hear thoughts from other users and developers. Three
opinions is too few for this kind of discussion.

> Coly Li

Pavel Goran
  
