From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: bcache kernel 3.10 wrong bypassed values
Date: Thu, 04 Jul 2013 10:13:20 +0200
Message-ID: <51D52EA0.80302@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello list,

while testing bcache i noticed that while writing a big 48GB file the
sequential cutoff works fine i see only I/O on the disk but not on the
cache. I thought i would afterwards see a bypassed value of around 48GB
but it is only 1.2GB.

Is this expected? Is bcache in kernel 3.10 stable for production usage?

Greets,
Stefan
