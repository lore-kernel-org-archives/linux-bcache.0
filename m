From: LuVar <luvar-2S8i3W4CjuIzjkFyG6Beag@public.gmane.org>
Subject: chache multiple devices with one cache
Date: Sat, 21 May 2011 12:09:55 +0100 (GMT+01:00)
Message-ID: <2049151873.5591305976195268.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,
I have question about using bcache in "standard" instalation of linux. I have some partitions (/boot, /home, /usr/portage, /var/lib/boinc,...) and I have one ssd hdd. I vant to use it as cache for root partition and for example for /home partition. Is it possible without partitioning ssd drive? I want from bcache to compute which of my partitions need more space for caching.

Simply I want to tel bcache that /home and / partitions should be chaced on /dev/sdg device. Is it possible with current version of bcache?

PS: I hope, reformatting my partitions will be easy as I am on lvm (on top of raid5 :-/

Have a nice day,
LuVar
