From: David Humphreys <dave-Ni3nFjXdSsm9FHfhHBbuYA@public.gmane.org>
Subject: Re: SDD Failure - What to do?
Date: Sat, 05 Oct 2013 13:23:54 +0100
Message-ID: <525004DA.501@datatone.co.uk>
References: <524FC9DB.5080608@datatone.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <524FC9DB.5080608-Ni3nFjXdSsm9FHfhHBbuYA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I proceeded to prepare for recovery by partitioning the new SDD and
setting it up again as the boot disk (installing grub2 and the necessary
kernel and initramfs files).

I rebooted into my initramfs recovery environment and found that
everything seems to work and I haven't done anything.

I have my normal BTRFS root filesystem up and running again.

Nothing is lost. Nothing done to reconfigure bcache.

/dev/bcache0 is there and mounted as my root filesystem.

Subsidiary questions:

1) Is this now running without using the SSD cache?

2) I have complicated the situation by adding additional partitions to
the SSD (to provide journals for 'ceph'), therefore the partition on the
SSD that is now intended for bcache is not the same as it was
originally. To be specific, the original bcache SSD partition was
/dev/sda4; now I have added 4 small partitions for ceph journals and my
intended bcache partition is /dev/sda8.

My assumption is that the most likely scenario is that bcache has not
found the initialised cache partion on the SSD and is simply giving
cache-free access to the main drive.

An alternative scenario is that the cache configuration information is
actually stored on the main drive and that the new /dev/sda4 is being
used as a cache.

What I'd like to be able to configure/establish is that the new
/dev/sda8 partition is an active cache for the main drive partition
(/dev/sdb4).

Regards,
David
