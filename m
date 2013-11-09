From: "Matthew Patton" <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.10LTS ok for production?
Date: Sat, 09 Nov 2013 00:29:28 -0500
Message-ID: <op.w59n7e06f3gqgg@desktop.patton.net>
References: <20131109030128.GJ5474@bender.unx.csupomona.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131109030128.GJ5474-eJ6RpuielZ6oHZ9hTG1MgCsmlnnoMqry@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

The following is opinion, MY opinion.

On Fri, 08 Nov 2013 22:01:28 -0500, Paul B. Henson <henson-HInyCGIudOg@public.gmane.org> wrote:

> kernel. Is it intended for bcache to be considered production ready in
> the 3.10 LTS branch, or do you pretty much have to run the latest stable
> of the week for now if you want to be sure to get all the bcache bugfixes
> necessary for a stable system?

I think that's hard to say. The .10 code wasn't re-worked like the .11  
branch and it may well have fewer issues than the .11 series. It's also  
not clear that EVERY bug uncovered in the .11 branch (that wasn't narrowly  
specific to .11) has been properly back-ported.

> Specifically, I'd like to use a raid1 of 2
> 256G SSDs to be a write-back cache for a raid10 of 4 2TB HDs. Occasional
> reboots aren't an issue for kernel updates, but I'd prefer to avoid the
> potential instability and config churn of tracking the mainline kernel.

Storage is the LAST place to cut corners. Unless of course your data isn't  
important, can be thrown away, or recreated without a lot of time and  
sweat. Don't get me wrong, I like what BCache is trying to do and I sent  
Kent $100 of my own money to support his efforts back when continued  
development seemed to be in jeopardy.

Personally I think it needs another 3 months to bake, even in the 3.11.6  
guise.

As to your specific example, are WRITE IOPs of critical importance? If  
not, just use WRITE-THRU and have the SSDs be a READ cache for hot data.  
There is no or almost zero risk to your data in that configuration.  
Despite all the hand-waving by sysadmins, READ cache is far more useful as  
a practical matter than WRITE. If you have a heavy WRITE load, then there  
is no good solution that doesn't cost money.

If your 4 disks can't support the desired IOPs, then bite the bullet and  
get faster disks, more disks, or more cache on the RAID controller, or try  
the alternative software solutions both of which are free: IOEnhance from  
STEC or the in-kernel MD-hotspot. I have no useful degree of experience  
with either, however.

Failing that, shell out the money for a ZFS-friendly setup and abstract  
the storage away from your virtual machines. Indeed that's a much better  
design anyway.

I personally run LSI controllers with CacheCade (sadly limited to 500GB of  
SSD cache) or you can spring for an equivalent feature set from Adaptec -7  
series (unlimited SSD cache) for under $800.

My other fancy controller is an Areca with 4GB of battery-backed RAM.

My storage nodes also have battery-backed 512MB NVRAM boards (dirt cheap  
on Ebay) and I use those as targets for filesystem journals or MD Raid1  
intent logs.

Lastly maybe forget KVM/Xen and get VMware ESXi as your hypervisor. It  
supports SSDs as block cache too but I'm not sure which level of product  
is needed to activate it. It can be as cheap as $500 for 3 two-socket  
physical hosts to $1500+/socket.

In conclusion, if staying with BCache use it in write-thru mode.
