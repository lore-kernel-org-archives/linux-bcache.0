From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: Error after filling up fileystem (resend to correct email)
Date: Tue, 29 Mar 2016 14:38:43 +0200
Message-ID: <56FA7753.5060806@mejor.pl>
References: <56FA5BD7.1060405@mejor.pl> <20160329111747.GA11536@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:52406 "EHLO jowisz.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbcC2Mjn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Mar 2016 08:39:43 -0400
In-Reply-To: <20160329111747.GA11536@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 29.03.2016 o 13:17, Kent Overstreet pisze:
> On Tue, Mar 29, 2016 at 12:41:27PM +0200, Marcin Miros=C5=82aw wrote:
>> Hi!
>>
>> Because I don't know what features should work I think it's better t=
o
>> report a bug than do nothing.
>> I created fs, mounted, then I changed compression (via sysfs) to lz4=
=2E
>> Next I copied portage tree to filesystem. Then I started to think wh=
y
>> "compression_stats" shows that data are compressed but `df` shows va=
lues
>> that looks like data are uncompressed:
>> cat compression_stats
>> uncompressed data:
>>         nr extents:                     1976
>>         size (bytes):                   1784832
>> compressed data:
>>         nr extents:                     282264
>>         compressed size (bytes):        346365952
>>         uncompressed size (bytes):      6398948352
>=20
> Yeah, I don't have the code yet to distinguish between compressed/unc=
ompressed
> size in the various usage stuff. It's coming.

Ok, thanks for info.


>> df -h:
>> Filesystem                          Size  Used Avail Use% Mounted on
>> /dev/mapper/system10-bcacheportage  4.0G  4.0G   82M  99% /usr/porta=
ge
>>
>> So I started to create file filled with zeroes: `dd if=3D/dev/zero
>> of=3D/path/file bs=3D1M". I filled up filesystem. Then I run `emerge=
` and I
>> got I/O error. In dmesg I see:
>>
>> [ 4466.898819] kworker/u8:0: page allocation failure: order:4,
>> mode:0x2404000
>=20
> The lz4 code is unfinished - as you can see it doesn't gracefully han=
dle memory
> allocation failures yet. The gzip compression code does handle alloca=
tion
> failures, but won't get as good a compression ratio (because it's doi=
ng the
> compression in smaller chunks).
>=20
> At some point I need to dig into the lz4 code and come up with a vers=
ion that
> doesn't require contiguous buffers, but that's going to be difficult.
>=20
>> Accesing this file with zeroes throws I/O error, it looks that other
>> files are accesible. After removing this file with zeroes free space=
 is
>> not returned.
>=20
> Odd.. probably something to do with how the pagecache handles IO erro=
rs, I'm
> guessing.

When I did test with filling up free space and I didn't had I/O error
then free space was calculated correctly.


> You should have been able to still read the data later (after clearin=
g the error
> in the pagecache somehow, a drop_caches might do it).
>=20
> I'll bump the lz4 stuff higher up on the list, I want to use it mysel=
f.


Great! gzip is slow for me (at least used with zfs).

Thanks,
Marcin
