From: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Subject: Re: Bug - bcache: "unable to handle kernel NULL pointer dereference"
 when trying to add a md caching device
Date: Fri, 25 Mar 2016 15:11:30 +0100
Message-ID: <56F54712.6090202@roesner-online.de>
References: <56F4058B.1030309@roesner-online.de>
 <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
 <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from euler.f0o.de ([85.88.6.196]:54632 "EHLO mail.f0o.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbcCYOLt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 25 Mar 2016 10:11:49 -0400
In-Reply-To: <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Hi Eric,

Am 25.03.2016 um 05:18 schrieb Eric Wheeler:
> Please send this output:
>
> tail /sys/block/md2/queue/discard_*

>> git pull https://bitbucket.org/ewheelerinc/linux v4.5-rc6-bcache-fixes
>> git pull https://bitbucket.org/ewheelerinc/linux v4.5-rc7-bcache-fixes
>
> Try this patch and see if it BUGs:
 > [..]

# tail /sys/block/md2/queue/discard_*
==> /sys/block/md2/queue/discard_granularity <==
4096

==> /sys/block/md2/queue/discard_max_bytes <==
2147450880

==> /sys/block/md2/queue/discard_max_hw_bytes <==
2147450880

==> /sys/block/md2/queue/discard_zeroes_data <==
0

root@gropius:/home/sroesner# echo /dev/md2 > /sys/fs/bcache/register
sroesner@gropius:~$

-> it killed my bash.

Trace with patches and BUG_ON patch:

[  172.660142] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000028
[  172.660229] IP: [<ffffffff811e53b4>] bio_trim+0xf/0x2a
[  172.660289] PGD 7faf3e067 PUD 7f9279067 PMD 0
[  172.660399] Oops: 0000 [#1] SMP
[...]
[  172.664780] Call Trace:
[  172.664813]  [<ffffffffa007f3be>] ? raid1_make_request+0x2e8/0xad7 
[raid1]
[  172.664846]  [<ffffffff811f07da>] ? blk_queue_split+0x377/0x3d4
[  172.664880]  [<ffffffffa005fb5f>] ? md_make_request+0xf6/0x1e9 [md_mod]
[  172.664912]  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
[  172.664947]  [<ffffffffa0445c89>] ? prio_io+0x85/0x95 [bcache]
[  172.664981]  [<ffffffffa0448252>] ? register_cache_set+0x355/0x8d0 
[bcache]
[  172.665016]  [<ffffffffa04497d3>] ? register_bcache+0x1006/0x1174 
[bcache]

See http://pastebin.com/6CHtky2x for complete traces.

Sebastian
