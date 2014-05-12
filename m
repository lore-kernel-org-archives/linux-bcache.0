From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache: btree_split() couldn't split
Date: Mon, 12 May 2014 18:14:30 +0200
Message-ID: <5370F366.7030505@rolffokkens.nl>
References: <58691644935d03855d2edb9c71c6dfb0@indianin.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43647 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaELQOd (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 12 May 2014 12:14:33 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so4850995eek.6
        for <linux-bcache@vger.kernel.org>; Mon, 12 May 2014 09:14:32 -0700 (PDT)
In-Reply-To: <58691644935d03855d2edb9c71c6dfb0@indianin.eu.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Mariusz Paradowski <indianin@indianin.net>, linux-bcache@vger.kernel.org

So far no problems here, I have been using bcache since october. But I'm 
currently running kernel 3.14.3, so I might be at risk?

Is this issue there since a specific kernel version?

On 05/12/2014 01:53 PM, Mariusz Paradowski wrote:
> Confirmed on kernel 3.14.3 from kernel.org:
>
> May 11 17:43:16 x kernel: ------------[ cut here ]------------
> May 11 17:43:16 x kernel: WARNING: CPU: 3 PID: 376101 at 
> drivers/md/bcache/btree.c:1979 0xffffffffa00d65ab()
> May 11 17:43:16 x kernel: bcache: btree split failed
> May 11 17:43:16 x kernel: Modules linked in: e1000e ptp pps_core 
> microcode firmware_class unix mpt2sas raid_class scsi_transport_sas 
> bcache fuse hid_generic usbhid hid xhci_hcd ehci_pci ehci_hcd usbcore 
> usb_common msr cpuid
> May 11 17:43:16 x kernel: CPU: 3 PID: 376101 Comm: kworker/3:2 Not 
> tainted 3.14.3 #1
> May 11 17:43:16 x kernel: Hardware name:                  /DH87MC, 
> BIOS MCH8710H.86A.0047.2013.0606.1508 06/06/2013
> May 11 17:43:16 x kernel: Workqueue: events 0xffffffffa00e8fa0
> May 11 17:43:16 x kernel: 0000000000000009 ffffffff81303a63 
> ffff88040c24b988 ffffffff8104c2fd
> May 11 17:43:16 x kernel: ffff8801056f2400 ffff88040c24b9d8 
> ffff88040c24ba00 ffff88040c24bd10
> May 11 17:43:16 x kernel: ffffffffffffffe4 ffffffff8104c367 
> ffffffffa00ea33b ffff880400000018
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
