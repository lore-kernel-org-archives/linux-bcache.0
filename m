From: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Subject: RE: Adding caching to existing volumes?
Date: Tue, 22 Jan 2013 23:42:10 +0000
Message-ID: <6035A0D088A63A46850C3988ED045A4B356382D3@BITCOM1.int.sbss.com.au>
References: <17989056.10.1358618905144.JavaMail.root@zimbra>
 <50FBA4A6.7020709@crc.id.au> <20130122231547.GF26407@google.com>
 <50FF2016.4020802@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50FF2016.4020802-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> 
> On 23/01/2013 10:15 AM, Kent Overstreet wrote:
> > On Sun, Jan 20, 2013 at 07:02:46PM +1100, Steven Haigh wrote:
> >> On 20/01/2013 5:08 AM, Roy Sigurd Karlsbakk wrote:
> >>> Hi all
> >>>
> >>> As far as I can understand from the bcache docs, a volume cached with
> bcache, must be formatted and setup for bcache in the first place. I come
> from a ZFS environment, where adding SLOG or L2ARC is done dynamically,
> so I have a few questions:
> >>>
> >>> - Would it be somewhat possible to add caching to an existing volume
> and its data?
> >>> - What would happen if the cache device dies - does the whole
> filesystem become inaccessible?
> >>
> >> I've actually been wondering a bit about this - its not exactly
> >> clear in the docs as to what I should do to set up bcache.
> >>
> >> In my case, I have a RAID6 over 4 x 2Tb drives. It lives as
> >> /dev/md2. /dev/md[01] are RAID1 on a pair of 80Gb drives for boot
> >> and LVM.
> >>
> >> As the system is a Xen Dom0, all the DomU (guests) run from their
> >> own LV on the RAID6. So - it would make sense to add bcache to
> >> /dev/md2.
> >>
> >> I'm a bit confused from reading the docs if I can attach to the
> >> existing /dev/md2 or I have to create something from scratch.
> >> Obviously, attaching to an existing RAID device is going to be the
> >> preferred method.
> >>
> >> Covering this in the docs or even on the web site would probably be
> >> beneficial for a lot of people - especially as I feel that this is
> >> getting closer to be merged with the upstream kernel.
> >
> > You've got to start from scratch, unfortunately.
> >
> > The reason is that there needs to be a bcache specific superblock on the
> > backing device so bcache can keep the cache and backing device in sync -
> > and especially so you can't accidentally mount and use the backing
> > device without the cache. That would be bad.
> >
> > I just added an explanation to the faq - thanks for pointing it out.
> > http://bcache.evilpiepirate.org/FAQ
> 
> Great! Thanks Kent. Although this now makes me wonder how to shift the
> 2Tb+ of data to try this... That being said, I don't have a spare SSD at
> this stage, so the main thing was looking at getting a patch file to
> then add to the kernel during compile time of the RPM packages.
> 
> The hard part would be redoing the entire LVM structure again for the
> guest OS's.
> 

If your backups are good, you could do what I did:
. plug in the required number of additional disks, USB might do (I just broke my RAID1 and created a new degraded RAID1 etc)
. add them as PV's to your VG
. Use pvmove to move everything off your RAID PV's.
. Remove the RAID PV's from the VG
. Rebuild the RAID volume as a bcache volume
. Add the bcache volume to the VG
. Use pvmove to move everything back

I thought I might have problems because my disks had 512 byte sectors and the bcache volume had 4K sectors by default (is this still the case?), but LVM didn't care. Xen cares though - once I did reboot later and LVM officially presented 4K sectors my Xen windows VM's wouldn't reboot and I had to do it all over again, recreating the bcache volume with 512 byte sectors.

The really nice thing was that I could do it all live without shutting down or anything (except for the 4K/512byte thing), even though I was moving the root volume around. LVM is great!

I use my root volume on the bcache volume, but in retrospect it probably wasn't a great idea as suddenly I can't boot with a non-bcache-enabled kernel anymore. Make sure you have an emergency boot CD or something with your bcache kernel on it!

James
