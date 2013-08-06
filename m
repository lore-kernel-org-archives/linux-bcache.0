From: Tim Small <tim-vjYYaD5tTFXhKRip0M0iNA@public.gmane.org>
Subject: bcache and md / lvm / ext4 alignment
Date: Tue, 06 Aug 2013 14:34:22 +0100
Message-ID: <5200FB5E.3050803@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I'm planning to test bcache like this:

8x SATA drives
md RAID10
bcache
lvm
ext3/ext4

Recent LVM versions have these two settings:

>     # By default, if a PV is placed directly upon an md device, LVM2
>     # will align its data blocks with the md device's stripe-width.
>     # 1 enables; 0 disables.
>     md_chunk_alignment = 1
>
>     # By default, the start of a PV's data area will be a multiple of
>     # the 'minimum_io_size' or 'optimal_io_size' exposed in sysfs.
>     # - minimum_io_size - the smallest request the device can perform
>     #   w/o incurring a read-modify-write penalty (e.g. MD's chunk size)
>     # - optimal_io_size - the device's preferred unit of receiving I/O
>     #   (e.g. MD's stripe width)
>     # minimum_io_size is used if optimal_io_size is undefined (0).
>     # If md_chunk_alignment is enabled, that detects the optimal_io_size.
>     # This setting takes precedence over md_chunk_alignment.
>     # 1 enables; 0 disables.
>     data_alignment_detection = 1

... so will bcache pass the correct settings up to lvm via sysfs?

When creating ext* filesystems on top of mds I currently use this:

http://busybox.net/~aldot/mkfs_stride.html

... and I was wondering if bcache's metadata will be OK with this?


Also, I noted that in the bcache.txt it says that discard is off by
default because " SATA TRIM is an unqueued command (and thus slow)".  I
see that SATA v3.1 includes a queued trim/discard command, but I don't
know if Linux yet has the support for it (there are a few SSDs with SATA
v3.1 support on the market I think).

Tim.
