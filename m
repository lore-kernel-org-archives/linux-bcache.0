From: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>
Subject: Re: Which Version
Date: Tue, 14 Aug 2012 21:43:30 +0200 (CEST)
Message-ID: <22981767.12.1344973410504.JavaMail.root@zimbra>
References: <6035A0D088A63A46850C3988ED045A4B299F962D@BITCOM1.int.sbss.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6035A0D088A63A46850C3988ED045A4B299F962D-mzsoxcrO4/2UD0RQwgcqbDSf8X3wrgjD@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Harper <james.harper-NMzNsA1hOHcW+bLBXbPJGg@public.gmane.org>
Cc: Jonathan Tripathy <jonnyt-Nf8S+5hNwl710XsdtD+oqA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

> Because I'm layering lvm on bcache on md on sd, I had to tweak the
> initramfs scripts to make things load in the right order, and also yo=
u
> still need to put /boot on something grub understands eg /dev/sdX or
> /dev/mdX. Grub doesn't understand bcache (yet?).

Why would you want bcache to understand your /boot partition? It's hard=
ly in use anyway=E2=80=A6

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
