From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Resizing bcache backing store
Date: Fri, 2 Nov 2012 08:20:00 -0700
Message-ID: <20121102152000.GC14917@google.com>
References: <CAB7K1hH_o7koST7RYTbw9ya0GMEvmpb=TYAt1MqEVDhtBdRd1Q@mail.gmail.com>
 <CAH+dOxJv-ajvLfbUSo8dqG0a8_grNBhfxJ1EbmSrYZz0YXJM2w@mail.gmail.com>
 <loom.20121101T195722-160@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20121101T195722-160-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Thu, Nov 01, 2012 at 07:06:01PM +0000, James Sefton wrote:
> Kent Overstreet <koverstreet@...> writes:
>=20
> >=20
> > For the backing device, I think things will just work - you'll just
> > have to close and reopen the backing device in order for bcache to
> > notice the new size. Bcache's superblock doesn't remember the size,=
 it
> > just goes off of what the size of the backing device is when it's
> > registered.
> >=20
> > There's currently no way to make bcache notice the backing device h=
as
> > grown to do it at runtime, though that ought to be fairly simple to=
o.
> >=20
> > On Wed, Apr 11, 2012 at 6:47 PM, David Rhodes Clymer
> > <david@...> wrote:
> > > In the case where the bcache backing store is resizeable (eg. a
> > > logical volume), is it possible to resize the backing store witho=
ut
> > > breaking bcache? Let's say, for example, that I would
> > > unmount/unregister /dev/bcacheX, resize the backing store,
> > > reregister/remount the cache.
> > >
> > > I imagine a better approach would be to layer LVM on the cache de=
vice
> > > itself. However, in this particular case, I set up the bcache bef=
ore I
> > > had learned how to get LVM to use a bcache device as a PV.
> > >
> > > -davidc
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-b=
cache" in
> > > the body of a message to majordomo@...
> > > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-inf=
o.html
> >=20
>=20
>=20
> Hi Kent,
>=20
> I am new to bcache and have a question relating to the above.
> Resizing sounds pretty straight forward following the procedure you o=
utlined=20
> above when you are growing the disk.   However, what would happen if =
you wanted=20
> to shrink the backing device and had writeback enabled.
>=20
> We would obviously shrink the filesystem first through the cash so an=
y blocks in=20
> the area beyond the new filesystem boundary that may still be dirty i=
n the cache=20
> would not matter any more.
>=20
> Then we would unregister the backing store and truncate the backing s=
tore block=20
> device before re-registering it.
>=20
> I am wondering if any dirty blocks that are in the cache that are bey=
ond the new=20
> size of the backing device are going to cause a problem?   It does no=
t matter if=20
> they are simply discarded since the filesystem was resized but would =
bcache know=20
> what to do with them or could they cause a crash (or other undesirabl=
e effects)=20
> due to bcache trying to write to blocks that no longer exist on the b=
acking=20
> device?

Hmm, it most likely would.

You could certainly work around it by disabling writeback and waiting
for all the dirty data to be flushed, but this is something that could
be improved.

It'd be fairly straightforward to fix it so background writeback and
garbage collection took into account the current size of the device, bu=
t
to be honest I'm currently swamped with work and I'm not going to have
time to do it myself any time soon.

I'd be happy to help anyone who wanted to work on it, though.
