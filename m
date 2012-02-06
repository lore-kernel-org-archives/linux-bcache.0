From: Piergiorgio Sartor <piergiorgio.sartor-KvP5wT2u2U0@public.gmane.org>
Subject: bcache on layered devices
Date: Mon, 6 Feb 2012 19:56:12 +0100
Message-ID: <20120206185612.GA2381@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all again,

I'm not sure if the topic was already discussed here,
anyway I'll go ahead, sorry if it is a duplication.

I was wondering, in case of layered devices, what would
be the best layer to use as backing device.

Specifically, I've two HDDs in RAID10 (Linux md driver,
software RAID), on top of the RAID there are LV partitions.

Obviously, it would be possible to use the RAID components,
i.e. the HDDs as backing devices, or the RAID itself, or
the LV partitions (/dev/mapper/VolXXX).

My guess would be to use the LV partitions, since these
are closer to the filesystem, but, maybe, using the RAID
or even the single HDDs could be better.

Any idea on the topic? Suggestions & motivations?

Thanks a lot in advance,

bye,

-- 

piergiorgio
