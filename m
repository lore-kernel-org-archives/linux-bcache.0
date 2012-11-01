From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: Re: Resizing bcache backing store
Date: Thu, 1 Nov 2012 19:06:01 +0000 (UTC)
Message-ID: <loom.20121101T195722-160@post.gmane.org>
References: <CAB7K1hH_o7koST7RYTbw9ya0GMEvmpb=TYAt1MqEVDhtBdRd1Q@mail.gmail.com> <CAH+dOxJv-ajvLfbUSo8dqG0a8_grNBhfxJ1EbmSrYZz0YXJM2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Kent Overstreet <koverstreet@...> writes:

>=20
> For the backing device, I think things will just work - you'll just
> have to close and reopen the backing device in order for bcache to
> notice the new size. Bcache's superblock doesn't remember the size, i=
t
> just goes off of what the size of the backing device is when it's
> registered.
>=20
> There's currently no way to make bcache notice the backing device has
> grown to do it at runtime, though that ought to be fairly simple too.
>=20
> On Wed, Apr 11, 2012 at 6:47 PM, David Rhodes Clymer
> <david@...> wrote:
> > In the case where the bcache backing store is resizeable (eg. a
> > logical volume), is it possible to resize the backing store without
> > breaking bcache? Let's say, for example, that I would
> > unmount/unregister /dev/bcacheX, resize the backing store,
> > reregister/remount the cache.
> >
> > I imagine a better approach would be to layer LVM on the cache devi=
ce
> > itself. However, in this particular case, I set up the bcache befor=
e I
> > had learned how to get LVM to use a bcache device as a PV.
> >
> > -davidc
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bca=
che" in
> > the body of a message to majordomo@...
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>=20


Hi Kent,

I am new to bcache and have a question relating to the above.
Resizing sounds pretty straight forward following the procedure you out=
lined=20
above when you are growing the disk.   However, what would happen if yo=
u wanted=20
to shrink the backing device and had writeback enabled.

We would obviously shrink the filesystem first through the cash so any =
blocks in=20
the area beyond the new filesystem boundary that may still be dirty in =
the cache=20
would not matter any more.

Then we would unregister the backing store and truncate the backing sto=
re block=20
device before re-registering it.

I am wondering if any dirty blocks that are in the cache that are beyon=
d the new=20
size of the backing device are going to cause a problem?   It does not =
matter if=20
they are simply discarded since the filesystem was resized but would bc=
ache know=20
what to do with them or could they cause a crash (or other undesirable =
effects)=20
due to bcache trying to write to blocks that no longer exist on the bac=
king=20
device?

I hope that makes sense.

Many thanks,

James
