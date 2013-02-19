From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Tue, 19 Feb 2013 12:40:14 -0800
Message-ID: <20130219204014.GK27179@google.com>
References: <1514139.9.1361276600610.JavaMail.root@zimbra>
 <5123AB2B.9020209@warr.net>
 <CAOzFzEj=Gna7AQK9f01i9a64qXw0TFjNPjsEViTRcaLKDdcHpg@mail.gmail.com>
 <5123B976.6050400@warr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5123B976.6050400-/cow75dQlsI@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>, Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Tue, Feb 19, 2013 at 11:42:14AM -0600, Jason Warr wrote:
> 
> On 02/19/2013 11:17 AM, Joseph Glanville wrote:
> > I am not Kent.. but I can answer your questions.
> >
> > 8<--- snip ---->8
> >> A question for Kent, once you have bcache and it's tools built,
> >> installed and running, is there anything to stop a user from always
> >> tagging devices of whatever type you choose from having the superblock
> >> info to accept a cache dynamically?  Example, if I create an MD RAID
> >> device and before I pvcreate or anything else with it I prep it for
> >> bcache but don't actually attach a cache device, is there any negative
> >> effects that can come from that?  Can I then at anytime attach a cache
> >> device to it?  I realize that once attached in writeback it becomes
> >> non-detachable.  Same question for raw sd devices and LVM volumes.
> > In short yes, there are no detrimental effects for having backing
> > devices with superblocks that don't have associated cache sets.
> 
> That's what I thought.  This could be an argument for integration with
> DM or MD.  Up-rev the superblock or metadata version and have the bcache
> bits in it by default.

Yeah, that idea's been kicked around before. A couple people have said
they were going to work on it, but nothing's happened.

> >
> > To touch on the second point about writeback - it's not so much that
> > it's non-detachable it's that you don't want the backing device to be
> > used while the cache is not attached and is dirty (contains unflushed
> > data).
> >
> > You can detach the cache safely from a writeback device by first
> > switching the cache to writethrough (or none from memory) and waiting
> > for the data to flush to the backing device.
> > Once that is done you can either continue to use it in writethrough
> > mode or you can detach it completely.
> >
> :) Typing faster than I am thinking.  I should have said non-detachable
> while in writeback mode, or rather while it contains "dirty" blocks.

You actually don't have to switch out of writeback mode to safely detach
- if you detach in writeback mode, it detaches as soon as it's finished
flushing all the dirty data.
