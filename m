From: Juha Aatrokoski <jha-6fQLAAUwtFMxHbG02/KK1g@public.gmane.org>
Subject: Re: bcache hangs on writes, recovers after disabling discard on
 cache device
Date: Tue, 16 Jul 2013 21:14:09 +0300 (EEST)
Message-ID: <alpine.DEB.2.02.1307162111590.3617@orbit.lan>
References: <51C891C9.4060809@modelnine.org> <alpine.DEB.2.02.1307111748130.26927@orbit.lan> <20130712011554.GA17799@kmo-pixel> <alpine.DEB.2.02.1307121902540.10602@orbit.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1307121902540.10602-pfGh9vBu50j/PtFMR13I2A@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, 12 Jul 2013, Juha Aatrokoski wrote:

> On Thu, 11 Jul 2013, Kent Overstreet wrote:
>
>> On Thu, Jul 11, 2013 at 05:58:17PM +0300, Juha Aatrokoski wrote:
>>> On Mon, 24 Jun 2013, Heiko Wundram wrote:
>>> 
>>>> In a rather old thread of mine (514C4FC1.6090804-EqIAFqbRPK3NLxjTenLetw@public.gmane.org), I
>>>> already stated a problem I was seeing back at the time, namely
>>>> that bcache seems to hang on writes to the SSD device after some
>>>> time, writing 50 MB/s continuously to the output device.
>>> ...
>>>> Disabling discard on the SSD device (by echo 0 >
>>>> /sys/fs/bcache/.../cache0/discard) makes the bcache device become
>>>> responsive again.
>>> 
>>> I can confirm this. On Monday I booted into kernel 3.8.13-gentoo
>>> with the current "bcache" branch patched onto it. Discard was on for
>>> the cache device, and today this 50MB/s hang occured. Disabling
>>> discard did indeed fix it.
>>> 
>>> I had CONFIG_BCACHE_CLOSURES_DEBUG=y in the kernel, and the contents
>>> of /sys/kernel/debug/bcache/bcache-UUID and
>>> /sys/kernel/debug/closures both before and after disabling discard
>>> can be found at the address below, in case they can help in
>>> determining where exactly the hang happens.
>> 
>> Can you give this patch a try? It's on top of the current
>> bcache-for-3.11 branch
>
> OK, now running the same kernel with this patch applied and discard enabled. 
> However, it has previously taken my system 2-4 days to trigger this bug, so 
> I'd say at least two weeks before I can say the patch (may have) fixed the 
> issue.

No such luck, hit the bug after four days of uptime. Disabling discard 
fixed the problem so at least it's not any worse than before.
