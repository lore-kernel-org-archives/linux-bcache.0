From: Roy Sigurd Karlsbakk <roy-ooPBL11mRiZbRRN4PJnoQQ@public.gmane.org>
Subject: Adding caching to existing volumes?
Date: Sat, 19 Jan 2013 19:08:25 +0100 (CET)
Message-ID: <17989056.10.1358618905144.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi all

As far as I can understand from the bcache docs, a volume cached with b=
cache, must be formatted and setup for bcache in the first place. I com=
e from a ZFS environment, where adding SLOG or L2ARC is done dynamicall=
y, so I have a few questions:

- Would it be somewhat possible to add caching to an existing volume an=
d its data?
- What would happen if the cache device dies - does the whole filesyste=
m become inaccessible?


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
