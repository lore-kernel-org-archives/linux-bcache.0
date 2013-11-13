From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: RE: 3.10LTS ok for production?
Date: Tue, 12 Nov 2013 16:17:04 -0800
Message-ID: <08dc01cee005$b084baf0$118e30d0$@acm.org>
References: <20131109030128.GJ5474@bender.unx.csupomona.edu> <op.w59n7e06f3gqgg@desktop.patton.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <op.w59n7e06f3gqgg-r49W/1Cwd2cba4AQcYcrVKxOck334EZe@public.gmane.org>
Content-Language: en-us
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Matthew Patton' <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> From: Matthew Patton [mailto:pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org]
> Sent: Friday, November 08, 2013 9:29 PM
>
> The following is opinion, MY opinion.

Noted; thanks for taking the time to share it :).

> I think that's hard to say. The .10 code wasn't re-worked like the .11
> branch and it may well have fewer issues than the .11 series.

There was a re-factoring between .10 and .11? I hadn't noticed that.
 
> Storage is the LAST place to cut corners. Unless of course your data isn't
> important, can be thrown away, or recreated without a lot of time and
> sweat.

Well, technically, this particular deployment is for my house ;), and while
I wouldn't really agree with any of those statements for my data, this hobby
box has already become ridiculously expensive, and I'd like to make the best
of the pieces I already have.
 
> Personally I think it needs another 3 months to bake, even in the 3.11.6
> guise.

Hmm, won't 3.11 be EOL before then? So presumably the result of that bake
time would be in 3.12.

> As to your specific example, are WRITE IOPs of critical importance? If
> not, just use WRITE-THRU and have the SSDs be a READ cache for hot data.
>
> There is no or almost zero risk to your data in that configuration.

Well, I don't know if I'd agree with that; bugs in bcache could result in
corrupted data being returned from reads or ending up on the backing devices
right even in write through, definitely less risk I would think then write
back, but none?

> Despite all the hand-waving by sysadmins, READ cache is far more useful as
> a practical matter than WRITE. If you have a heavy WRITE load, then there
> is no good solution that doesn't cost money.

Theoretically, caching the writes through the SSD should decrease latency
and turn random IO into a sequential stream for the backing device,
resulting in increased performance. Ideally, I'd like to avail of that :). 

> the alternative software solutions both of which are free: IOEnhance from
> STEC

It looks like they was some activity back in February about getting that
into the staging driver section of the kernel, but I don't see it there, and
I don't see any further activity, so not sure what happened there. I'd
prefer to use functionality in the standard kernel, as opposed to compiling
in outside stuff.

> the in-kernel MD-hotspot

Do you have a reference for that? I can't seem to find anything via Google.

> Failing that, shell out the money for a ZFS-friendly setup and abstract
> the storage away from your virtual machines. Indeed that's a much better
> design anyway.

I actually have a storage server sitting right next to the virtualization
server running illumos/zfs, with roughly 21TB of storage, which is going to
provide bulk storage, but I plan to have the vm operating system files and
smaller data on the virtualization server itself.

> Lastly maybe forget KVM/Xen and get VMware ESXi as your hypervisor.

We use ESXi at my day job, it's got a pretty good feature set, but I'm
trying to stick with open source for my home deployments...

Thanks for your thoughts.
