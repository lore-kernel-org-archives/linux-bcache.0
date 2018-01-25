From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH v3 00/13] bcache: device failure handling improvement
Date: Thu, 25 Jan 2018 18:57:25 +0000
Message-ID: <874ln9hilm.fsf@esperi.org.uk>
References: <20180114144236.28213-1-colyli@suse.de>
        <87po5ykiaw.fsf@esperi.org.uk>
        <1664591662.20180125063516@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1664591662.20180125063516@pvgoran.name> (Pavel Goran's message
        of "Thu, 25 Jan 2018 06:35:16 +0300")
Sender: linux-block-owner@vger.kernel.org
To: Pavel Goran <via-bcache@pvgoran.name>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 25 Jan 2018, Pavel Goran told this:

> Hello Nix,
>
> Thursday, January 25, 2018, 1:23:19 AM, you wrote:
>
>> This feels wrong to me. If a cache device is writethrough, the cache is
>> a pure optimization: having such a device fail should not lead to I/O
>> failures of any sort, but should only flip the cache device to 'none' so
>> that writes to the backing store simply don't get cached any more.
>
>> Anything else leads to a reliability reduction, since in the end cache
>> devices *will* fail.
>
> It's one of those choices: "if something can't work as intended, should it be
> allowed to work at all?"

Given that the only difference between a bcache with a writearound cache
and a bcache with no cache is performance... is it really ever going to
beneficial to users to have a working system suddenly start throwing
write errors and probably become instantly nonfunctional because a
cache device has worn out, when it is perfectly possible to just
automatically dissociate the failed cache and slow down a bit?

I would suggest that no user would ever want the former behaviour, since
it amounts to behaviour that worsens a slight slowdown into a complete
cessation of service (in effect, an infinite "slowdown"). Is it better
to have a system working correctly but more slowly than before, or one
that without warning stops working entirely? Is this really even in
question?!

> Of course, this only applies to "writethrough" and "writearound" modes with
> zero dirty data; "writeback" bcache devices (or devices switched from
> writeback and still having some dirty data) should probably be disabled if the
> cache device fails.

Oh yes, definitely. That's simple correctness. The filesystem is no
longer valid if you make the cache device disappear in this case: at the
very least it needs a thorough fscking, i.e. sysadmin attention.

-- 
NULL && (void)
