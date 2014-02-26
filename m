From: Juan Antonio Martinez <jantonio@dit.upm.es>
Subject: Re: bcache on NBD block devices
Date: Wed, 26 Feb 2014 11:18:37 +0100
Message-ID: <1393409917.17548.21.camel@jonsy>
References: <CAECXXi68Q=5aXQ_NnubkMNsGxPPefCiz77pnYthNU-Jk88qQeg@mail.gmail.com>
	 <1393403510.17548.15.camel@jonsy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.dit.upm.es ([138.4.2.7]:37289 "EHLO mail.dit.upm.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaBZKSz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 26 Feb 2014 05:18:55 -0500
In-Reply-To: <1393403510.17548.15.camel@jonsy>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: nbd-general@lists.sourceforge.net
Cc: linux-bcache@vger.kernel.org

I answer mySelf: exporting NBD image file in copy-on-write mode, and
starting several clients at the same time I can see that diff file is
only 4096 bytes long ( the size of backing device bcache superblock) an=
d
seems not to increase size. So I can continue working with bcache :-)

Thanks for your time. Cheers
Juan Antonio

El mi=C3=A9, 26-02-2014 a las 09:31 +0100, Juan Antonio Martinez escrib=
i=C3=B3:
> El mar, 25-02-2014 a las 11:37 -0500, Paul Clements escribi=C3=B3:
> > On Tue, Feb 25, 2014 at 9:40 AM, Juan Antonio Martinez
> > <jantonio@dit.upm.es> wrote:
> > > Hi all
> > > (This is my first post on this list. I'm still a novice on bcache=
 and
> > > proper nettiquete on this list, so apologize for my mistakes)
> > > Scenario: several NBD LTSP Fat Clients on (a bit) obsolete hardwa=
re
> > > kernel 3.11.0-15 on Ubuntu 13.10
> > > /dev/sda1 as local cache device
> > > /dev/nbd1 as remote NBD backing bcache device
> > > - I've created and registered /dev/sda1 as cache device without p=
roblems
> > > - To create nbd file to be exported I've typed following sequence=
:
> > > # create an empty file
> > > root# dd if=3D/dev/zero of=3Dbcache_test.img bs=3D1M count=3D64
> > > # use it as loop block device
> > > root# losetup /dev/loop0
> > > # make it a backing bcache device
> > > root# make-bcache -B /dev/loop0
>=20
> > have you tried doing this step from the client machine instead, i.e=
=2E:
> > make-bache -B /dev/nbd1
> > after the nbd connection is up? does that work?
>=20
> Just tested: works fine.... but only in the LTSP client where I did t=
he
> changes, and had to tell nbd-server to export imagefile in read-write
> mode
>=20
> Remember that my configuration consist in several (>250!) LTSP-NBD
> clients sharing _the_same_ mounted squashfs image file. I cannot for
> obious reasons make the image file to be shared read-write on every
> clients at the same time... and seems that bcache needs write access =
to
> the backing block device to work
>=20
> =C2=BFIs this correct? If so, bcache is not for me :-( =C2=BFAny alte=
rnatives?=20
>=20
> Perhaps I coult try to create bcache'd image file, and then modify NB=
D
> server permissions to export in copy-on-write-mode... but this would
> work if bcache only writes in bcache superblock ( my image files are
> typically 8Gb size each) as this will create one cow file per client =
on
> server
>=20
> Cheers
> Juan Antonio
