From: "Paul B. Henson" <henson-HInyCGIudOg@public.gmane.org>
Subject: 3.10LTS ok for production?
Date: Fri, 8 Nov 2013 19:01:28 -0800
Message-ID: <20131109030128.GJ5474@bender.unx.csupomona.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I'd kinda like to use the 3.10 LTS kernel for a virtualization server
I'm building, but it seems like every time somebody reports a problem
the recommendation is to make sure you're using the latest bleeding edge
kernel. Is it intended for bcache to be considered production ready in
the 3.10 LTS branch, or do you pretty much have to run the latest stable
of the week for now if you want to be sure to get all the bcache bugfixes
necessary for a stable system? Specifically, I'd like to use a raid1 of 2
256G SSDs to be a write-back cache for a raid10 of 4 2TB HDs. Occasional
reboots aren't an issue for kernel updates, but I'd prefer to avoid the
potential instability and config churn of tracking the mainline kernel.

Thanks...
