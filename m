From: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>
Subject: Re: Adding caching to existing volumes?
Date: Wed, 23 Jan 2013 18:17:44 +0100 (CET)
Message-ID: <12410785.14.1358961464521.JavaMail.root@zimbra>
References: <20130122231547.GF26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130122231547.GF26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Haigh <netwiz-tY1ak9Q0PTWHXe+LvDLADg@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

> You've got to start from scratch, unfortunately.
>=20
> The reason is that there needs to be a bcache specific superblock on
> the
> backing device so bcache can keep the cache and backing device in syn=
c
> -
> and especially so you can't accidentally mount and use the backing
> device without the cache. That would be bad.
>=20
> I just added an explanation to the faq - thanks for pointing it out.
> http://bcache.evilpiepirate.org/FAQ

Then, what happens when the SSD dies?

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
