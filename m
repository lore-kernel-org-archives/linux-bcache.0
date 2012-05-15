From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-bcache scatter gather list in bio exceed driver capabilities
Date: Mon, 14 May 2012 18:17:51 -0700
Message-ID: <CAH+dOxLFY4XJNZ8LO2o1zJhoqRwioWeSG6N=Umstjsw2PYwdCw@mail.gmail.com>
References: <CAEkKNCcEWVUjmBaGCS5ROMgA-b3fqaWNB=HGZCNshbEgW6impA@mail.gmail.com>
	<CAH+dOxKdMFEa_Yy6WB-ntzaUnBRROrHSP16Tb0f7_jK01u1fLQ@mail.gmail.com>
	<CAEkKNCet2_Ez-9-sMLPuwB-qNXpTapvONwPGOC9ONhM_Cnopew@mail.gmail.com>
	<CAH+dOxLwX0CbcCAdShuEjY6d5Prdi8tN92vtBAAdPT_SJSFbLg@mail.gmail.com>
	<CAEkKNCfYjq7OGQw16Z47db_tw3vpcOrzdAkgZh9OM0BR_LL5Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEkKNCfYjq7OGQw16Z47db_tw3vpcOrzdAkgZh9OM0BR_LL5Bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Thanks. Think I fixed the bug - I'd have to check, but I think what
happened is queue_max_sectors() also took into account
queue_max_sectors() in older kernels, but doesn't in newer kernels. Or
maybe just my code was always broken.

Anyways, the bcache-3.3-dev branch should work.

On Thu, May 10, 2012 at 11:38 AM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Kent,
>
> Apologies, we do have the queue entries available, I ran into some is=
sues
> with the driver while trying to report them:
>
> add_random: 0
> discard_granularity: 0
> discard_max_bytes: 0
> discard_zeroes_data: 0
> hw_sector_size: 512
> iostats: 0
> logical_block_size: 512
> max_hw_sectors_kb: 32767
> max_integrity_segments: 0
> max_sectors_kb: 32767
> max_segments: 128
> max_segment_size: 4194304
> minimum_io_size: 4096
> nomerges: 2
> nr_requests: 255
> optimal_io_size: 0
> physical_block_size: 4096
> read_ahead_kb: 128
> rotational: 0
> rq_affinity: 0
> scheduler: none
>
>
>
> On Thu, May 10, 2012 at 12:11 AM, Kent Overstreet <koverstreet@google=
=2Ecom>
> wrote:
>>
>> You mean it implements its own make_request function? It'll still ha=
ve
>> queue limits - bcache works similarly. They might not be exported in
>> sysfs though...
>>
>> I'll have a look at the driver.
>>
>> On Thu, May 10, 2012 at 2:00 AM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Well, that might be the problem, there is no such entry. =A0The dr=
iver is
>> > basically a fake ahci driver and handles the bios directly. =A0It =
is
>> > extremely
>> > fast and the driver was written for very low latency IO hence the =
weird
>> > driver stack.
>> >
>> >
>> > http://lxr.linux.no/linux+v3.3.5/drivers/block/mtip32xx/mtip32xx.c=
#L3044.
>> > =A0The mtip_make_request call fails whenever the number of entries=
 in the
>> > SGL
>> >> 128...
>> >
>> > Moussa
>> >
>> > On May 9, 2012 6:02 PM, "Kent Overstreet" <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > wrote:
>> >>
>> >> That sounds like a bug in bcache - bcache should be respecting th=
e
>> >> queue limits the underlying device exports.
>> >>
>> >> Can you tell me what the various files in /sys/block/<device>/que=
ue/
>> >> look like for your device?
>> >>
>> >> On Wed, May 9, 2012 at 8:23 PM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>> >> > Tried to send this to mailing list but was rejected somehow.
>> >> >
>> >> > ---------- Forwarded message ----------
>> >> > From:=A0moussa ba=A0<musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> > Date: Wed, May 9, 2012 at 5:17 PM
>> >> > Subject: Scatter Gather List in bio exceed driver capabilities
>> >> > To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> >
>> >> >
>> >> >
>> >> > We are using a micron PCI-E SSD as a caching device. =A0I am ru=
nning
>> >> > into
>> >> > issues where the driver would fail when we try to register the =
cache
>> >> > device.
>> >> > =A0The failure is because bcache sends down a bio with 256 entr=
ies
>> >> > while
>> >> > the
>> >> > device driver can only handle 128 entries. =A0We could make cha=
nges
>> >> > inside
>> >> > our
>> >> > driver to chunk the requests (mind you I did not write the driv=
er,
>> >> > but
>> >> > driver guys told me so...) and fix it that way. =A0I am assumin=
g that
>> >> > since
>> >> > bcache is creating the bio to get at its metadata, it does not =
chunk
>> >> > the
>> >> > bios to fit the underlying hardware nor does it query it in som=
e way
>> >> > to
>> >> > set
>> >> > the bi_vcnt.
>> >> >
>> >> > Any suggestions on how to properly address this?
>> >> >
>> >> > Moussa
>> >> >
>
>
