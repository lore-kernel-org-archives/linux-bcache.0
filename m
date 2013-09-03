From: Zachary Palmer <zep_bcache-J5qI5MFTcs8@public.gmane.org>
Subject: Linux 3.11-rc4 Writeback Cache Corruption
Date: Tue, 03 Sep 2013 17:26:40 -0400
Message-ID: <52265410.4010000@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

I wrote in just a couple days ago mentioning problems involving 
hibernating/suspending my laptop.  I'm using Debian Wheezy at the 
moment, so please accept my apologies for not having commit hashes 
offhand.  I'm curious about how to test a very recent patch (committed 
less than an hour ago); I think I might have the same bug as someone who 
posted a message three weeks ago.  My story so far:

     * I started by running my root filesystem over LVM over LUKS over 
bcache over an HDD partition; the bcache device is cached by a partition 
on an SSD.  I have /dev/bcache0 in writethrough mode for now to be safe; 
I'll switch to writeback once things seem stable.  I was using the 
Debian-packaged kernel in Wheezy backports: 
linux-image-3.10-0.bpo.2-686-pae=3.10.5-1~bpo70+1.  While bcache seemed 
to operate correctly, a bug prevents the bcache device from shutting 
down when I attempt to suspend, hibernate, or shut down. (I hope it's 
all the same bug.)
     * After reading about someone else who had a similar issue, I tried 
upgrading to a kernel in Debian's experimental repository: 
linux-image-3.11-rc4-686-pae=3.11~rc4-1~exp1.  This kernel appears to 
suspend/hibernate correctly.  Unfortunately, it is also plagued by some 
kind of caching bug.  While I agree with Kent's comment that it seems 
obscure in principle, I'm sure I encountered this problem numerous times 
in the space of less than a day.  Shortly after booting into this 
kernel, (a) my copy of the bitcoin blockchain seemed to have a bad 
index; (2) LibreOffice, which had not been updated and previously 
worked, complained that it could not load one of its .so files, and (3) 
the checksum failed on the APT packages list stored on my drive.  After 
reading 
http://article.gmane.org/gmane.linux.kernel.bcache.devel/1898/match=silent+data+corruption+3.11+rc4+writethrough+mode 
, I rebooted into the 3.10 kernel, detached the cache device, and 
reattached it.  Everything seems to be fine again (except I'm back to 
not being able to suspend or hibernate).
     * I've just discovered that Kent may have committed a patch for 
exactly this bug less than an hour ago.  I'm interested and willing to 
try this thing out.

So here's the question: how would I best go about testing this patch?  
In looking through the git history, it doesn't seem as if the 
bcache-for-3.11 branch has been synced against the Linux git since 
3.10-rc7 (on June 22nd).  I was thinking I could

     * Pull the Linux kernel source
     * Add the bcache git as an origin
     * Merge the bcache-for-3.11 branch into the Linux 3.11 mainline 
branch myself and
     * Assuming that this works, compile and boot the resulting kernel 
using my Debian kernel .config

Does this sound reasonable?  Or is there a better way to do this? I'm 
pretty happy with whatever gives me at least the behavior of my mainline 
3.10 kernel and I'm looking forward to getting bcache and laptop power 
modes on the same machine.  :)

Thanks,

Zach
