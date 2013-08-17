From: Nick Payne <nick.payne-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Subject: Can't enable writeback
Date: Sat, 17 Aug 2013 22:00:08 +1000
Message-ID: <520F65C8.8050301@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I've installed kernel 3.10.7 on Ubuntu 13.04 amd64, and bcache-tools 
from 
https://launchpad.net/~mighost/+archive/ppa/+build/4767454/+files/bcache-tools_1.0-1ppa1%7Eraring_amd64.deb. 
I can create a bcache volume and mount and use it without any problems 
using writethrough (120GB Intel 330 SSD caching a WD 2GB HDD), but when 
I try to enable writeback:

   sudo echo writeback > /sys/block/bcache0/cache_mode

it returns the error

   bash: /sys/block/bcache0/cache_mode: No such file or directory

/sys/block/bcache0 exists as a link:

   ls -l /sys/block/bc*
   lrwxrwxrwx 1 root root 0 Aug 17 15:58 /sys/block/bcache0 -> 
../devices/virtual/block/bcache0

Suggestions on how to enable writeback?

Nick Payne
