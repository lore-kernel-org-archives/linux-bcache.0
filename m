From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: kernel crash with kernel 3.17-rc4
Date: Mon, 15 Sep 2014 20:35:32 +0200
Message-ID: <54173174.10203@profihost.ag>
References: <15506745.rmJNHLbm6l@rather> <9699E135-38D8-4C09-88B1-BB8BE398035E@profihost.ag> <17001056.KAGdUDRv9p@rather>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:33698 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaIOSfa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 15 Sep 2014 14:35:30 -0400
In-Reply-To: <17001056.KAGdUDRv9p@rather>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Thomas Stein <himbeere@meine-oma.de>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

No it's not and also the load problem is the same.

I think we need to wait for a response from kent.

Stefan

Excuse my typo sent from my mobile phone.

Am 15.09.2014 um 19:47 schrieb Thomas Stein <himbeere@meine-oma.de 
<mailto:himbeere@meine-oma.de>>:

> On Monday 15 September 2014 19:47:18 Stefan Priebe - Profihost AG wrote:
>> Same to me.
>
> Hello Stefan.
>
> Is the 3.16.2 working better? Uhh and what happend to load bug? Even with
> 3.17-rc4 i have a constant load of 2.00 on an otherwise idle system.
>
> cheers
> t.
>
>> Stefan
>>
>> Excuse my typo sent from my mobile phone.
>>
>>> Am 15.09.2014 um 19:26 schrieb Thomas Stein <himbeere@meine-oma.de 
>>> <mailto:himbeere@meine-oma.de>>:
>>>
>>> Hello eveybody.
>>>
>>> Just played around with 3.17-rc4 and bcache. I've build bcache with 
>>> a 120G
>>> SSD as caching device and a Raid1 device (md4) as backing device. Today
>>> under heavy i/o load (moving a 100G VM Image) the machine froze. Call
>>> trace is this:
>>>
>>> Sep 15 10:13:48 hn kernel: [82567.843075] Task dump for CPU 0:
>>> Sep 15 10:13:48 hn kernel: [82567.843078] bcache_gc       R  running 
>>> task
>>> 12248 28611      2 0x00080808
>>> Sep 15 10:13:48 hn kernel: [82567.843083]  ffffffff81c411c0
>>> ffff88083fa03d78 ffffffff81071492 0000000000000000
>>> Sep 15 10:13:48 hn kernel: [82567.843087]  ffffffff81c411c0
>>> ffff88083fa03d98 ffffffff810740b8 ffff88083fa03dd8
>>> Sep 15 10:13:48 hn kernel: [82567.843090]  0000000000000000
>>> ffff88083fa03dc8 ffffffff8108f335 ffff88083fa0d280
>>> Sep 15 10:13:48 hn kernel: [82567.843093] Call Trace:
>>> Sep 15 10:13:48 hn kernel: [82567.843096]  <IRQ>  [<ffffffff81071492>]
>>> sched_show_task+0xc2/0x130
>>> Sep 15 10:13:48 hn kernel: [82567.843108]  [<ffffffff810740b8>]
>>> dump_cpu_task+0x38/0x40
>>> Sep 15 10:13:48 hn kernel: [82567.843119]  [<ffffffff8108f335>]
>>> rcu_dump_cpu_stacks+0x85/0xc0
>>> Sep 15 10:13:48 hn kernel: [82567.843131]  [<ffffffff81092610>]
>>> rcu_check_callbacks+0x3c0/0x680
>>> Sep 15 10:13:48 hn kernel: [82567.843135]  [<ffffffff81096e13>]
>>> update_process_times+0x43/0x80
>>> Sep 15 10:13:48 hn kernel: [82567.843139]  [<ffffffff810a54f1>]
>>> tick_sched_handle.isra.13+0x31/0x40
>>> Sep 15 10:13:48 hn kernel: [82567.843142]  [<ffffffff810a5667>]
>>> tick_sched_timer+0x47/0x70
>>> Sep 15 10:13:48 hn kernel: [82567.843146]  [<ffffffff8109766b>]
>>> __run_hrtimer+0x7b/0x1c0
>>> Sep 15 10:13:48 hn kernel: [82567.843149]  [<ffffffff810a5620>] ?
>>> tick_sched_do_timer+0x30/0x30
>>> Sep 15 10:13:48 hn kernel: [82567.843153]  [<ffffffff81097e37>]
>>> hrtimer_interrupt+0xf7/0x230
>>> Sep 15 10:13:48 hn kernel: [82567.843158]  [<ffffffff81033196>]
>>> local_apic_timer_interrupt+0x36/0x60
>>> Sep 15 10:13:48 hn kernel: [82567.843162]  [<ffffffff810334de>]
>>> smp_apic_timer_interrupt+0x3e/0x60
>>> Sep 15 10:13:48 hn kernel: [82567.843166]  [<ffffffff8166994a>]
>>> apic_timer_interrupt+0x6a/0x70
>>> Sep 15 10:13:48 hn kernel: [82567.843168]  <EOI>  [<ffffffff8148f848>] ?
>>> btree_gc_count_keys+0x28/0x60
>>> Sep 15 10:13:48 hn kernel: [82567.843175]  [<ffffffff8148f869>] ?
>>> btree_gc_count_keys+0x49/0x60
>>> Sep 15 10:13:48 hn kernel: [82567.843178]  [<ffffffff814950b5>]
>>> btree_gc_recurse+0x1b5/0x320
>>> Sep 15 10:13:48 hn kernel: [82567.843182]  [<ffffffff814904f3>] ?
>>> btree_gc_mark_node+0x63/0x240
>>> Sep 15 10:13:48 hn kernel: [82567.843186]  [<ffffffff81080b2e>] ?
>>> __wake_up+0x4e/0x70
>>> Sep 15 10:13:48 hn kernel: [82567.843190]  [<ffffffff81495635>]
>>> bch_btree_gc+0x415/0x5a0
>>> Sep 15 10:13:48 hn kernel: [82567.843194]  [<ffffffff81080780>] ?
>>> finish_wait+0x80/0x80
>>> Sep 15 10:13:48 hn kernel: [82567.843197]  [<ffffffff814957f8>]
>>> bch_gc_thread+0x38/0x120
>>> Sep 15 10:13:48 hn kernel: [82567.843200]  [<ffffffff814957c0>] ?
>>> bch_btree_gc+0x5a0/0x5a0
>>> Sep 15 10:13:48 hn kernel: [82567.843204]  [<ffffffff810672b4>]
>>> kthread+0xc4/0xe0
>>> Sep 15 10:13:48 hn kernel: [82567.843207]  [<ffffffff810671f0>] ?
>>> kthread_worker_fn+0x150/0x150
>>> Sep 15 10:13:48 hn kernel: [82567.843211]  [<ffffffff81668aac>]
>>> ret_from_fork+0x7c/0xb0
>>> Sep 15 10:13:48 hn kernel: [82567.843214]  [<ffffffff810671f0>] ?
>>> kthread_worker_fn+0x150/0x150
>>>
>>> That's it.  Should i be worried? It's a testing machine of course.
>>>
>>> thanks and best regards
>>> t.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-bcache" in
>>> the body of a message to majordomo@vger.kernel.org 
>>> <mailto:majordomo@vger.kernel.org>
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org 
> <mailto:majordomo@vger.kernel.org>
> More majordomo info at http://vger.kernel.org/majordomo-info.html
