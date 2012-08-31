From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-bcache scatter gather list in bio exceed driver capabilities
Date: Fri, 31 Aug 2012 09:43:37 -0700
Message-ID: <CAH+dOxKFWdqEb-OmeWexDA-N7Avo6q0=rtA9wnd5s-=5Hi6-TA@mail.gmail.com>
References: <CAEkKNCcEWVUjmBaGCS5ROMgA-b3fqaWNB=HGZCNshbEgW6impA@mail.gmail.com>
	<CAH+dOxKdMFEa_Yy6WB-ntzaUnBRROrHSP16Tb0f7_jK01u1fLQ@mail.gmail.com>
	<CAEkKNCet2_Ez-9-sMLPuwB-qNXpTapvONwPGOC9ONhM_Cnopew@mail.gmail.com>
	<CAH+dOxLwX0CbcCAdShuEjY6d5Prdi8tN92vtBAAdPT_SJSFbLg@mail.gmail.com>
	<CAEkKNCfYjq7OGQw16Z47db_tw3vpcOrzdAkgZh9OM0BR_LL5Bg@mail.gmail.com>
	<CAH+dOxLFY4XJNZ8LO2o1zJhoqRwioWeSG6N=Umstjsw2PYwdCw@mail.gmail.com>
	<CAEkKNCdwfa1_g8OvnuwROWOhmmUjSyz=WBdD9qEg74D8tGTTcw@mail.gmail.com>
	<CAEkKNCd93-P+TXOR+Ru0ti=eorrq3c-1Pjy_0kRC4wG25qR3BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEkKNCd93-P+TXOR+Ru0ti=eorrq3c-1Pjy_0kRC4wG25qR3BQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Try the latest bcache-3.2 branch

On Thu, Aug 30, 2012 at 11:28 PM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Ken,
>
> I only recently got a change to try bcache-dev.  Unfortunately bcache
> fails to properly set the queue_max_sectors for our device which is
> 128, but bcache sends down 256 entries.
>
> I am on commit 8e8551e1060dc1286252266c6021d8d7d83c9720
>
> Moussa
>
> On Mon, May 14, 2012 at 6:17 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Thanks. Think I fixed the bug - I'd have to check, but I think what
>> happened is queue_max_sectors() also took into account
>> queue_max_sectors() in older kernels, but doesn't in newer kernels. Or
>> maybe just my code was always broken.
>>
>> Anyways, the bcache-3.3-dev branch should work.
>>
>> On Thu, May 10, 2012 at 11:38 AM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Kent,
>> >
>> > Apologies, we do have the queue entries available, I ran into some issues
>> > with the driver while trying to report them:
>> >
>> > add_random: 0
>> > discard_granularity: 0
>> > discard_max_bytes: 0
>> > discard_zeroes_data: 0
>> > hw_sector_size: 512
>> > iostats: 0
>> > logical_block_size: 512
>> > max_hw_sectors_kb: 32767
>> > max_integrity_segments: 0
>> > max_sectors_kb: 32767
>> > max_segments: 128
>> > max_segment_size: 4194304
>> > minimum_io_size: 4096
>> > nomerges: 2
>> > nr_requests: 255
>> > optimal_io_size: 0
>> > physical_block_size: 4096
>> > read_ahead_kb: 128
>> > rotational: 0
>> > rq_affinity: 0
>> > scheduler: none
>> >
>> >
>> >
>> > On Thu, May 10, 2012 at 12:11 AM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > wrote:
>> >>
>> >> You mean it implements its own make_request function? It'll still have
>> >> queue limits - bcache works similarly. They might not be exported in
>> >> sysfs though...
>> >>
>> >> I'll have a look at the driver.
>> >>
>> >> On Thu, May 10, 2012 at 2:00 AM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> > Well, that might be the problem, there is no such entry.  The driver is
>> >> > basically a fake ahci driver and handles the bios directly.  It is
>> >> > extremely
>> >> > fast and the driver was written for very low latency IO hence the weird
>> >> > driver stack.
>> >> >
>> >> >
>> >> > http://lxr.linux.no/linux+v3.3.5/drivers/block/mtip32xx/mtip32xx.c#L3044.
>> >> >  The mtip_make_request call fails whenever the number of entries in the
>> >> > SGL
>> >> >> 128...
>> >> >
>> >> > Moussa
>> >> >
>> >> > On May 9, 2012 6:02 PM, "Kent Overstreet" <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> >> > wrote:
>> >> >>
>> >> >> That sounds like a bug in bcache - bcache should be respecting the
>> >> >> queue limits the underlying device exports.
>> >> >>
>> >> >> Can you tell me what the various files in /sys/block/<device>/queue/
>> >> >> look like for your device?
>> >> >>
>> >> >> On Wed, May 9, 2012 at 8:23 PM, moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >> > Tried to send this to mailing list but was rejected somehow.
>> >> >> >
>> >> >> > ---------- Forwarded message ----------
>> >> >> > From: moussa ba <musaba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> >> > Date: Wed, May 9, 2012 at 5:17 PM
>> >> >> > Subject: Scatter Gather List in bio exceed driver capabilities
>> >> >> > To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> >> >
>> >> >> >
>> >> >> >
>> >> >> > We are using a micron PCI-E SSD as a caching device.  I am running
>> >> >> > into
>> >> >> > issues where the driver would fail when we try to register the cache
>> >> >> > device.
>> >> >> >  The failure is because bcache sends down a bio with 256 entries
>> >> >> > while
>> >> >> > the
>> >> >> > device driver can only handle 128 entries.  We could make changes
>> >> >> > inside
>> >> >> > our
>> >> >> > driver to chunk the requests (mind you I did not write the driver,
>> >> >> > but
>> >> >> > driver guys told me so...) and fix it that way.  I am assuming that
>> >> >> > since
>> >> >> > bcache is creating the bio to get at its metadata, it does not chunk
>> >> >> > the
>> >> >> > bios to fit the underlying hardware nor does it query it in some way
>> >> >> > to
>> >> >> > set
>> >> >> > the bi_vcnt.
>> >> >> >
>> >> >> > Any suggestions on how to properly address this?
>> >> >> >
>> >> >> > Moussa
>> >> >> >
>> >
>> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
