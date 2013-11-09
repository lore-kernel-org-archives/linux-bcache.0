From: Stefan Priebe <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Re: 3.10LTS ok for production?
Date: Sat, 09 Nov 2013 08:11:35 +0100
Message-ID: <527DE027.2050606@profihost.ag>
References: <20131109030128.GJ5474@bender.unx.csupomona.edu> <20131109064721.GC30271@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131109064721.GC30271@kmo-pixel>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

at least i'm suffering from two problems on 3.10:

1.) dirty value is often wrong / can go negative
2.) writeback cache is only cleared / written back when having 
writeback_percent => 0

The first one is already fixed by kent - just waiting for a backport.

Greets,
Stefan

Am 09.11.2013 07:47, schrieb Kent Overstreet:
> On Fri, Nov 08, 2013 at 07:01:28PM -0800, Paul B. Henson wrote:
>> I'd kinda like to use the 3.10 LTS kernel for a virtualization server
>> I'm building, but it seems like every time somebody reports a problem
>> the recommendation is to make sure you're using the latest bleeding edge
>> kernel. Is it intended for bcache to be considered production ready in
>> the 3.10 LTS branch, or do you pretty much have to run the latest stable
>> of the week for now if you want to be sure to get all the bcache bugfixes
>> necessary for a stable system? Specifically, I'd like to use a raid1 of 2
>> 256G SSDs to be a write-back cache for a raid10 of 4 2TB HDs. Occasional
>> reboots aren't an issue for kernel updates, but I'd prefer to avoid the
>> potential instability and config churn of tracking the mainline kernel.
>
> Yes - 3.10 LTS (or 3.11) has been what you want to be running for awhile
> now; I've been making sure all the bugfixes get backported quickly. The
> only bugfix I know of that I wasn't backported was a fix for a suspend
> issue, because it was part of a fairly involved allocator rework.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
