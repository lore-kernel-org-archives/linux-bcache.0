From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: bcache hangs with continuous write I/O to SSD device, bcache
 device stops working
Date: Fri, 22 Mar 2013 15:16:13 +0100
Message-ID: <20130322141613.GA29496@gmail.com>
References: <514C4FC1.6090804@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <514C4FC1.6090804-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 22.03.2013 13:34, Heiko Wundram wrote:
> Hey!
> 
> I've checked out multiple trunks over the last two weeks of the
> current bcache repository (all 3.8.0+), and they all exhibit the
> same kind of broken behaviour: after some time (generally around 6
> hours), I/O to the bcache device stops working (I have layered LVM
> on top of it, and those devices also stop working, naturally), and
> the SSD that's part of the cache set spins continuously at around
> 50MB/s I/O on write. It is irrelevant whether I enable discard or
> not. I've only tested this with writeback mode.

Hi Heiko,

that sounds pretty much the same as what I experienced this week.
After finishing some write benchmarks on a bcache device, dirty data
blocks have to be synchronized to backing devices really slowly.
(20~30 MB/s in my case)
That sync job usually takes more than 5 minutes,
which makes end users unable to do anything.

My test environment:
kernel 3.4.23 with bcache patches backported from master.
Backing device is configured as MD-RAID10 on spindle drives.
Cache mode is writeback.

I've also tested with bcache-3.2,
but it was not much different from 3.4+.

Regards,
Dongsu

> 
> Is this a known problem?
> 
> -- 
> --- Heiko.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
