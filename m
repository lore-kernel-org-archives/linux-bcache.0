From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: Bcache volume no longer mounts
Date: Mon, 26 Aug 2013 14:55:10 -0700
Message-ID: <20130826215510.GE2798@kmo-pixel>
References: <5216ACAB.7090603@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5216ACAB.7090603-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nick Payne <nick.payne-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Aug 23, 2013 at 10:28:27AM +1000, Nick Payne wrote:
> I have /home on a bcache partition - cache device is a 120GB Intel
> 330 SSD on /dev/sdb, backing store device a WD Green 2TB on
> /dev/sdd. Kernel is 3.10.9 installed from the Ubuntu mainline PPA.
> Was working fine up to shutdown last night. On bootup this morning,
> /home would not mount. Running fdisk shows sdb and sdd are
> recognised. Extracts from syslog this morning below. Any suggestions
> on how to recover the partition?

Apologies for the late response (I have been looking at the bug report
and trying to figure out just what's going on, though)

For a more immediate solution: you can force run a backing device when
the cache set isn't available. If you were using it in writeback mode
and there was dirty data in the cache there's going to be data
corruption, but IME ext4 fsck can do wonders so it shouldn't be a total
loss:

echo 1 > /sys/block/sda/sda3/bcache/run (for e.g. sda3)
