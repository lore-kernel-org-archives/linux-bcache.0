From: Marcin <marcin@mejor.pl>
Subject: Re: [bcachefs]  BUG: soft lockup - CPU#0 stuck for 22s!
 [bch_copygc_read:5328]
Date: Sun, 04 Sep 2016 20:21:17 +0200
Message-ID: <c3e7064966b0449f5107bf3cb637c308@mejor.pl>
References: <5e794b2230e3af7ec0a06eaceaf7a6fc@mejor.pl>
 <20160904001729.r3qjqpin62i6d4so@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:45594 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754025AbcIDSVn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Sep 2016 14:21:43 -0400
In-Reply-To: <20160904001729.r3qjqpin62i6d4so@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 2016-09-04 02:17, Kent Overstreet napisał(a):

Hi!

> On Sat, Sep 03, 2016 at 11:29:49PM +0200, Marcin wrote:
>> Hi!
>> Kernel at commit c820493652e830dc050e1418301e1bdec5691a1e
>> 
>> I createt to devices, fast has size
>> # blockdev --getsz /dev/sde1
>> 20971520
>> and slower device:
>> # blockdev --getsz /dev/sdd1
>> 2930209551
>> 
>> I was copying files from one disk to bcache, after some time I got:
>>  BUG: soft lockup - CPU#0 stuck for 22s! [bch_copygc_read:5328]
> 
> Thanks for the report - can you run addr2line with your vmlinux file, 
> and the
> RIP?
> 
> addr2line -i -e vmlinux ffffffffc028795b

It returned:
??:0

Probably due to I'm using bcache as module.
<long story>
As I mentioned before I wasn't sure which branch I used to test. So I 
started to reproduce problem again and watch which branch is used. I 
encountered strange behaviour, random BUGs in kernel, even random 
reboots. It looked like a hardware problem but I never got such problems 
using this box as backup & samba server. Memtest86+ didn't found any 
problem, cpuburn didn't trigger anything suspicious. Gcc compiles 
without any strange failures. Nothing suspicious happened when I didn't 
use bcachefs. So i spent a couple of hours trying to find out what is 
going on. I tried bcachefs without tiering. When I formated /dev/sde1 
then everything was ok. But when I tried to use /dev/sdd1 something 
happened:
# bcache format /dev/sdd1
/dev/sdd1 contains a bcache filesystem
Proceed anyway? (y,n) y
UUID:                   78a90acf-0247-4edf-a56f-f4f82a51e13e
Set UUID:               a0a6e9fa-d7bb-4cec-8c42-b7e4bbccb2d8
version:                6
nbuckets:               3815462
block_size:             1
bucket_size:            768
nr_in_set:              1
nr_this_dev:            0
first_bucket:           3

# LC_ALL=en_US.utf-8 mount -t bcache /dev/sdd1 /mnt/test/
mount: mount(2) failed: No such file or directory

Kernel throws:
zserwerek kernel: [ 5832.483306] bcache: bch_open_as_blockdevs() 
register_cache_set err Bad bucket size

Hmmm. So I resized /dev/sdd1 from 1.4TB to 100GB. Formated again, and 
mounted without problem. Hmm. I created tiered bcachefs with smaller 
/dev/sdd1 and it works stable.

<conclucion>
Please look at line with "bucket size":
bucket_size:            768
If bucket size is higher than (probably) 512 then I can't mount simple 
(without tiering) bcachefs filesystem. If I use such big device in 
tiered bcachefs I'm expieriencing random problems with stability of box.
I think that bug in mail's subject is only random symptom of problem 
when device is formated with bucket size >512.
What is going inside kernel in this case, is overwittem memory of other 
processes?


Marcin
