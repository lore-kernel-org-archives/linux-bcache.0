From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Re: bcache support in other linux packages
Date: Sat, 14 Sep 2013 13:42:34 +0200
Message-ID: <52344BAA.7070005@rolffokkens.nl>
References: <522F635D.4030905@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <522F635D.4030905-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi,

I'd like to report some other nice progress as well, related to other 
Linux packages. Although I'm working on Fedora packaging, there is good 
spin-off for all Linux distro's out there!

Util-Linux
=====
Util-Linux 2.24 will have support for bcache built in (for blkid and 
wipefs): https://bugzilla.redhat.com/show_bug.cgi?id=1001120. This means 
that "stuff gets more straightforward", e.g. the udev rules for bcache 
can simply rely on bcache instead of also having to call probe-bcache. 
There's also benefits for Dracut, see below.

Dracut
====
Dracut 032 already had bcache support, dracut 033 now has support built 
in for the migration phase from probe-bcache to blkid. I did some 
testing with a root FS on bcache, and dracut perfectly builds a booting 
initramfs! Beware though that there is a (soft) dependency on Util-Linux 
2.24. When using an older Util-linux users should pass the -N option to 
dracut te build a functional initramfs. More details: 
https://bugzilla.redhat.com/show_bug.cgi?id=1003207

I'm aware that other distro's don't use dracut to build an initramfs, 
but the dracut related info may be useful."

LVM2
===
LVM2 needs a small change to be able to detect PV's on bcache devices. 
Without the change users need to add a "types = [ "bcache", 1 ]" line in 
the /etc/lvm/lvm.conf. Users may also need to pass the --lvmconf option 
to dracut when booting from a root FS on bcache. More details: 
https://bugzilla.redhat.com/show_bug.cgi?id=1000817

In the bugzilla there's a claim that bcache support in Fedora isn't 
supportable because upstream (bcache) is'nt actively working with 
Fedora. I don't agree with this, because I think the collaboration with 
upstream is working fine.

I'll keep you all posted,

Rolf
