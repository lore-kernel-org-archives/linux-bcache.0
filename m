From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: can't get bache's sequential_cutoff to work
Date: Tue, 23 Jul 2013 16:16:54 +0200
Message-ID: <51EE9056.7030903@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

maybe i missed something or maybe i'm just wrong.


# cat /sys/block/bcache2/bcache/sequential_cutoff
512k

# cat /sys/block/bcache2/bcache/stats_five_minute/bypassed
64.3M

# dd if=/dev/zero of=/mnt/bcache2/ttt bs=4M count=1000 oflag=direct
1000+0 records in
1000+0 records out
4194304000 bytes (4,2 GB) copied, 11,0348 s, 380 MB/s

# cat /sys/block/bcache2/bcache/stats_five_minute/bypassed
69.3M

I also see only IOP/s an writes go to the SSD but not to the disk
behind. What's wrong?

Greets,
Stefan
