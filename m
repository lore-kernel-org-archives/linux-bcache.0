From: Stefan Priebe - Profihost AG <s.priebe-2Lf/h1ldwEHR5kwTpVNS9A@public.gmane.org>
Subject: Dirty and cleaning of dirty data
Date: Tue, 22 Oct 2013 08:11:46 +0200
Message-ID: <52661722.2050404@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

while having a system under heavystress - i was seeing the following:

Dirty Data on SSD: 35GB data
Writes to sata disk mostly 0-4mb/s

Why does bcache not start to clean this data to get free ssd space?

Right now the system is pretty slow as the caching device is very dirty.

Stefan
