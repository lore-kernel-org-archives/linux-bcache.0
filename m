From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: label devices got removed after format
Date: Thu, 11 Jul 2013 11:43:22 +0200
Message-ID: <51DE7E3A.5070709@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

after doing mkfs.xfs -f /dev/bcache/by-label/mybcachelabel

/dev/bcache/by-label/mybcachelabel gots removed...

Only a reboot brings it back.

Stefan
