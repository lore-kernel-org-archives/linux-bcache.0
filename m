From: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: bcache and SSD over provisioning
Date: Wed, 13 Nov 2013 14:30:44 -0800
Message-ID: <l60uia$5ua$1@ger.gmane.org>
References: <CAC9WiBiuQ2zG6C9XJio-STz-ScnfzzYb+Rz23u6JW+vFni8PNA@mail.gmail.com> <op.w6hq4v0of3gqgg@desktop.patton.net> <5283D85B.10904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

=46rancis Moreau wrote:

> Hello Matthew,
>=20
> Le 13/11/2013 15:13, Matthew Patton a =C3=A9crit :
>> On Wed, 13 Nov 2013 03:42:54 -0500, Francis Moreau
>> <francis.moro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>=20
>>> First I'd like to know if over-provisioning is still needed when
>>> bcache is used ?
>>=20
>> it's needed for any decent, sustained write load if you don't want
>> performance to crash thru the floor. But it doesn't sound like this =
is
>> your use case. Are you sustaining 5000+ write IOPs?
>>=20
>=20
> That's indeed not really required: my system is for a desktop usage.
>=20
>>>   - Should I create 2 partitions with one left emtpy and whose size=
 is
>>> roughly 7% of the device size ?
>>=20
>> Your SSD already has 7% overprovisioning. For best sustained and
>> consistent write performance you'll want to bump it to 25-30%. Yes y=
ou
>> just need to partition/LVM down to the desired size.
>=20
> Hmm, I don't see what makes you think that my SSD has already 7%
> overprovisioning ? Actually I don't think it's the case.
>=20
> Thanks for your help.

Because the raw flash chips are only available in power-of-two sizes. T=
he=20
available storage the controller allows access to is 120GB, and it's=20
reserved 8GB for overprovisioning if I'm looking at the right model.
