From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: 3.10LTS ok for production?
Date: Fri, 8 Nov 2013 22:47:21 -0800
Message-ID: <20131109064721.GC30271@kmo-pixel>
References: <20131109030128.GJ5474@bender.unx.csupomona.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131109030128.GJ5474-eJ6RpuielZ6oHZ9hTG1MgCsmlnnoMqry@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Nov 08, 2013 at 07:01:28PM -0800, Paul B. Henson wrote:
> I'd kinda like to use the 3.10 LTS kernel for a virtualization server
> I'm building, but it seems like every time somebody reports a problem
> the recommendation is to make sure you're using the latest bleeding edge
> kernel. Is it intended for bcache to be considered production ready in
> the 3.10 LTS branch, or do you pretty much have to run the latest stable
> of the week for now if you want to be sure to get all the bcache bugfixes
> necessary for a stable system? Specifically, I'd like to use a raid1 of 2
> 256G SSDs to be a write-back cache for a raid10 of 4 2TB HDs. Occasional
> reboots aren't an issue for kernel updates, but I'd prefer to avoid the
> potential instability and config churn of tracking the mainline kernel.

Yes - 3.10 LTS (or 3.11) has been what you want to be running for awhile
now; I've been making sure all the bugfixes get backported quickly. The
only bugfix I know of that I wasn't backported was a fix for a suspend
issue, because it was part of a fairly involved allocator rework.
