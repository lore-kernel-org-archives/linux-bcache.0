From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: btrfs on bcache
Date: Mon, 6 Jan 2014 15:37:04 -0800
Message-ID: <20140106233704.GI9037@kmo>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
 <1387483201.23881.2.camel@ret.masoncoding.com>
 <CABtk0xRbO9BthbOGHGg3cO4H5CZYeDwb_H4gAmspMiKSZMNZtQ@mail.gmail.com>
 <1387554401.9407.0.camel@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38907 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235AbaAFXhH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 6 Jan 2014 18:37:07 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so18747836pdj.2
        for <linux-bcache@vger.kernel.org>; Mon, 06 Jan 2014 15:37:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1387554401.9407.0.camel@ret.masoncoding.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Chris Mason <clm@fb.com>, axboe@kernel.dk
Cc: "fmpfeifer@gmail.com" <fmpfeifer@gmail.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "eab@gmx.ch" <eab@gmx.ch>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Dec 20, 2013 at 03:46:30PM +0000, Chris Mason wrote:
> On Fri, 2013-12-20 at 10:42 -0200, F=C3=A1bio Pfeifer wrote:
> > Hello,
> >=20
> > I put the "WARN_ON(1);" after the printk lines (incomplete page rea=
d
> > and incomplete page write) in extent_io.c.
> >=20
> > here some call traces:
> >=20
> > [   19.509497] incomplete page read in btrfs with offset 2560 and l=
ength 1536
> > [   19.509500] ------------[ cut here ]------------
> > [   19.509528] WARNING: CPU: 2 PID: 220 at fs/btrfs/extent_io.c:244=
1
> > end_bio_extent_readpage+0x788/0xc20 [btrfs]()
> > [   19.509530] Modules linked in: cdc_acm fuse iTCO_wdt
> > iTCO_vendor_support snd_hda_codec_analog coretemp kvm_intel kvm rai=
d1
> > ext4 crc16 md_mod mbcache jbd2 microcode nvidia(PO) psmouse pcspkr
> > evdev serio_raw i2c_i801 lpc_ich i2c_core snd_hda_intel sky2 skge
> > i82975x_edac button asus_atk0110 snd_hda_codec snd_hwdep shpchp
> > snd_pcm snd_page_alloc snd_timer acpi_cpufreq snd edac_core soundco=
re
> > processor vboxdrv(O) sr_mod cdrom ata_generic pata_acpi hid_generic
> > usbhid hid usb_storage sd_mod pata_marvell firewire_ohci uhci_hcd a=
hci
> > ehci_pci firewire_core ata_piix libahci crc_itu_t ehci_hcd libata
> > scsi_mod usbcore usb_common btrfs crc32c libcrc32c xor raid6_pq bca=
che
> > [   19.509578] CPU: 2 PID: 220 Comm: btrfs-endio-met Tainted: P
> > W  O 3.12.5-1-ARCH #1
> > [   19.509580] Hardware name: System manufacturer System Product
> > Name/P5WDG2 WS Pro, BIOS 0905    03/06/2008
> > [   19.509581]  0000000000000009 ffff880231a63cb0 ffffffff814ee37b
> > 0000000000000000
> > [   19.509585]  ffff880231a63ce8 ffffffff81062bcd ffffea00085eaec0
> > 0000000000000000
> > [   19.509587]  ffff8802320cc9c0 0000000000000000 ffff880233b0e000
> > ffff880231a63cf8
> > [   19.509590] Call Trace:
> > [   19.509596]  [<ffffffff814ee37b>] dump_stack+0x54/0x8d
> > [   19.509601]  [<ffffffff81062bcd>] warn_slowpath_common+0x7d/0xa0
> > [   19.509603]  [<ffffffff81062caa>] warn_slowpath_null+0x1a/0x20
> > [   19.509614]  [<ffffffffa00b7ba8>] end_bio_extent_readpage+0x788/=
0xc20 [btrfs]
>=20
> This should mean that bcache is either failing to read some blocks
> properly or is fiddling with the bv_len/bv_offset fields.
>=20
> Could someone from bcache comment?

Oh man, I found this and then threw up my hands in despair.

Bcache isn't doing anything with the bv_len/bv_offset fields; it may cl=
one the
biovec so it can retry a bio on error, if the biovecs weren't all whole=
 pages,
otherwise it just passes the biovec down with the next bio to the under=
lying
cache/backing device.

What btrfs appears to be doing though - I couldn't believe that code ac=
tually
_worked_, Jens please jump in here but AFAIK bv_len/bv_offset are in pr=
actice
undefined after a bio's completed, they might have been updated if the =
driver
was using blk_update_request but for many drivers that just process the=
 entire
bio all at once they just won't touch those fields - and that includes =
anything
that clones the bio (md/dm).

This is probably relevant to immutable biovecs here...

-------------

Ok, I looked again at the relevant btrfs code, I guess I can see how th=
is printk
isn't normally triggered. But Chris, _what on earth_ is btrfs trying to=
 check
for here? And why is it using bv_offset and bv_len further down in
end_bio_extent_readpage()?
