From: Slava Pestov <sp@datera.io>
Subject: Re: 3.18.3 + latest bcache-dev
Date: Wed, 21 Jan 2015 14:47:16 -0800
Message-ID: <CACHGV4J3Ler_+RHcd6x0nEfSKTnWQLqhrze97XzcFe-30+xu6A@mail.gmail.com>
References: <20150121012424.GB5533@cuci.nl>
	<CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
	<20150121110400.GA14729@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:41355 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbbAUWrR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 21 Jan 2015 17:47:17 -0500
Received: by mail-la0-f50.google.com with SMTP id pn19so42941639lab.9
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2015 14:47:16 -0800 (PST)
In-Reply-To: <20150121110400.GA14729@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: Kent Overstreet <kmo@daterainc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Wed, Jan 21, 2015 at 3:04 AM, Stephen R. van den Berg <srb@cuci.nl> wrote:
> Jan 21 11:21:40 ip144 kernel: ata11.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> Jan 21 11:21:40 ip144 kernel: ata11.00: irq_stat 0x40000008
> Jan 21 11:21:40 ip144 kernel: ata11.00: failed command: READ FPDMA QUEUED
> Jan 21 11:21:40 ip144 kernel: ata11.00: cmd 60/00:c0:10:d0:d9/04:00:01:00:00/40 tag 24 ncq 524288 in
> Jan 21 11:21:40 ip144 kernel:         res 41/40:00:d0:d1:d9/00:00:01:00:00/00 Emask 0x409 (media error) <F>
> Jan 21 11:21:40 ip144 kernel: ata11.00: status: { DRDY ERR }
> Jan 21 11:21:40 ip144 kernel: ata11.00: error: { UNC }
> Jan 21 11:21:40 ip144 kernel: ata11.00: configured for UDMA/133
>

I'm not sure this is related. Do you see it during normal operation
ever? It is possible that we're spinning in softirq context or
something, starving the device, but I'm not sure...

> Jan 21 11:43:46 ip144 kernel: bcache: register_cache() registered cache device sda3
> Jan 21 11:43:46 ip144 kernel: bcache: register_cache() registered cache device sdb3
> Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdg
> Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdc
> Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdf
> Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sde
> Jan 21 11:43:46 ip144 kernel: bcache: register_bdev() registered backing device sdd
> Jan 21 11:43:46 ip144 kernel: bcache: error on 04063132-f7e1-4f29-a3aa-675491b426f4: sdb3: bad magic (got 17495323148306469098 expect 5629218783827753365) while reading prios from bucket 16868
> Jan 21 11:43:46 ip144 kernel: bcache: register_bcache() error opening /dev/sdb3: error reading priorities

This is a bcache-dev bug that we just hit in our automation runs after
adding some more reboot tests. We're working on it.

Slava
