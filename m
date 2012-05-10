From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-bcache scatter gather list in bio exceed driver capabilities
Date: Wed, 9 May 2012 21:02:36 -0400
Message-ID: <CAH+dOxKdMFEa_Yy6WB-ntzaUnBRROrHSP16Tb0f7_jK01u1fLQ@mail.gmail.com>
References: <CAEkKNCcEWVUjmBaGCS5ROMgA-b3fqaWNB=HGZCNshbEgW6impA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEkKNCcEWVUjmBaGCS5ROMgA-b3fqaWNB=HGZCNshbEgW6impA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

That sounds like a bug in bcache - bcache should be respecting the
queue limits the underlying device exports.

Can you tell me what the various files in /sys/block/<device>/queue/
look like for your device?

On Wed, May 9, 2012 at 8:23 PM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Tried to send this to mailing list but was rejected somehow.
>
> ---------- Forwarded message ----------
> From:=A0moussa ba=A0<musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Wed, May 9, 2012 at 5:17 PM
> Subject: Scatter Gather List in bio exceed driver capabilities
> To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
>
>
> We are using a micron PCI-E SSD as a caching device. =A0I am running =
into
> issues where the driver would fail when we try to register the cache =
device.
> =A0The failure is because bcache sends down a bio with 256 entries wh=
ile the
> device driver can only handle 128 entries. =A0We could make changes i=
nside our
> driver to chunk the requests (mind you I did not write the driver, bu=
t
> driver guys told me so...) and fix it that way. =A0I am assuming that=
 since
> bcache is creating the bio to get at its metadata, it does not chunk =
the
> bios to fit the underlying hardware nor does it query it in some way =
to set
> the bi_vcnt.
>
> Any suggestions on how to properly address this?
>
> Moussa
>
