From: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>
Subject: Re: bcache vs enhanceio?
Date: Tue, 12 Feb 2013 21:41:20 +0100 (CET)
Message-ID: <23363144.24.1360701679980.JavaMail.root@zimbra>
References: <5114334D.7040709@networklabs.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5114334D.7040709-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Thrift <andrew-3e6jenk95VYpDvLZ8AWkcaVXKuFTiq87@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Wouldn't it be better to allow the sysadmin to determine the safety?
Also, if running in writethrough, why shouldn't an SSD be allowed to be=
 added in realtime?
All of this works well with systems like ZFS. I really don't see a reas=
on for a filesystem being created to allow caching

roy

----- Opprinnelig melding -----
> Hi Roy,
>=20
> This is by design, and minimizes the potential for data corruption.
>=20
> If you have a backing device with an existing filesystem, and are
> caching this in writeback mode, then reboot the system and the cache
> device does not come up, the backing device could still come up and
> could potentially be out of sync with the writes that were buffered t=
o
> the cache device.
>=20
> With bcache in writeback mode, if it cannot attach the cache device i=
t
> will not register the backing device.
>=20
>=20
> I am sure Kent will provide a much better answer than I have :)
>=20
>=20
>=20
>=20
> Regards,
>=20
>=20
>=20
>=20
> Andrew
>=20
> On 2/8/2013 10:25 AM, Roy Sigurd Karlsbakk wrote:
> > Hi
> >
> > Seems old flashcache and the new enhanceio can add flash drives on
> > the run, while bcache needs the filsystem to be built with them.
> >
> > What is the future of bcache in this setting?
> >

--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
