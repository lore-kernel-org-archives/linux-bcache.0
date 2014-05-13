From: Slava Pestov <sp@datera.io>
Subject: Re: bcache: btree_split() couldn't split
Date: Tue, 13 May 2014 10:14:27 -0700
Message-ID: <CACHGV4+_Ev_=ZY+Tx+fguzB3C4QUYVb_sd5ixC=pCKXhiUvw7A@mail.gmail.com>
References: <58691644935d03855d2edb9c71c6dfb0@indianin.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:42784 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaEMRO2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 13 May 2014 13:14:28 -0400
Received: by mail-oa0-f45.google.com with SMTP id l6so766722oag.18
        for <linux-bcache@vger.kernel.org>; Tue, 13 May 2014 10:14:27 -0700 (PDT)
In-Reply-To: <58691644935d03855d2edb9c71c6dfb0@indianin.eu.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Mariusz Paradowski <indianin@indianin.net>
Cc: linux-bcache@vger.kernel.org

Hi Zhe and Mariusz,

Based on my understanding of the code, this problem only occurs with
3.14 and older kernels. I believe Kent fixed this bug in v3.15-rc1
with this patch:

commit 0a63b66db566cffdf90182eb6e66fdd4d0479e63
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Mon Mar 17 17:15:53 2014 -0700

    bcache: Rework btree cache reserve handling

    This changes the bucket allocation reserves to use _real_ reserves
- separate
    freelists - instead of watermarks, which if nothing else makes the
current code
    saner to reason about and is going to be important in the future when we add
    support for multiple btrees.

    It also adds btree_check_reserve(), which checks (and locks) the
reserves for
    both bucket allocation and memory allocation for btree nodes; the
old code just
    kinda sorta assumed that since (e.g. for btree node splits) it had the root
    locked and that meant no other threads could try to make use of the same
    reserve; this technically should have been ok for memory
allocation (we should
    always have a reserve for memory allocation (the btree node cache
is used as a
    reserve and we preallocate it)), but multiple btrees will mean
that locking the
    root won't be sufficient anymore, and for the bucket allocation
reserve it was
    technically possible for the old code to deadlock.

    Signed-off-by: Kent Overstreet <kmo@daterainc.com>

On Mon, May 12, 2014 at 4:53 AM, Mariusz Paradowski
<indianin@indianin.net> wrote:
> Confirmed on kernel 3.14.3 from kernel.org:
>
> May 11 17:43:16 x kernel: ------------[ cut here ]------------
> May 11 17:43:16 x kernel: WARNING: CPU: 3 PID: 376101 at
> drivers/md/bcache/btree.c:1979 0xffffffffa00d65ab()
> May 11 17:43:16 x kernel: bcache: btree split failed
> May 11 17:43:16 x kernel: Modules linked in: e1000e ptp pps_core microcode
> firmware_class unix mpt2sas raid_class scsi_transport_sas bcache fuse
> hid_generic usbhid hid xhci_hcd ehci_pci ehci_hcd usbcore usb_common msr
> cpuid
> May 11 17:43:16 x kernel: CPU: 3 PID: 376101 Comm: kworker/3:2 Not tainted
> 3.14.3 #1
> May 11 17:43:16 x kernel: Hardware name:                  /DH87MC, BIOS
> MCH8710H.86A.0047.2013.0606.1508 06/06/2013
> May 11 17:43:16 x kernel: Workqueue: events 0xffffffffa00e8fa0
> May 11 17:43:16 x kernel: 0000000000000009 ffffffff81303a63 ffff88040c24b988
> ffffffff8104c2fd
> May 11 17:43:16 x kernel: ffff8801056f2400 ffff88040c24b9d8 ffff88040c24ba00
> ffff88040c24bd10
> May 11 17:43:16 x kernel: ffffffffffffffe4 ffffffff8104c367 ffffffffa00ea33b
> ffff880400000018
> May 11 17:43:16 x kernel: Call Trace:
> May 11 17:43:16 x kernel: [<ffffffff81303a63>] ? 0xffffffff81303a63
> May 11 17:43:16 x kernel: [<ffffffff8104c2fd>] ? 0xffffffff8104c2fd
> May 11 17:43:16 x kernel: [<ffffffff8104c367>] ? 0xffffffff8104c367
> May 11 17:43:16 x kernel: [<ffffffffa00d65ab>] ? 0xffffffffa00d65ab
> May 11 17:43:16 x kernel: [<ffffffff810752c3>] ? 0xffffffff810752c3
> May 11 17:43:16 x kernel: [<ffffffffa00d669d>] ? 0xffffffffa00d669d
> May 11 17:43:16 x kernel: [<ffffffffa00d7520>] ? 0xffffffffa00d7520
> May 11 17:43:16 x kernel: [<ffffffffa00d753b>] ? 0xffffffffa00d753b
> May 11 17:43:16 x kernel: [<ffffffffa00d4bce>] ? 0xffffffffa00d4bce
> May 11 17:43:16 x kernel: [<ffffffffa00d12a9>] ? 0xffffffffa00d12a9
> May 11 17:43:16 x kernel: [<ffffffffa00d4975>] ? 0xffffffffa00d4975
> May 11 17:43:16 x kernel: [<ffffffffa00d7520>] ? 0xffffffffa00d7520
> May 11 17:43:16 x kernel: [<ffffffffa00d4c65>] ? 0xffffffffa00d4c65
> May 11 17:43:16 x kernel: [<ffffffff811bc9c4>] ? 0xffffffff811bc9c4
> May 11 17:43:16 x kernel: [<ffffffffa00d7d2c>] ? 0xffffffffa00d7d2c
> May 11 17:43:16 x kernel: [<ffffffffa00d7520>] ? 0xffffffffa00d7520
> May 11 17:43:16 x kernel: [<ffffffffa00d7e98>] ? 0xffffffffa00d7e98
> May 11 17:43:16 x kernel: [<ffffffff81079110>] ? 0xffffffff81079110
> May 11 17:43:16 x kernel: [<ffffffffa00e914a>] ? 0xffffffffa00e914a
> May 11 17:43:16 x kernel: [<ffffffff81054cb1>] ? 0xffffffff81054cb1
> May 11 17:43:16 x kernel: [<ffffffff81054b9d>] ? 0xffffffff81054b9d
> May 11 17:43:16 x kernel: [<ffffffff81054eaf>] ? 0xffffffff81054eaf
> May 11 17:43:16 x kernel: [<ffffffff8105e9a1>] ? 0xffffffff8105e9a1
> May 11 17:43:16 x kernel: [<ffffffff8105c9f3>] ? 0xffffffff8105c9f3
> May 11 17:43:16 x kernel: [<ffffffff8105f566>] ? 0xffffffff8105f566
> May 11 17:43:16 x kernel: [<ffffffff8105f450>] ? 0xffffffff8105f450
> May 11 17:43:16 x kernel: [<ffffffff81064621>] ? 0xffffffff81064621
> May 11 17:43:16 x kernel: [<ffffffff81064560>] ? 0xffffffff81064560
> May 11 17:43:16 x kernel: [<ffffffff8130853c>] ? 0xffffffff8130853c
> May 11 17:43:16 x kernel: [<ffffffff81064560>] ? 0xffffffff81064560
> May 11 17:43:16 x kernel: ---[ end trace 4fa5a49292304c0d ]---
> May 11 17:43:16 x kernel: bcache: bch_btree_insert() error -12
> --
> Mariusz Paradowski
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
