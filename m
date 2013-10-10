From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Sunday 13th of October: Fedora bcache test day
Date: Thu, 10 Oct 2013 22:38:52 +0200
Message-ID: <5257105C.8070407@rolffokkens.nl>
References: <5255D277.3060802@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5255D277.3060802-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi All,

Bcache-tools for Fedora 20 is now close to completion, so it's 
integrated very well with dracut, udev, util-linux and lvm2. What's left 
is some good testing :-)

To do some testing there's a Fedora SSD Cache is this sunday October 
13th 2013. This Fedora Test Day will focus on bcache based SSD Caching 
in Fedora 20:

https://fedoraproject.org/wiki/Test_Day:2013-10-13_SSD_Cache

If you're interested in trying out the bcache SSD caching functionality 
on Fedora, step by step instructions are available for:
- bcache on physical hardware
- bcache in a virtual machine
- non-root FS on bcache (with or without LVM)
- root FS on bcache (wtih or without LVM)

The objective of this Test day is to demonstrate a working Fedora 20 
system using bcache. Te be more specific:
* The system boots OK; after booting bcache is operating as expected
* The system updates ("yum update") OK. After updating specifically the 
kernel the system boots OK.
* The system is bootable when the caching device is disabled.

Although testing on real hardware is closest to "the real thing", 
testing in a VM may also provide good insights on the proper working of 
bcache (except for performance) in relation to the other software.

If you do plan on showing up to the test day pop into #fedora-test-day 
on freenode and give us a shout! If you can't make the date of the test 
day, adding test case results to the wiki anytime next week is fine as well.

The Wiki page is still under development, so expect some improvements 
before sunday.

Rolf Fokkens
