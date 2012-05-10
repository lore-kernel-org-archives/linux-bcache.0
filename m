From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-bcache scatter gather list in bio exceed driver capabilities
Date: Thu, 10 May 2012 03:11:40 -0400
Message-ID: <CAH+dOxLwX0CbcCAdShuEjY6d5Prdi8tN92vtBAAdPT_SJSFbLg@mail.gmail.com>
References: <CAEkKNCcEWVUjmBaGCS5ROMgA-b3fqaWNB=HGZCNshbEgW6impA@mail.gmail.com>
	<CAH+dOxKdMFEa_Yy6WB-ntzaUnBRROrHSP16Tb0f7_jK01u1fLQ@mail.gmail.com>
	<CAEkKNCet2_Ez-9-sMLPuwB-qNXpTapvONwPGOC9ONhM_Cnopew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEkKNCet2_Ez-9-sMLPuwB-qNXpTapvONwPGOC9ONhM_Cnopew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sbradshaw-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

You mean it implements its own make_request function? It'll still have
queue limits - bcache works similarly. They might not be exported in
sysfs though...

I'll have a look at the driver.

On Thu, May 10, 2012 at 2:00 AM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Well, that might be the problem, there is no such entry. =A0The drive=
r is
> basically a fake ahci driver and handles the bios directly. =A0It is =
extremely
> fast and the driver was written for very low latency IO hence the wei=
rd
> driver stack.
>
> http://lxr.linux.no/linux+v3.3.5/drivers/block/mtip32xx/mtip32xx.c#L3=
044.
> =A0The mtip_make_request call fails whenever the number of entries in=
 the SGL
>> 128...
>
> Moussa
>
> On May 9, 2012 6:02 PM, "Kent Overstreet" <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>
>> That sounds like a bug in bcache - bcache should be respecting the
>> queue limits the underlying device exports.
>>
>> Can you tell me what the various files in /sys/block/<device>/queue/
>> look like for your device?
>>
>> On Wed, May 9, 2012 at 8:23 PM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Tried to send this to mailing list but was rejected somehow.
>> >
>> > ---------- Forwarded message ----------
>> > From:=A0moussa ba=A0<musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Date: Wed, May 9, 2012 at 5:17 PM
>> > Subject: Scatter Gather List in bio exceed driver capabilities
>> > To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >
>> >
>> >
>> > We are using a micron PCI-E SSD as a caching device. =A0I am runni=
ng into
>> > issues where the driver would fail when we try to register the cac=
he
>> > device.
>> > =A0The failure is because bcache sends down a bio with 256 entries=
 while
>> > the
>> > device driver can only handle 128 entries. =A0We could make change=
s inside
>> > our
>> > driver to chunk the requests (mind you I did not write the driver,=
 but
>> > driver guys told me so...) and fix it that way. =A0I am assuming t=
hat
>> > since
>> > bcache is creating the bio to get at its metadata, it does not chu=
nk the
>> > bios to fit the underlying hardware nor does it query it in some w=
ay to
>> > set
>> > the bi_vcnt.
>> >
>> > Any suggestions on how to properly address this?
>> >
>> > Moussa
>> >
