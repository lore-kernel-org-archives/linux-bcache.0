From: James Pharaoh <james@pharaoh.uk>
Subject: Re: Extra write mode to close RAID5 write hole (kind of)
Date: Fri, 28 Oct 2016 18:02:52 +0100
Message-ID: <8171ae69-3ea7-aaa6-a038-4cbaaec1ea60@pharaoh.uk>
References: <bd0112e0-976a-59e8-94ef-81777f240ffd@pharaoh.uk>
 <20161028115903.acsmc3cfemhxgt52@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:54956
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751856AbcJ1RDP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Oct 2016 13:03:15 -0400
In-Reply-To: <20161028115903.acsmc3cfemhxgt52@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 28/10/16 12:59, Kent Overstreet wrote:
> On Wed, Oct 26, 2016 at 04:20:38PM +0100, James Pharaoh wrote:
>> Since I want my bcache device to essentially be a "journal", and to close
>> the RAID5 write hole, I would prefer to disable this behaviour.
>>
>> I propose, therefore, a further write mode, in which data is always written
>> to the cache first, and synced, before it is written to the underlying
>> device. This could be called "journal" perhaps, or something similar.
>>
>> I am optimistic that this would be a relatively small change to the code,
>> since it only requires to always choose the cache to write data to first.
>> Perhaps the sync behaviour is also more complex, I am not familiar with the
>> internals.
>>
>> So, does anyone have any idea if this is practical, if it would genuinely
>> close the write hole, or any other thoughts?
>
> It's not a crazy idea - bcache already has some stripe awareness code that could
> be used as a starting point.
>
> The main thing you'd need to do is ensure that
>  - all writes are writeback, not writethrough (as you noted)
>  - when the writeback thread is flushing dirty data, only flush entire stripes -
>    reading more data into the cache if necessary and marking it dirty, then
>    ensure that the entire stripe is marked dirty until the entire stripe is
>    flushed.
>
> This would basically be using bcache to do full data journalling.
>
> I'm not going to do the work myself - I'd rather spend my time working on adding
> erasure coding to bcachefs - but I could help out if you or someone else wanted
> to work on adding this to bcache.

I don't expect anyone to do the work, or to do this mysekf, although if 
I have the funds, and I may do soon, I would be prepared to pay someone 
to do it.

At the moment, I'm trying to check my facts/assumptions while designing 
a complex system which won't be fully operational for a while. I'd like 
to be sure that it is genuinely scalable, as in the design is valid, 
before I continue working in this way.

For what it's worth, I have recently set up a lot of this, taking 
advantage of extremely cheap servers set up in a "novel" way, and the 
performance is pretty good. As I've mentioned, I would like to write up 
what I've done, why, and perhaps create an open source management suite 
for people to repeat it.

James
