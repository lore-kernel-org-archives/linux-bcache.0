From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: Re: 3.18.3 + latest bcache-dev
Date: Thu, 22 Jan 2015 00:04:26 +0100
Message-ID: <20150121230426.GB15237@cuci.nl>
References: <20150121012424.GB5533@cuci.nl>
 <CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
 <20150121110400.GA14729@cuci.nl>
 <CACHGV4J3Ler_+RHcd6x0nEfSKTnWQLqhrze97XzcFe-30+xu6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:40482 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbbAUXE1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 21 Jan 2015 18:04:27 -0500
Content-Disposition: inline
In-Reply-To: <CACHGV4J3Ler_+RHcd6x0nEfSKTnWQLqhrze97XzcFe-30+xu6A@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: Kent Overstreet <kmo@daterainc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Slava Pestov wrote:
>On Wed, Jan 21, 2015 at 3:04 AM, Stephen R. van den Berg <srb@cuci.nl> wrote:
>> Jan 21 11:21:40 ip144 kernel: ata11.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
>> Jan 21 11:21:40 ip144 kernel: ata11.00: irq_stat 0x40000008
>> Jan 21 11:21:40 ip144 kernel: ata11.00: failed command: READ FPDMA QUEUED
>> Jan 21 11:21:40 ip144 kernel: ata11.00: cmd 60/00:c0:10:d0:d9/04:00:01:00:00/40 tag 24 ncq 524288 in
>> Jan 21 11:21:40 ip144 kernel:         res 41/40:00:d0:d1:d9/00:00:01:00:00/00 Emask 0x409 (media error) <F>
>> Jan 21 11:21:40 ip144 kernel: ata11.00: status: { DRDY ERR }
>> Jan 21 11:21:40 ip144 kernel: ata11.00: error: { UNC }
>> Jan 21 11:21:40 ip144 kernel: ata11.00: configured for UDMA/133

>I'm not sure this is related. Do you see it during normal operation
>ever? It is possible that we're spinning in softirq context or
>something, starving the device, but I'm not sure...

In the second run now, with increased traffic, I do not see the above
happening.

Maybe I cut it short, the whole message is:
Jan 21 12:09:14 ip144 kernel: ata11.00: exception Emask 0x0 SAct 0x3000 SErr 0x0 action 0x0
Jan 21 12:09:14 ip144 kernel: ata11.00: irq_stat 0x40000008
Jan 21 12:09:14 ip144 kernel: ata11.00: failed command: READ FPDMA QUEUED
Jan 21 12:09:14 ip144 kernel: ata11.00: cmd 60/00:68:e8:2b:da/01:00:01:00:00/40 tag 13 ncq 131072 in
Jan 21 12:09:14 ip144 kernel:         res 41/40:00:b0:2c:da/00:00:01:00:00/00 Emask 0x409 (media error) <F>
Jan 21 12:09:14 ip144 kernel: ata11.00: status: { DRDY ERR }
Jan 21 12:09:14 ip144 kernel: ata11.00: error: { UNC }
Jan 21 12:09:14 ip144 kernel: ata11.00: configured for UDMA/133
Jan 21 12:09:14 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 12:09:14 ip144 kernel: Result: hostbyte=0x00 driverbyte=0x08
Jan 21 12:09:14 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 12:09:14 ip144 kernel: Sense Key : 0x3 [current] [descriptor]
Jan 21 12:09:14 ip144 kernel: Descriptor sense data with sense descriptors (in hex):
Jan 21 12:09:14 ip144 kernel:        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
Jan 21 12:09:14 ip144 kernel:        01 da 2c b0 
Jan 21 12:09:14 ip144 kernel: sd 10:0:0:0: [sdg]  
Jan 21 12:09:14 ip144 kernel: ASC=0x11 ASCQ=0x4
Jan 21 12:09:14 ip144 kernel: sd 10:0:0:0: [sdg] CDB: 
Jan 21 12:09:14 ip144 kernel: cdb[0]=0x88: 88 00 00 00 00 00 01 da 2b e8 00 00 01 00 00 00
Jan 21 12:09:14 ip144 kernel: blk_update_request: I/O error, dev sdg, sector 31075504
Jan 21 12:09:14 ip144 kernel: ata11: EH complete

And it always happens upon a read error from HDD.
-- 
Stephen.
