From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache not works?
Date: Wed, 16 Oct 2013 23:07:10 +0200
Message-ID: <525EFFFE.7060901@gmail.com>
References: <CACaajQueWka6dA3g-Uv7Asz9KhgX9nJ_sjd8bNRo2Y2iU-73jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQueWka6dA3g-Uv7Asz9KhgX9nJ_sjd8bNRo2Y2iU-73jA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Le 16/10/2013 06:22, Vasiliy Tolstov a =C3=A9crit :
> I have this setup:
> /dev/md127 - raid1 with one sata 3Tb drive
> /dev/sdb SSD disk with 240 Gb
>=20
> I'm succeseful create bcache0 device and format it to ext4.
>=20
> /dev/bcache0 /var/lib/libvirt/images ext4
> rw,relatime,journal_checksum,journal_async_commit,errors=3Dremount-ro=
,min_batch_time=3D15000,max_batch_time=3D60000,data=3Dordered
> 0 0
>=20
> After that i'm install kvm virtual machine and tries to create some
> activity via iozone fio and other. But stats says nothing.
>=20
> What i miss?

Maybe the cache isn't attached to the backing device?

If you initialise both with the same make-bcache call they are
immediately attached, otherwise you need to connect them:

http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache=
=2Etxt?h=3Dbcache-dev#n80
