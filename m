From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Error after filling up fileystem (resend to correct email)
Date: Tue, 29 Mar 2016 03:17:47 -0800
Message-ID: <20160329111747.GA11536@kmo-pixel>
References: <56FA5BD7.1060405@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34813 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbcC2LRv (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Mar 2016 07:17:51 -0400
Received: by mail-pf0-f181.google.com with SMTP id x3so12054599pfb.1
        for <linux-bcache@vger.kernel.org>; Tue, 29 Mar 2016 04:17:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56FA5BD7.1060405@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Mar 29, 2016 at 12:41:27PM +0200, Marcin Miros=C5=82aw wrote:
> Hi!
>=20
> Because I don't know what features should work I think it's better to
> report a bug than do nothing.
> I created fs, mounted, then I changed compression (via sysfs) to lz4.
> Next I copied portage tree to filesystem. Then I started to think why
> "compression_stats" shows that data are compressed but `df` shows val=
ues
> that looks like data are uncompressed:
> cat compression_stats
> uncompressed data:
>         nr extents:                     1976
>         size (bytes):                   1784832
> compressed data:
>         nr extents:                     282264
>         compressed size (bytes):        346365952
>         uncompressed size (bytes):      6398948352

Yeah, I don't have the code yet to distinguish between compressed/uncom=
pressed
size in the various usage stuff. It's coming.

> df -h:
> Filesystem                          Size  Used Avail Use% Mounted on
> /dev/mapper/system10-bcacheportage  4.0G  4.0G   82M  99% /usr/portag=
e
>=20
> So I started to create file filled with zeroes: `dd if=3D/dev/zero
> of=3D/path/file bs=3D1M". I filled up filesystem. Then I run `emerge`=
 and I
> got I/O error. In dmesg I see:
>=20
> [ 4466.898819] kworker/u8:0: page allocation failure: order:4,
> mode:0x2404000

The lz4 code is unfinished - as you can see it doesn't gracefully handl=
e memory
allocation failures yet. The gzip compression code does handle allocati=
on
failures, but won't get as good a compression ratio (because it's doing=
 the
compression in smaller chunks).

At some point I need to dig into the lz4 code and come up with a versio=
n that
doesn't require contiguous buffers, but that's going to be difficult.

> Accesing this file with zeroes throws I/O error, it looks that other
> files are accesible. After removing this file with zeroes free space =
is
> not returned.

Odd.. probably something to do with how the pagecache handles IO errors=
, I'm
guessing.

You should have been able to still read the data later (after clearing =
the error
in the pagecache somehow, a drop_caches might do it).

I'll bump the lz4 stuff higher up on the list, I want to use it myself.
