From: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Subject: Re: bcache hangs on writes, recovers after disabling discard on
 cache device
Date: Thu, 18 Jul 2013 15:05:49 +0300 (EEST)
Message-ID: <alpine.DEB.2.02.1307181458180.18577@orbit.lan>
References: <51C891C9.4060809@modelnine.org> <alpine.DEB.2.02.1307111748130.26927@orbit.lan> <20130712011554.GA17799@kmo-pixel> <alpine.DEB.2.02.1307121902540.10602@orbit.lan> <alpine.DEB.2.02.1307162111590.3617@orbit.lan>
 <20130716210527.GC27000@kmo-pixel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130716210527.GC27000@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, 16 Jul 2013, Kent Overstreet wrote:

> On Tue, Jul 16, 2013 at 09:14:09PM +0300, Juha Aatrokoski wrote:
>> On Fri, 12 Jul 2013, Juha Aatrokoski wrote:
>>>> Can you give this patch a try? It's on top of the current
>>>> bcache-for-3.11 branch
>>>
>>> OK, now running the same kernel with this patch applied and
>>> discard enabled. However, it has previously taken my system 2-4
>>> days to trigger this bug, so I'd say at least two weeks before I
>>> can say the patch (may have) fixed the issue.
>>
>> No such luck, hit the bug after four days of uptime. Disabling
>> discard fixed the problem so at least it's not any worse than
>> before.
>
> Argh, damn peculiar bug... and the fact that it takes so long to trigger
> is frustrating. I'm honestly at a loss at this point as to what that IO
> actually is.

One thing I noticed is that your patch only affects the allocator, the 
journal still does discards the old way. Perhaps it's worth a try to 
apply a similar change to the journal discards?

> I should've thought of this sooner, but if there's any way you could
> capture some blktrace output while it's doing its spinning thing that
> could be very helpful.

OK, I will attempt to reproduce the bug again after the weekend and I'll 
try to remember to use blktrace.
