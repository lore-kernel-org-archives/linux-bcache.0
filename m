From: Josep Lladonosa <jlladono@gmail.com>
Subject: Re: bcache and memory at boot. Bug?
Date: Tue, 11 Feb 2014 11:56:49 +0100
Message-ID: <CAPBO7TaS8b4x02sCK8BCK0=1+ScJ+bGa6FWjYeCiaqpoik2cUg@mail.gmail.com>
References: <CAPBO7TbEAf7Bhb-kTFQ00CmBih5CdsXRHeOSf4STxQ+ndy66dQ@mail.gmail.com>
	<ldadrd$4a2$1@ger.gmane.org>
	<CAPBO7TZBgfa2CftYZYv2+dTteyBYJYyXD8vuw7KQNN5xexFjpQ@mail.gmail.com>
	<20140210224648.GC2362@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62705 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKK4v (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 11 Feb 2014 05:56:51 -0500
Received: by mail-oa0-f51.google.com with SMTP id h16so8884564oag.24
        for <linux-bcache@vger.kernel.org>; Tue, 11 Feb 2014 02:56:49 -0800 (PST)
In-Reply-To: <20140210224648.GC2362@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 10 February 2014 23:46, Kent Overstreet <kmo@daterainc.com> wrote:
> On Mon, Feb 10, 2014 at 02:15:14PM +0100, Josep Lladonosa wrote:
>> On 10 February 2014 12:40, Gabriel de Perthuis <g2p.code@gmail.com> wrote:
>> >> Hello,
>> >>
>> >> I am using bcache in my laptop (RAM 32 GiB). I have been using it
>> >> perfectly for a month. ext4 + bcache.
>> >>
>> >> Yesterday, system did not want do to a normal startup. Messages where
>> >> from udev out of memory (and udevadm killed?) and system was not
>> >> mounting / (/dev/bcache0).
>> >>
>> >> [    6.823222] bcache-register invoked oom-killer: gfp_mask=0x82d2,
>> >> order=0, oom_score_adj=0
>> >
>> > Build your kernel with CONFIG_COMPACTION.  I've added it to the FAQ:
>> > http://bcache.evilpiepirate.org/~kent/bcache/FAQ/
>>
>>
>> Hello Gabriel,
>>
>> Thanks for your reply.
>>
>> My .config file has already:
>> ...
>> CONFIG_COMPACTION=y
>
> I looked at the allocations done in bcache_device_init(), those aren't high
> order page allocations (they're vmalloc allocations) so compaction won't help
> here.
>
>> ...
>>
>> I have been digging around to find information and sometimes bugs come
>> related to unsigned variables and their operations when storing large
>> numbers (reserved memory?). Kernel is 64 bits. Memory is 32 GiB.
>> Perhaps it could happen that the allocated memory is not totally
>> freed.
>>
>> When kernel has been able to boot with 32 GiB (having bcache0 messed
>> up and bcache1 mountable), it seems that bcache has more than 16 GiB
>> allocated and kept.
>
> Woah, really? If so that's bad - I don't see how that follows (or am I
> misreading) from your numbers, can you show a before and after when you bring
> bcache up?

What I have done is:

- boot computer in Debian (kernel&bcache-tools ready) from an USB with
the caching device unplugged and backing plugged. Booting O.K. with 32
GiB of RAM.
- plug caching device to external SATA. Bcache detects it, but...
- bcache0 and bcache1 are shown (I could do a fast "ls" for /sys/block).
- After some seconds, system freezes.


I could detach cahing device and remake it and see if the same happens
again, but anyway the cause of this behaviour will still be there.

Josep

>
>>
>> -Free memory with kernel 3.11.0-rc7 with 32GiB and bcache0 (halved?)
>> and bcache1 (mounted)
>>
>> $ head -2 /proc/meminfo
>> MemTotal:       32913872 kB
>> MemFree:        12376640 kB
>>
>>
>> - Free memory with kernel 3.12.9 with mem=16G and bcache0 (mounted)
>>
>> $ head -2 /proc/meminfo
>> MemTotal:       15602144 kB
>> MemFree:        14005372 kB
>>
>>
>>
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> --
>> Salutacions...Josep
>> --
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
--
Salutacions...Josep
--
