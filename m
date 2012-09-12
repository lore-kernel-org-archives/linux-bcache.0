From: Brad Walker <bwalker-WlSugiYO8JFBDgjK7y7TUQ@public.gmane.org>
Subject: problem w/ read caching..
Date: Wed, 12 Sep 2012 14:01:07 -0600
Message-ID: <CAPKZHbV3n7O+VRVNS-C2oDVSpO_VdirMDUOuwwWKaA5ZOUEG_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I am having a problem with BCache.

I=92ve followed the documentation and have my cache attached. Here is
what dmesg tells me:

[  372.622905] bcache: invalidating existing data
[  372.637517] bcache: registered cache device rssda1
[  400.704672] bcache: Caching dm-2 as bcache0 on set
16fd7139-f018-461c-9d9e-daa

I warmed up the cache by using an application (vdbench) to do random
reads over a 10GB region.

Everything looks good as the response time comes down as the cache
warms up. But, for some reason the cache_hit_rate is showing 90% and
yet I=92m still seeing heavy activity to the disk device.

bwalker@nellis:~> cat
/sys/fs/bcache/16fd7139-f018-461c-9d9e-daa7666c7f1e/stats_total/cache_h=
it_ratio
94
bwalker@nellis:~>

Any ideas on why this might be happening are appreciated.

-brad w.
