From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: can't attach caching device to backing device
Date: Mon, 21 Nov 2011 05:54:15 -0800
Message-ID: <20111121135415.GA26333@dhcp-172-18-216-138.mtv.corp.google.com>
References: <8C67A0427441E84B879B0D6058D20D5222410FE6@EXCH-MBX-1.epic.com>
 <CAC7rs0sXfPXY81BpdQhtNMrj--bUeP+VSSqbDMvTYA_DyMRf3g@mail.gmail.com>
 <8C67A0427441E84B879B0D6058D20D5222420EA2@EXCH-MBX-1.epic.com>
 <8C67A0427441E84B879B0D6058D20D5222421068@EXCH-MBX-1.epic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8C67A0427441E84B879B0D6058D20D5222421068-QfgMShIfpGfUFh++4gLpBEEOCMrvLtNR@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org>
Cc: "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Mon, Nov 21, 2011 at 01:51:00PM +0000, Justin Rush wrote:
> Yes, the file does exist.

Hmm. Weird. I'll look at the code and see if I can think of anything.

> Should I try it with the individual devices in the array?

Worth a shot, though caching partitions is well tested.=20

> I don't suppose bcache can play with LVM?

The version I just pushed should now.
>=20
> - Justin
>=20
> -----Original Message-----=20
> From: Kent Overstreet [kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Received: Sunday, 20 Nov 2011, 11:31pm
> To: Justin Rush [jarush-Ub+6UvMsOfg@public.gmane.org]
> CC: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
> Subject: Re: can't attach caching device to backing device
> When you tried to attach the cache, did the file you were echoing to
> exist? That looks correct but I'm not sure what else would generate
> that error.
>=20
> For the UUIDs to show up in blkid, blkid itself would have to be
> updated to know about the bcache superblock (IIRC it lives in
> util-linux). I should probably ping the author and see if that can ge=
t
> included.
>=20
> If you have the udev rules and probe-bcache installed, the symlinks
> /ought/ to show up when you reboot but I haven't tested that in ages.
>=20
> I just got the code written so that it ought to be able to work on to=
p
> of md devices again, which means I should be able to run it at home
> and I'll have to fix probe-bcache if it's broken then :)
>=20
> On Mon, Nov 14, 2011 at 3:10 PM, Justin Rush <jarush-Ub+6UvMsOfg@public.gmane.org> wrote:
> > Using 3.1.0-rc9
> >
> > I created a cache device on /dev/sdk1
> > # ./make-bcache -C -b512k -w4k --writeback /dev/sdk1
> >
> > and a backing device on /dev/md127p1.
> > ./make-bcache -B /dev/md127p1
> >
> > # ./probe-bcache /dev/sdk1
> > 5f42bdd1-4342-4ab6-8dda-855989a09604: UUID=3D"" TYPE=3D"bcache"
> >
> > # ./probe-bcache /dev/md127p1
> > 6bbac9a4-afbd-4d40-9562-cdd290622c5d: UUID=3D"" TYPE=3D"bcache"
> >
> > I then registered them by:
> > # echo /dev/sdk1 >/sys/fs/bcache/register # echo /dev/md127p1 >/sys=
/fs/bcache/register
> >
> > I have /dev/bcache0
> >
> > When I try to attach the cache, I get this:
> > # echo "5f42bdd1-4342-4ab6-8dda-855989a09604" >/sys/block/md127/md1=
27p1/bcache/attach
> > -bash: echo: write error: No such file or directory
> >
> > I believe this problem is due to the UUIDs for the two devices, but=
 this is just a guess. =C2=A0The UUID for /dev/sdk1 and /dev/md127p1 do=
esn't appear to be registering properly as they don't show up in blkid.=
 =C2=A0I tried specifying the UUID to use with the -U option when creat=
ing the devices, but that didn't seem to help. =C2=A0I do have the udev=
 rules file from the tools in place
> >
> > Does anyone know what is going on here and how to fix it?
> >
> > Justin Rush
> > jarush-Ub+6UvMsOfg@public.gmane.org
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bca=
che" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
