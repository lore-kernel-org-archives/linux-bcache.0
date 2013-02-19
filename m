From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Wed, 20 Feb 2013 04:17:42 +1100
Message-ID: <CAOzFzEj=Gna7AQK9f01i9a64qXw0TFjNPjsEViTRcaLKDdcHpg@mail.gmail.com>
References: <1514139.9.1361276600610.JavaMail.root@zimbra>
	<5123AB2B.9020209@warr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5123AB2B.9020209-/cow75dQlsI@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Cc: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

I am not Kent.. but I can answer your questions.

8<--- snip ---->8
> A question for Kent, once you have bcache and it's tools built,
> installed and running, is there anything to stop a user from always
> tagging devices of whatever type you choose from having the superblock
> info to accept a cache dynamically?  Example, if I create an MD RAID
> device and before I pvcreate or anything else with it I prep it for
> bcache but don't actually attach a cache device, is there any negative
> effects that can come from that?  Can I then at anytime attach a cache
> device to it?  I realize that once attached in writeback it becomes
> non-detachable.  Same question for raw sd devices and LVM volumes.

In short yes, there are no detrimental effects for having backing
devices with superblocks that don't have associated cache sets.

To touch on the second point about writeback - it's not so much that
it's non-detachable it's that you don't want the backing device to be
used while the cache is not attached and is dirty (contains unflushed
data).

You can detach the cache safely from a writeback device by first
switching the cache to writethrough (or none from memory) and waiting
for the data to flush to the backing device.
Once that is done you can either continue to use it in writethrough
mode or you can detach it completely.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
