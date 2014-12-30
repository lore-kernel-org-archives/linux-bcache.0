From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: bcache journal_read_bucket / bad csum reading priorities / bad
 magic reading priorities
Date: Tue, 30 Dec 2014 06:59:45 +0100
Message-ID: <54A23F51.2080302@profihost.ag>
References: <54A1BE26.6070000@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:54985 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaL3F7U (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 30 Dec 2014 00:59:20 -0500
In-Reply-To: <54A1BE26.6070000@profihost.ag>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

next one:
[    6.745547] bcache: journal_read_bucket() 187: bad csum, 3576 bytes, 
offset 11
[    6.749731] bcache: prio_read() bad csum reading priorities
[    6.749732] bcache: prio_read() bad magic reading priorities
[    6.753451] bcache: prio_read() bad csum reading priorities
[    6.753453] bcache: prio_read() bad magic reading priorities
[    6.757243] bcache: prio_read() bad csum reading priorities
[    6.757244] bcache: prio_read() bad magic reading priorities
[    6.758356] bcache: error on 8d913f26-f623-4b6a-b6a5-64f7e583266b: 
unsupported bset version at bucket 160555, block 0, 3564887587 keys, 
disabling caching
[    6.758534] bcache: register_cache() registered cache device sdb3
[    6.758737] bcache: cache_set_free() Cache set 
8d913f26-f623-4b6a-b6a5-64f7e583266b unregistered

Funnily this always happens with the same device.

Stefan

Am 29.12.2014 um 21:48 schrieb Stefan Priebe:
> Hi,
>
> while running bcache on vanilla 3.10 i've lost some of my bcache devices
> with the following error messages after reboot:
>
> bcache: journal_read_bucket() 228: bad csum, 5320 bytes, offset 22
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: prio_read() bad csum reading priorities
> bcache: prio_read() bad magic reading priorities
> bcache: error on c40add13-6e96-4c47-a6de-1fc207088e07: unsupported bset
> version at bucket 261528, block 0, 2014209420 keys, disabling caching
> bcache: register_cache() registered cache device sdb3
> bcache: cache_set_free() Cache set c40add13-6e96-4c47-a6de-1fc207088e07
> unregistered
>
> Any patch or fix available?
>
> Stefan
