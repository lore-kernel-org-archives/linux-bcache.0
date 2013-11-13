From: Francis Moreau <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache and SSD over provisioning
Date: Wed, 13 Nov 2013 20:51:55 +0100
Message-ID: <5283D85B.10904@gmail.com>
References: <CAC9WiBiuQ2zG6C9XJio-STz-ScnfzzYb+Rz23u6JW+vFni8PNA@mail.gmail.com> <op.w6hq4v0of3gqgg@desktop.patton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <op.w6hq4v0of3gqgg-r49W/1Cwd2cba4AQcYcrVKxOck334EZe@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello Matthew,

Le 13/11/2013 15:13, Matthew Patton a =E9crit :
> On Wed, 13 Nov 2013 03:42:54 -0500, Francis Moreau =20
> <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
>> First I'd like to know if over-provisioning is still needed when
>> bcache is used ?
>=20
> it's needed for any decent, sustained write load if you don't want =20
> performance to crash thru the floor. But it doesn't sound like this i=
s =20
> your use case. Are you sustaining 5000+ write IOPs?
>=20

That's indeed not really required: my system is for a desktop usage.

>>   - Should I create 2 partitions with one left emtpy and whose size =
is
>> roughly 7% of the device size ?
>=20
> Your SSD already has 7% overprovisioning. For best sustained and =20
> consistent write performance you'll want to bump it to 25-30%. Yes yo=
u =20
> just need to partition/LVM down to the desired size.

Hmm, I don't see what makes you think that my SSD has already 7%
overprovisioning ? Actually I don't think it's the case.

Thanks for your help.
