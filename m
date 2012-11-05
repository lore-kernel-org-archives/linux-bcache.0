From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: Re: Kernel Oops (bCache hangs on registering 3rd device)
Date: Mon, 5 Nov 2012 16:02:57 +0000 (UTC)
Message-ID: <loom.20121105T165829-696@post.gmane.org>
References: <loom.20121104T035737-445@post.gmane.org> <loom.20121105T135531-268@post.gmane.org> <loom.20121105T140203-975@post.gmane.org> <CAOzFzEjpdgNNnsXB4TQyJ2hAG91HZ19JEGJ+H9sQ9+akKiDW2g@mail.gmail.com> <loom.20121105T151725-920@post.gmane.org> <CAOzFzEiJL7CbQ5TXT2nigS5WyWx8oWuDCPJ7B3in0792jK4NOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Joseph Glanville <joseph.glanville@...> writes:

> >>
> >> Though not a fix, a workaround could be to use LVM rather than partitions.
> >>
> >> LVM ontop of bcache works quite nicely you just need to add the
> >> following to /etc/lvm.conf
> >>
> >> types = [ "bcache", 16 ]
> >>
> >> Also check your filter line to ensure that /dev/bcacheX will be scanned as 
a
> > PV.
> >>
> >> Once you have done that you can create a volume group as usual:
> >>
> >> vgcreate vg0 /dev/bcache0
> >>
> >> And then any number of LVs:
> >>
> >> lvcreate -n root -L50G vg0
> >>
> >> In my opinion this is considerably better than partitions.
> >>
> >> Joseph.
> >>
> >
> > I wish I could do that but the cache devices are being exposed to virtual
> > machines as virtual disks and so the clients could easily repartition them 
back
> > which would then reproduce the conflicting block device numbers.
> >
> > I am also not sure how well LVM might cope if the PV's (etc..) were detected
> > both in the host operating system and within a guest.
> >
> 
> What kind of guests are these?
> 
> If I am correct this is some sort of VPS environment, probably Xen or KVM?
> 
> In that case if you pass through a logical volume and you properly
> adjust the filter in the host OS to only scan the bcache devices and
> not traverse recursively this works perfectly.
> The guest OS will be able to partition the logical volume and the
> guest will not be able the see the underlying volume group.
> 
> 
> Joseph.
> 


Hi Joseph,

Again, thank you for putting in the time to help me.

Yes, it is KVM.

I don't think I had thought about it the way you describe. (Passing an LV to KVM 
instead of the bcache device)   I will certainly give it a try.  Sounds like it 
could solve all my problems.

I will drop a reply here if it works.

Thanks again,

James
