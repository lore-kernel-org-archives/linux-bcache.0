From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: bcache-tools and bcache support in other linux packages
Date: Thu, 26 Sep 2013 11:56:25 +0200
Message-ID: <524404C9.3030103@rolffokkens.nl>
References: <522F635D.4030905@rolffokkens.nl> <52344BAA.7070005@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52344BAA.7070005-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Development discussions related to Fedora <devel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi,

Like I did on the 14th on the linux-bcache list I'd like to send an 
update on the progress of bcache related packages. While focussing on 
Fedora packaging of bcache-tools, I had some good collaboration with 
other packagers resulting in improved bcache support in other packages 
as well. Other Linux distro's may benefit from these updated packages too.

util-linux
==========
On 27th of September util-linux v2.24 RC will probably be released. This 
release supports the identification of bcache superblocks in libblkid, 
actually integrating and obsoleting probe-bcache. Because of this udev 
rules for bcache can be simplified because they only need blkid. Of 
course this only applies to systems where util-linux v2.24 RC (or 
higher) actually is installed, otherwise probe-bcache is still needed.

Dracut
======
Since version 032 Dracut already had bcache support. Since version 033 
it adds support for util-linux v2.24 RC, so even without (obsoleted) 
probe-bcache it is able to identify bcache using blkid. Additionally 
Dracut benefits from blkid being able to identify bcache, because it 
uses blkid to identify all necessary kernel modules automatically, so no 
-N option is needed anymore.

LVM2
====
With the release of v2_01_102 LVM2 now accepts Physical Volumes on 
bcache by default. This simplifies the creation of initramfs (by Dracut) 
because no specific LVM2 option (--lvmconf) needs to be passed to 
Dracut.For the user this means that updating a kernel just works out of 
the box!

bcache-tools
============
The bcache-tools package is available in Fedora 20. I plan to build an 
updated package that no longer includes probe-bcache when the new 
util-linux is released.

Anaconda
========
Anaconda (the Fedora installer) does not support bcache yet. This is 
planned for Fedora 20. This is important when installing Fedora on a 
system and having your root filesystem on bcache. Althought other 
Distro's don't use Anaconda, I guess their installers also need to be 
changed in some way to supportbcache.

Currently having Fedora installed with your root Filesystem on bcache is 
possible, but It's done in a fewsteps:
1. Install Fedora using Anaconda without using bcache, but create an 
extra partition to supportan alternate root FS
2. From the running system build a bcache device using the extra 
partition. Copy the current root FS to the bcache root FS
3. Reboot your system in the bcache root FS, and reclaim the spaces used 
by the non-bcache root partition

More information can be found below, related to the "SSD Cache Fedora 
test day".

The SSD Cache Fedora test day
=============================
On 13th of October there's an "SSD Cache Fedora test day": see the Wiki 
page https://fedoraproject.org/wiki/Test_Day:2013-10-13_SSD_Cache. This 
page is work in progress, any feedback is welcome. People interested in 
testing are invited to participate on 13th of October.

When there's anything new toreport, I'll keep you posted.

Rolf Fokkens
