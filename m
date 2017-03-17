From: Marcin <marcin@mejor.pl>
Subject: Re: [bcachefs] problem with `bcache fsck`
Date: Fri, 17 Mar 2017 23:26:11 +0100
Message-ID: <c63b4675d9f93acebad942c51d9c56f0@mejor.pl>
References: <6aaaad468dd77840265bcd9f31f1878a@mejor.pl>
 <20170316203455.jgl6ovsrve55fnxi@moria.home.lan>
 <f7e0b5acca043eff08a55f424470221d@mejor.pl>
 <20170316235651.oehere2zxhewbbdh@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:28356 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdCQW06 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Mar 2017 18:26:58 -0400
In-Reply-To: <20170316235651.oehere2zxhewbbdh@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 2017-03-17 00:57, Kent Overstreet napisał(a):
> On Thu, Mar 16, 2017 at 11:07:20PM +0100, Marcin wrote:
>> If I add bcachefs to fstab openrc expects userland fsck to works this 
>> is why
>> I tried it to use.
> 
> Fsck should be fixed now
> 
>> There is no new commit, I'm at
>> commit 7274700edcf99ab67d4f72eca4f07d0220b9abae
>> Author: Kent Overstreet <kent.overstreet@gmail.com>
>> Date:   Tue Mar 14 21:07:39 2017 -0800
>> 
>>     bcache: fix device hot add
> 
> Ok, you're good then (at least re: the buffered reads bug)
> 
>> I suspect that problem is due to using  --metadata_replicas=2. If you 
>> have a
>> some spare time please try fileystsem formated with this parameters:
>> # bcache format --compression_type=gzip --metadata_replicas=2
>> --data_checksum_type=crc64 --metadata_checksum_type=crc64 --tier=2 
>> /dev/sde1
>> --tier=3 /dev/sdd1
> 
> Alright, will do

I configured logging using netconsole, I formated fs using favorite 
killer-combo[1], when I copied ~480000 rather small files the host 
rebooted. I only cought this:

Mar 17 23:17:00 [ 1247.409119] kernel BUG at 
drivers/md/bcache/buckets.c:505!
Mar 17 23:17:00 [ 1247.409149] invalid opcode: 0000 [#1] SMP
Mar 17 23:17:00 [ 1247.409176] Modules linked in:
Mar 17 23:17:00 netconsole
Mar 17 23:17:00 tun
[snip list of modules]

Marcin

[1] bcache format --compression_type=gzip --metadata_replicas=2 
--data_checksum_type=crc64 --metadata_checksum_type=crc64 --tier=2 
/dev/sde1 --tier=3 /dev/sdd1
