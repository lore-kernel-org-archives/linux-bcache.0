From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache causes RCU stalls/bcache_gc hogs CPU
Date: Tue, 14 Apr 2015 13:03:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1504141301380.12234@ware.dreamhost.com>
References: <552D29B8.9040704@siteground.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1866506367-1181759750-1429041827=:12234"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:45068 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbbDNUDs (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 14 Apr 2015 16:03:48 -0400
In-Reply-To: <552D29B8.9040704@siteground.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Nikolay Borisov <n.borisov@siteground.com>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1866506367-1181759750-1429041827=:12234
Content-Type: TEXT/PLAIN; charset=US-ASCII

Apply all of the attached patches to your kernel and try again.

I wish somebody would apply these upstream and get it into the official 
kernel. I have been carrying all of these patches with me for some time 
and they definitely make bcache more stable.

-Eric


--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298

On Tue, 14 Apr 2015, Nikolay Borisov wrote:

> Hello list,
> 
> 
> I'm currently testing bcache with the following setup:
> 
> NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
> 
> sda                   8:0    0   1.8T  0 disk
> ??sda1                8:1    0     2M  0 part
> ??sda2                8:2    0   191M  0 part
> ??sda3                8:3    0   1.8T  0 part
>   ??main-os (dm-0)  254:0    0   1.8T  0 lvm  /
> sdb                   8:16   0 223.1G  0 disk
> ??sdb1                8:17   0 188.2M  0 part /boot
> ??sdb2                8:18   0 222.9G  0 part
>   ??main-ssd (dm-1) 254:1    0    40G  0 lvm
>   ? ??bcache0       253:0    0   182G  0 disk /sdb
>   ??main-db (dm-2)  254:2    0   182G  0 lvm
>     ??bcache0       253:0    0   182G  0 disk /sdb
> 
> So a 40gig ssd (main-ssd, lvm2 volume) backed by a 180gig hdd (main-db, lvm 2
> volume), using the writeback cache policy. Every other setting is at its
> default. I'm running the 4.0-rc6 (!CONFIG_PREEMPT). After running fio (using a
> 30gb file) with a mix of sequential and random i/o and I'm getting the
> following RCU warn:
> 
> ======================================================
> INFO: rcu_sched self-detected stall on CPU
>         4: (2099 ticks this GP) idle=fcf/140000000000001/0
> softirq=1031582/1031582 fqs=2100
> INFO: rcu_sched detected stalls on CPUs/tasks:
>         4: (2099 ticks this GP) idle=fcf/140000000000001/0
> softirq=1031582/1031582 fqs=2100
>         (detected by 16, t=2104 jiffies, g=2176431, c=2176430, q=3098)
> Task dump for CPU 4:
> bcache_gc	R  running task    12728 18115      2 0x00000008
>  ffff880079e85720 fffffffffffffffc ffff88046c180e20 fffffffffffffffc
>  ffffffff81091693 fffffffffffffffc ffff88086aa3d000 ffff88046c180000
>  ffff88086aa3d000 ffff88046c180000 ffff88086aa3d060 ffff88086aa3d000
> Call Trace:
>  [<ffffffff81091693>] ? __wake_up+0x53/0x70
>  [<ffffffffa01103d4>] ? bch_btree_gc+0x2f4/0x560 [bcache]
>  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
>  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
>  [<ffffffffa0110678>] ? bch_gc_thread+0x38/0x120 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffff81070a9e>] ? kthread+0xce/0xf0
>  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff815b8818>] ? ret_from_fork+0x58/0x90
>  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
>          (t=2228 jiffies g=2176431 c=2176430 q=3161)
> Task dump for CPU 4:
> bcache_gc	R  running task    12728 18115      2 0x00000008
>  0000000000000005 ffff88046fc83ca8 ffffffff8107720b 0000000000000004
>  ffffffff8183d040 ffff88046fc83cc8 ffffffff810772af ffff88046fc83cc8
>  ffffffff8183d100 ffff88046fc83cf8 ffffffff810a5101 ffff88046fc94500
> Call Trace:
>  <IRQ>  [<ffffffff8107720b>] sched_show_task+0xcb/0x130
>  [<ffffffff810772af>] dump_cpu_task+0x3f/0x50
>  [<ffffffff810a5101>] rcu_dump_cpu_stacks+0x91/0xd0
>  [<ffffffff810a68cf>] rcu_check_callbacks+0x65f/0xc30
>  [<ffffffff81080ecc>] ? account_process_tick+0x6c/0x170
>  [<ffffffff810acf29>] update_process_times+0x39/0x70
>  [<ffffffff810beba0>] tick_sched_handle+0x40/0x50
>  [<ffffffff810bedb2>] tick_sched_timer+0x52/0xa0
>  [<ffffffff810afa16>] __run_hrtimer+0x86/0x1d0
>  [<ffffffff810bed60>] ? tick_nohz_handler+0xc0/0xc0
>  [<ffffffff810afd92>] hrtimer_interrupt+0x102/0x240
>  [<ffffffffa0109920>] ? bch_ptr_invalid+0x10/0x10 [bcache]
>  [<ffffffff81032e79>] local_apic_timer_interrupt+0x39/0x60
>  [<ffffffff815bb355>] smp_apic_timer_interrupt+0x45/0x59
>  [<ffffffffa0109920>] ? bch_ptr_invalid+0x10/0x10 [bcache]
>  [<ffffffff815b972d>] apic_timer_interrupt+0x6d/0x80
>  <EOI>  [<ffffffffa01117c5>] ? __bch_extent_invalid+0xa5/0xd0 [bcache]
>  [<ffffffffa0111721>] ? __bch_extent_invalid+0x1/0xd0 [bcache]
>  [<ffffffffa0111802>] ? bch_extent_invalid+0x12/0x20 [bcache]
>  [<ffffffffa011183d>] bch_extent_bad+0x2d/0x1c0 [bcache]
>  [<ffffffffa010992a>] bch_ptr_bad+0xa/0x10 [bcache]
>  [<ffffffffa01098f9>] bch_btree_iter_next_filter+0x39/0x50 [bcache]
>  [<ffffffffa0109c80>] btree_gc_count_keys+0x50/0x70 [bcache]
>  [<ffffffffa010ffbf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
>  [<ffffffffa010c4ac>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
>  [<ffffffff81091693>] ? __wake_up+0x53/0x70
>  [<ffffffffa01103d4>] bch_btree_gc+0x2f4/0x560 [bcache]
>  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
>  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
>  [<ffffffffa0110678>] bch_gc_thread+0x38/0x120 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffff81070a9e>] kthread+0xce/0xf0
>  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff815b8818>] ret_from_fork+0x58/0x90
> 
> Naturally, checking
> /sys/fs/bcache/b9bcddd1-7a9a-4f2f-88e6-cb5bef6abcf2/internal/btree_gc_max_duration_ms
> shows: 31593  Clearly at some point the GC overhead becomes so large that it
> causes RCU grace period stalls. I'm puzzled since bch_btree_gc_finish(...) is
> not listed and this is the only function that pertains to bcache gc AND
> executes code in RCU critical read section.
> 
> In addition to that I also observed that the after this RCU stall warn occurs
> the bcache_gc thread hogs the machine at 100% rendering it unusable. I managed
> to get 2 call stack dumps via magic sysrq as follows:
> 
> =============
> NMI backtrace for cpu 4
> CPU: 4 PID: 18115 Comm: bcache_gc Not tainted 4.0.0-rc6bcache1-nikbor #4
> Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
> task: ffff88086ab093e0 ti: ffff880868024000 task.ti: ffff880868024000
> RIP: 0010:[<ffffffffa01098cb>]  [<ffffffffa01098cb>]
> bch_btree_iter_next_filter+0xb/0x50 [bcache]
> RSP: 0018:ffff880868027bd8  EFLAGS: 00000202
> RAX: 0000000000000001 RBX: 0000000000002034 RCX: 000000000000000a
> RDX: ffffffffa0109920 RSI: ffff88086aa3dcd0 RDI: ffff880868027c08
> RBP: ffff880868027bf8 R08: 0000000000000001 R09: 0000000000000001
> R10: 000007ffffffffff R11: 0000000000000008 R12: ffff88086aa3dcd0
> R13: ffff880868027c08 R14: ffff880868027cf8 R15: ffff880868027dd8
> FS:  0000000000000000(0000) GS:ffff88046fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4f6b410008 CR3: 000000000180e000 CR4: 00000000001406e0
> Stack:
>  0000000000002034 ffff88086aa3dcd0 ffff880868027c08 ffff880868027cf8
>  ffff880868027c78 ffffffffa0109c80 0000000000000004 0000000000000001
>  ffff8807740101c0 ffff88077402a9f8 ffff88086aa3dc00 ffff88086aa3d000
> Call Trace:
>  [<ffffffffa0109c80>] btree_gc_count_keys+0x50/0x70 [bcache]
>  [<ffffffffa010ffbf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
>  [<ffffffffa010c4ac>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
>  [<ffffffff81091693>] ? __wake_up+0x53/0x70
>  [<ffffffffa01103d4>] bch_btree_gc+0x2f4/0x560 [bcache]
>  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
>  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
>  [<ffffffffa0110678>] bch_gc_thread+0x38/0x120 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffff81070a9e>] kthread+0xce/0xf0
>  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff815b8818>] ret_from_fork+0x58/0x90
>  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
> Code: ff 48 89 d7 4c 29 cf eb a7 48 29 f2 48 89 d6 e9 18 ff ff ff 66 66 66 2e
> 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 56 41 55 41 54 53 <0f> 1f 44 00 00 48
> 89 fb 49 89 f4 49 89 d6 0f 1f 80 00 00 00 00
> 
> 
> ===========================================
> 
> NMI backtrace for cpu 4
> CPU: 4 PID: 18115 Comm: bcache_gc Not tainted 4.0.0-rc6bcache1-nikbor #4
> Hardware name: Supermicro X9DRD-iF/LF/X9DRD-iF, BIOS 3.0b 12/05/2013
> task: ffff88086ab093e0 ti: ffff880868024000 task.ti: ffff880868024000
> RIP: 0010:[<ffffffffa0111916>]  [<ffffffffa0111916>]
> bch_extent_bad+0x106/0x1c0 [bcache]
> RSP: 0018:ffff880868027ba8  EFLAGS: 00000202
> RAX: 000000000000bd2a RBX: ffff88077400a550 RCX: 000000000000000a
> RDX: 0000000000000004 RSI: 00000000fc390004 RDI: ffff88046c180000
> RBP: ffff880868027bb8 R08: 0000000000000001 R09: 0000000000000000
> R10: 000007ffffffffff R11: 0000000000000008 R12: ffff88086aa3dcd0
> R13: ffff88077400a550 R14: ffffffffa0109920 R15: ffff880868027dd8
> FS:  0000000000000000(0000) GS:ffff88046fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4f6b410008 CR3: 000000000180e000 CR4: 00000000001406e0
> Stack:
>  ffff880868027c08 ffff88086aa3dcd0 ffff880868027bc8 ffffffffa010992a
>  ffff880868027bf8 ffffffffa01098f9 00000000000014a6 ffff88086aa3dcd0
>  ffff880868027c08 ffff880868027cf8 ffff880868027c78 ffffffffa0109c80
> Call Trace:
>  [<ffffffffa010992a>] bch_ptr_bad+0xa/0x10 [bcache]
>  [<ffffffffa01098f9>] bch_btree_iter_next_filter+0x39/0x50 [bcache]
>  [<ffffffffa0109c80>] btree_gc_count_keys+0x50/0x70 [bcache]
>  [<ffffffffa010ffbf>] btree_gc_recurse+0x1bf/0x2e0 [bcache]
>  [<ffffffffa010c4ac>] ? btree_gc_mark_node+0xdc/0x210 [bcache]
>  [<ffffffff81091693>] ? __wake_up+0x53/0x70
>  [<ffffffffa01103d4>] bch_btree_gc+0x2f4/0x560 [bcache]
>  [<ffffffff8100180b>] ? __switch_to+0xbb/0x5f0
>  [<ffffffff810911f0>] ? woken_wake_function+0x20/0x20
>  [<ffffffffa0110678>] bch_gc_thread+0x38/0x120 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffffa0110640>] ? bch_btree_gc+0x560/0x560 [bcache]
>  [<ffffffff81070a9e>] kthread+0xce/0xf0
>  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff815b8818>] ret_from_fork+0x58/0x90
>  [<ffffffff810709d0>] ? kthread_freezable_should_stop+0x70/0x70
> Code: 33 25 ff 0f 00 00 48 8b 94 c7 40 0c 00 00 48 89 f0 48 8b 92 d8 0a 00 00
> 48 c1 e8 08 4c 21 d0 48 d3 e8 48 8d 04 40 0f b6 54 82 06 <40> 28 f2 80 fa 80
> 0f 87 7e 00 00 00 0f b6 d2 83 fa 60 76 66 31
> 
> 
> In the mean time I'm running the stable 4.0.0 where I observe better results (
> no bcache_gc thread hog but still the occasional stall warn)
> 
> Regards,
> Nikolay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1866506367-1181759750-1429041827=:12234
Content-Type: TEXT/x-diff; name=bcache-unregister-reboot-notifier.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-unregister-reboot-notifier.patch

RnJvbTogWmhlbmcgTGl1IDx3ZW5xaW5nLmx6QHRhb2Jhby5jb20+DQoNCklu
IGJjYWNoZV9pbml0KCkgZnVuY3Rpb24gaXQgZm9yZ290IHRvIHVucmVnaXN0
ZXIgcmVib290IG5vdGlmaWVyIGlmDQpiY2FjaGUgZmFpbHMgdG8gdW5yZWdp
c3RlciBhIGJsb2NrIGRldmljZS4gIFRoaXMgY29tbWl0IGZpeGVzIHRoaXMu
DQoNClNpZ25lZC1vZmYtYnk6IFpoZW5nIExpdSA8d2VucWluZy5sekB0YW9i
YW8uY29tPg0KVGVzdGVkLWJ5OiBKb3NodWEgU2NobWlkIDxqc2NobWlkQHN1
c2UuY29tPg0KLS0tDQogZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYyB8IDQg
KysrLQ0KICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNoZS9z
dXBlci5jIGIvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYw0KaW5kZXggNGRk
MmJiNy4uZmRiYjIxMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvYmNhY2hl
L3N1cGVyLmMNCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMNCkBA
IC0yMTAwLDggKzIxMDAsMTAgQEAgc3RhdGljIGludCBfX2luaXQgYmNhY2hl
X2luaXQodm9pZCkNCiAJY2xvc3VyZV9kZWJ1Z19pbml0KCk7DQogDQogCWJj
YWNoZV9tYWpvciA9IHJlZ2lzdGVyX2Jsa2RldigwLCAiYmNhY2hlIik7DQot
CWlmIChiY2FjaGVfbWFqb3IgPCAwKQ0KKwlpZiAoYmNhY2hlX21ham9yIDwg
MCkgew0KKwkJdW5yZWdpc3Rlcl9yZWJvb3Rfbm90aWZpZXIoJnJlYm9vdCk7
DQogCQlyZXR1cm4gYmNhY2hlX21ham9yOw0KKwl9DQogDQogCWlmICghKGJj
YWNoZV93cSA9IGNyZWF0ZV93b3JrcXVldWUoImJjYWNoZSIpKSB8fA0KIAkg
ICAgIShiY2FjaGVfa29iaiA9IGtvYmplY3RfY3JlYXRlX2FuZF9hZGQoImJj
YWNoZSIsIGZzX2tvYmopKSB8fA0K

--1866506367-1181759750-1429041827=:12234
Content-Type: TEXT/x-diff; name=bcache-fix-memleak-bch_cached_dev_run.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-fix-memleak-bch_cached_dev_run.patch

DQpGcm9tOiBKb3NodWEgU2NobWlkIDxqc2NobWlkQHN1c2UuY29tPg0KU3Vi
amVjdDogW1BBVENIXSBmaXggYSBsZWFrIGluIGJjaF9jYWNoZWRfZGV2X3J1
bigpDQpOZXdzZ3JvdXBzOiBnbWFuZS5saW51eC5rZXJuZWwuYmNhY2hlLmRl
dmVsDQpEYXRlOiAyMDE1LTAyLTAzIDExOjI0OjA2IEdNVCAoMyB3ZWVrcywg
MiBkYXlzLCAxMSBob3VycyBhbmQgNDMgbWludXRlcyBhZ28pDQoNCkZyb206
IEFsIFZpcm8gPHZpcm9AWmVuSVYubGludXgub3JnLnVrPg0KDQpTaWduZWQt
b2ZmLWJ5OiBBbCBWaXJvIDx2aXJvQHplbml2LmxpbnV4Lm9yZy51az4NClRl
c3RlZC1ieTogSm9zaHVhIFNjaG1pZCA8anNjaG1pZEBzdXNlLmNvbT4NCi0t
LQ0KIGRyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgfCA1ICsrKystDQogMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYyBiL2Ry
aXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMNCmluZGV4IDhjMmQ2NTcuLjUzZjE1
MTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jDQor
KysgYi9kcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jDQpAQCAtODgwLDggKzg4
MCwxMSBAQCB2b2lkIGJjaF9jYWNoZWRfZGV2X3J1bihzdHJ1Y3QgY2FjaGVk
X2RldiAqZGMpDQogCWJ1ZltTQl9MQUJFTF9TSVpFXSA9ICdcMCc7DQogCWVu
dlsyXSA9IGthc3ByaW50ZihHRlBfS0VSTkVMLCAiQ0FDSEVEX0xBQkVMPSVz
IiwgYnVmKTsNCg0KLQlpZiAoYXRvbWljX3hjaGcoJmRjLT5ydW5uaW5nLCAx
KSkNCisJaWYgKGF0b21pY194Y2hnKCZkYy0+cnVubmluZywgMSkpIHsNCisJ
CWtmcmVlKGVudlsxXSk7DQorCQlrZnJlZShlbnZbMl0pOw0KIAkJcmV0dXJu
Ow0KKwl9DQoNCiAJaWYgKCFkLT5jICYmDQogCSAgICBCREVWX1NUQVRFKCZk
Yy0+c2IpICE9IEJERVZfU1RBVEVfTk9ORSkgew0KLS0gDQoyLjEuMg0KDQo=

--1866506367-1181759750-1429041827=:12234
Content-Type: TEXT/x-diff; name=bcache-attach-detach-cleanup.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-attach-detach-cleanup.patch

RnJvbTogSm9zaHVhIFNjaG1pZCA8anNjaG1pZEBzdXNlLmNvbT4NClN1Ympl
Y3Q6IFtQQVRDSF0gYmNhY2hlOiBbQlVHXSBjbGVhciBCQ0FDSEVfREVWX1VO
TElOS19ET05FIGZsYWcgd2hlbiBhdHRhY2hpbmcgYSBiYWNraW5nIGRldmlj
ZQ0KTmV3c2dyb3VwczogZ21hbmUubGludXgua2VybmVsLmJjYWNoZS5kZXZl
bA0KRGF0ZTogMjAxNS0wMi0wMyAxMToxODowMSBHTVQgKDMgd2Vla3MsIDIg
ZGF5cywgMTEgaG91cnMgYW5kIDQ1IG1pbnV0ZXMgYWdvKQ0KDQpGcm9tOiBa
aGVuZyBMaXUgPHdlbnFpbmcubHpAdGFvYmFvLmNvbT4NCg0KVGhpcyBidWcg
Y2FuIGJlIHJlcHJvZHVjZWQgYnkgdGhlIGZvbGxvd2luZyBzY3JpcHQ6DQoN
CiAgIyEvYmluL2Jhc2gNCg0KICBiY2FjaGVfc3lzZnM9Ii9zeXMvZnMvYmNh
Y2hlIg0KDQogIGZ1bmN0aW9uIGNsZWFyX2NhY2hlKCkNCiAgew0KICAJaWYg
WyAhIC1lICRiY2FjaGVfc3lzZnMgXTsgdGhlbg0KICAJCWVjaG8gIm5vIGJj
YWNoZSBzeXNmcyINCiAgCQlleGl0DQogIAlmaQ0KDQogIAljc2V0X3V1aWQ9
JChscyAtbCAkYmNhY2hlX3N5c2ZzfGhlYWQgLW4gMnx0YWlsIC1uIDF8YXdr
ICd7cHJpbnQgJDl9JykNCiAgCXN1ZG8gc2ggLWMgImVjaG8gJGNzZXRfdXVp
ZCA+IC9zeXMvYmxvY2svc2RiL3NkYjEvYmNhY2hlL2RldGFjaCINCiAgCXNs
ZWVwIDUNCiAgCXN1ZG8gc2ggLWMgImVjaG8gJGNzZXRfdXVpZCA+IC9zeXMv
YmxvY2svc2RiL3NkYjEvYmNhY2hlL2F0dGFjaCINCiAgfQ0KDQogIGZvciAo
KGk9MDtpPDEwO2krKykpOyBkbw0KICAJY2xlYXJfY2FjaGUNCiAgZG9uZQ0K
DQpUaGUgd2FybmluZyBtZXNzYWdlcyBsb29rIGxpa2UgYmVsb3c6DQpbICAy
NzUuOTQ4NjExXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0t
LS0NClsgIDI3NS45NjM4NDBdIFdBUk5JTkc6IGF0IGZzL3N5c2ZzL2Rpci5j
OjUxMiBzeXNmc19hZGRfb25lKzB4YjgvMHhkMCgpIChUYWludGVkOiBQICAg
ICAgICBXIA0KLS0tLS0tLS0tLS0tLS0tICAgKQ0KWyAgMjc1Ljk3OTI1M10g
SGFyZHdhcmUgbmFtZTogVGVjYWwgUkgyMjg1DQpbICAyNzUuOTk0MTA2XSBz
eXNmczogY2Fubm90IGNyZWF0ZSBkdXBsaWNhdGUgZmlsZW5hbWUgJy9kZXZp
Y2VzL3BjaTAwMDA6MDAvMDAwMDowMDowOS4wLzAwMDA6MDg6MDAuMC9ob3N0
NC90YXJnZXQ0OjI6MS80OjI6MTowL2Jsb2NrL3NkYi9zZGIxL2JjYWNoZS9j
YWNoZScNClsgIDI3Ni4wMjQxMDVdIE1vZHVsZXMgbGlua2VkIGluOiBiY2Fj
aGUgdGNwX2RpYWcgaW5ldF9kaWFnIGlwbWlfZGV2aW50ZiBpcG1pX3NpIGlw
bWlfbXNnaGFuZGxlcg0KYm9uZGluZyA4MDIxcSBnYXJwIHN0cCBsbGMgaXB2
NiBleHQzIGpiZCBsb29wIHNnIGlvbWVtb3J5X3ZzbChQKSBibngyIG1pY3Jv
Y29kZSBzZXJpb19yYXcgaTJjX2k4MDENCmkyY19jb3JlIGlUQ09fd2R0IGlU
Q09fdmVuZG9yX3N1cHBvcnQgaTdjb3JlX2VkYWMgZWRhY19jb3JlIHNocGNo
cCBleHQ0IGpiZDIgbWJjYWNoZSBtZWdhcmFpZF9zYXMNCnBhdGFfYWNwaSBh
dGFfZ2VuZXJpYyBhdGFfcGlpeCBkbV9tb2QgW2xhc3QgdW5sb2FkZWQ6IHNj
c2lfd2FpdF9zY2FuXQ0KWyAgMjc2LjA3MjY0M10gUGlkOiAyNzY1LCBjb21t
OiBzaCBUYWludGVkOiBQICAgICAgICBXICAtLS0tLS0tLS0tLS0tLS0gICAg
Mi42LjMyICMxDQpbICAyNzYuMDg5MzE1XSBDYWxsIFRyYWNlOg0KWyAgMjc2
LjEwNTgwMV0gIFs8ZmZmZmZmZmY4MTA3MGZlNz5dID8gd2Fybl9zbG93cGF0
aF9jb21tb24rMHg4Ny8weGMwDQpbICAyNzYuMTIyNjUwXSAgWzxmZmZmZmZm
ZjgxMDcxMGQ2Pl0gPyB3YXJuX3Nsb3dwYXRoX2ZtdCsweDQ2LzB4NTANClsg
IDI3Ni4xMzkzNjFdICBbPGZmZmZmZmZmODEyMDVjMDg+XSA/IHN5c2ZzX2Fk
ZF9vbmUrMHhiOC8weGQwDQpbICAyNzYuMTU2MDEyXSAgWzxmZmZmZmZmZjgx
MjA2MDliPl0gPyBzeXNmc19kb19jcmVhdGVfbGluaysweDEyYi8weDE3MA0K
WyAgMjc2LjE3MjY4Ml0gIFs8ZmZmZmZmZmY4MTIwNjExMz5dID8gc3lzZnNf
Y3JlYXRlX2xpbmsrMHgxMy8weDIwDQpbICAyNzYuMTg5MjgyXSAgWzxmZmZm
ZmZmZmEwM2JkYTIxPl0gPyBiY2FjaGVfZGV2aWNlX2xpbmsrMHhjMS8weDEx
MCBbYmNhY2hlXQ0KWyAgMjc2LjIwNTk5M10gIFs8ZmZmZmZmZmZhMDNiZmEw
OD5dID8gYmNoX2NhY2hlZF9kZXZfYXR0YWNoKzB4NDc4LzB4NGYwIFtiY2Fj
aGVdDQpbICAyNzYuMjIyNzk0XSAgWzxmZmZmZmZmZmEwM2M0YTE3Pl0gPyBi
Y2hfY2FjaGVkX2Rldl9zdG9yZSsweDYyNy8weDc4MCBbYmNhY2hlXQ0KWyAg
Mjc2LjIzOTY4MF0gIFs8ZmZmZmZmZmY4MTE2NzgzYT5dID8gYWxsb2NfcGFn
ZXNfY3VycmVudCsweGFhLzB4MTEwDQpbICAyNzYuMjU2NTk0XSAgWzxmZmZm
ZmZmZjgxMjAzYjE1Pl0gPyBzeXNmc193cml0ZV9maWxlKzB4ZTUvMHgxNzAN
ClsgIDI3Ni4yNzMzNjRdICBbPGZmZmZmZmZmODExODg3Yjg+XSA/IHZmc193
cml0ZSsweGI4LzB4MWEwDQpbICAyNzYuMjkwMTMzXSAgWzxmZmZmZmZmZjgx
MTg5MGIxPl0gPyBzeXNfd3JpdGUrMHg1MS8weDkwDQpbICAyNzYuMzA2MzY4
XSAgWzxmZmZmZmZmZjgxMDBjMDcyPl0gPyBzeXN0ZW1fY2FsbF9mYXN0cGF0
aCsweDE2LzB4MWINClsgIDI3Ni4zMjIzMDFdIC0tLVsgZW5kIHRyYWNlIDlm
NWQ0ZmNkZDBjM2VkZmIgXS0tLQ0KWyAgMjc2LjMzODI0MV0gLS0tLS0tLS0t
LS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tDQpbICAyNzYuMzU0MTA5XSBX
QVJOSU5HOiBhdCAvaG9tZS93ZW5xaW5nLmx6L2JjYWNoZS9iY2FjaGUvc3Vw
ZXIuYzo3MjANCmJjYWNoZV9kZXZpY2VfbGluaysweGRmLzB4MTEwIFtiY2Fj
aGVdKCkgKFRhaW50ZWQ6IFAgICAgICAgIFcgIC0tLS0tLS0tLS0tLS0tLSAg
ICkNClsgIDI3Ni4zODYwMTddIEhhcmR3YXJlIG5hbWU6IFRlY2FsIFJIMjI4
NQ0KWyAgMjc2LjQwMTQzMF0gQ291bGRuJ3QgY3JlYXRlIGRldmljZSA8LT4g
Y2FjaGUgc2V0IHN5bWxpbmtzDQpbICAyNzYuNDAxNzU5XSBNb2R1bGVzIGxp
bmtlZCBpbjogYmNhY2hlIHRjcF9kaWFnIGluZXRfZGlhZyBpcG1pX2Rldmlu
dGYgaXBtaV9zaSBpcG1pX21zZ2hhbmRsZXINCmJvbmRpbmcgODAyMXEgZ2Fy
cCBzdHAgbGxjIGlwdjYgZXh0MyBqYmQgbG9vcCBzZyBpb21lbW9yeV92c2wo
UCkgYm54MiBtaWNyb2NvZGUgc2VyaW9fcmF3IGkyY19pODAxDQppMmNfY29y
ZSBpVENPX3dkdCBpVENPX3ZlbmRvcl9zdXBwb3J0IGk3Y29yZV9lZGFjIGVk
YWNfY29yZSBzaHBjaHAgZXh0NCBqYmQyIG1iY2FjaGUgbWVnYXJhaWRfc2Fz
DQpwYXRhX2FjcGkgYXRhX2dlbmVyaWMgYXRhX3BpaXggZG1fbW9kIFtsYXN0
IHVubG9hZGVkOiBzY3NpX3dhaXRfc2Nhbl0NClsgIDI3Ni40NjU0NzddIFBp
ZDogMjc2NSwgY29tbTogc2ggVGFpbnRlZDogUCAgICAgICAgVyAgLS0tLS0t
LS0tLS0tLS0tICAgIDIuNi4zMiAjMQ0KWyAgMjc2LjQ4MjE2OV0gQ2FsbCBU
cmFjZToNClsgIDI3Ni40OTg2MTBdICBbPGZmZmZmZmZmODEwNzBmZTc+XSA/
IHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4ODcvMHhjMA0KWyAgMjc2LjUxNTQw
NV0gIFs8ZmZmZmZmZmY4MTA3MTBkNj5dID8gd2Fybl9zbG93cGF0aF9mbXQr
MHg0Ni8weDUwDQpbICAyNzYuNTMyMDU5XSAgWzxmZmZmZmZmZmEwM2JkYTNm
Pl0gPyBiY2FjaGVfZGV2aWNlX2xpbmsrMHhkZi8weDExMCBbYmNhY2hlXQ0K
WyAgMjc2LjU0ODgwOF0gIFs8ZmZmZmZmZmZhMDNiZmEwOD5dID8gYmNoX2Nh
Y2hlZF9kZXZfYXR0YWNoKzB4NDc4LzB4NGYwIFtiY2FjaGVdDQpbICAyNzYu
NTY1NTY5XSAgWzxmZmZmZmZmZmEwM2M0YTE3Pl0gPyBiY2hfY2FjaGVkX2Rl
dl9zdG9yZSsweDYyNy8weDc4MCBbYmNhY2hlXQ0KWyAgMjc2LjU4MjQxOF0g
IFs8ZmZmZmZmZmY4MTE2NzgzYT5dID8gYWxsb2NfcGFnZXNfY3VycmVudCsw
eGFhLzB4MTEwDQpbICAyNzYuNTk5MzQxXSAgWzxmZmZmZmZmZjgxMjAzYjE1
Pl0gPyBzeXNmc193cml0ZV9maWxlKzB4ZTUvMHgxNzANClsgIDI3Ni42MTYx
NDJdICBbPGZmZmZmZmZmODExODg3Yjg+XSA/IHZmc193cml0ZSsweGI4LzB4
MWEwDQpbICAyNzYuNjMyNjA3XSAgWzxmZmZmZmZmZjgxMTg5MGIxPl0gPyBz
eXNfd3JpdGUrMHg1MS8weDkwDQpbICAyNzYuNjQ4NjcxXSAgWzxmZmZmZmZm
ZjgxMDBjMDcyPl0gPyBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIN
ClsgIDI3Ni42NjQ3NTZdIC0tLVsgZW5kIHRyYWNlIDlmNWQ0ZmNkZDBjM2Vk
ZmMgXS0tLQ0KDQpXZSBmb3JnZXQgdG8gY2xlYXIgQkNBQ0hFX0RFVl9VTkxJ
TktfRE9ORSBmbGFnIGluIGJjYWNoZV9kZXZpY2VfYXR0YWNoKCkNCmZ1bmN0
aW9uIHdoZW4gd2UgYXR0YWNoIGEgYmFja2luZyBkZXZpY2UgZmlyc3QgdGlt
ZS4gIEFmdGVyIGRldGFjaGluZyB0aGlzDQpiYWNraW5nIGRldmljZSwgdGhp
cyBmbGFnIHdpbGwgYmUgdHJ1ZSBhbmQgc3lzZnNfcmVtb3ZlX2xpbmsoKSBp
c24ndCBjYWxsZWQgaW4NCmJjYWNoZV9kZXZpY2VfdW5saW5rKCkuICBUaGVu
IHdoZW4gd2UgYXR0YWNoIHRoaXMgYmFja2luZyBkZXZpY2UgYWdhaW4sDQpz
eXNmc19jcmVhdGVfbGluaygpIHdpbGwgcmV0dXJuIEVFWElTVCBlcnJvciBp
biBiY2FjaGVfZGV2aWNlX2xpbmsoKS4NCg0KU28gdGhlIGZpeCBpcyB0cml2
YWwgYW5kIHdlIGNsZWFyIHRoaXMgZmxhZyBpbiBiY2FjaGVfZGV2aWNlX2xp
bmsoKS4NCg0KU2lnbmVkLW9mZi1ieTogWmhlbmcgTGl1IDx3ZW5xaW5nLmx6
QHRhb2Jhby5jb20+DQpUZXN0ZWQtYnk6IEpvc2h1YSBTY2htaWQgPGpzY2ht
aWRAc3VzZS5jb20+DQotLS0NCiBkcml2ZXJzL21kL2JjYWNoZS9zdXBlci5j
IHwgMiArKw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMgYi9kcml2
ZXJzL21kL2JjYWNoZS9zdXBlci5jDQppbmRleCA0ZGQyYmI3Li5mNjI0YWU4
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYw0KKysr
IGIvZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYw0KQEAgLTcwOCw2ICs3MDgs
OCBAQCBzdGF0aWMgdm9pZCBiY2FjaGVfZGV2aWNlX2xpbmsoc3RydWN0IGJj
YWNoZV9kZXZpY2UgKmQsIHN0cnVjdCBjYWNoZV9zZXQgKmMsDQogCVdBUk4o
c3lzZnNfY3JlYXRlX2xpbmsoJmQtPmtvYmosICZjLT5rb2JqLCAiY2FjaGUi
KSB8fA0KIAkgICAgIHN5c2ZzX2NyZWF0ZV9saW5rKCZjLT5rb2JqLCAmZC0+
a29iaiwgZC0+bmFtZSksDQogCSAgICAgIkNvdWxkbid0IGNyZWF0ZSBkZXZp
Y2UgPC0+IGNhY2hlIHNldCBzeW1saW5rcyIpOw0KKw0KKwljbGVhcl9iaXQo
QkNBQ0hFX0RFVl9VTkxJTktfRE9ORSwgJmQtPmZsYWdzKTsNCiB9DQoNCiBz
dGF0aWMgdm9pZCBiY2FjaGVfZGV2aWNlX2RldGFjaChzdHJ1Y3QgYmNhY2hl
X2RldmljZSAqZCkNCi0tIA0KMi4xLjINCg0K

--1866506367-1181759750-1429041827=:12234
Content-Type: TEXT/x-diff; name=bcache-rcu-sched-bugfix.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-rcu-sched-bugfix.patch

CQ0KRnJvbToJWmhlbmcgTGl1IDxnbmVoenVpbC5saXVAZ21haWwuY29tPg0K
VG86CWxpbnV4LWJjYWNoZUB2Z2VyLmtlcm5lbC5vcmcNCkNjOglaaGVuZyBM
aXUgPHdlbnFpbmcubHpAdGFvYmFvLmNvbT4sIEpvc2h1YSBTY2htaWQgPGpz
Y2htaWRAc3VzZS5jb20+LCBaaHUgWWFuaGFpIDx6aHUueWFuaGFpQGdtYWls
LmNvbT4sIEtlbnQgT3ZlcnN0cmVldCA8a21vQGRhdGVyYWluYy5jb20+DQpT
dWJqZWN0OglbUEFUQ0ggdjJdIGJjYWNoZTogZml4IGEgbGl2ZWxvY2sgaW4g
YnRyZWUgbG9jaw0KRGF0ZToJV2VkLCAyNSBGZWIgMjAxNSAyMDozMjowOSAr
MDgwMCAoMDIvMjUvMjAxNSAwNDozMjowOSBBTSkNCkZyb206IFpoZW5nIExp
dSA8d2VucWluZy5sekB0YW9iYW8uY29tPg0KDQpUaGlzIGNvbW1pdCB0cmll
cyB0byBmaXggYSBsaXZlbG9jayBpbiBiY2FjaGUuICBUaGlzIGxpdmVsb2Nr
IG1pZ2h0DQpoYXBwZW4gd2hlbiB3ZSBjYXVzZXMgYSBodWdlIG51bWJlciBv
ZiBjYWNoZSBtaXNzZXMgc2ltdWx0YW5lb3VzbHkuDQoNCldoZW4gd2UgZ2V0
IGEgY2FjaGUgbWlzcywgYmNhY2hlIHdpbGwgZXhlY3V0ZSB0aGUgZm9sbG93
aW5nIHBhdGguDQoNCi0+Y2FjaGVkX2Rldl9tYWtlX3JlcXVlc3QoKQ0KICAt
PmNhY2hlZF9kZXZfcmVhZCgpDQogICAgLT5jYWNoZWRfbG9va3VwKCkNCiAg
ICAgIC0+YmNoLT5idHJlZV9tYXBfa2V5cygpDQogICAgICAgIC0+YnRyZWVf
cm9vdCgpICA8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogICAgICAgICAg
LT5iY2hfYnRyZWVfbWFwX2tleXNfcmVjdXJzZSgpICAgICAgICB8DQogICAg
ICAgICAgICAtPmNhY2hlX2xvb2t1cF9mbigpICAgICAgICAgICAgICAgICB8
DQogICAgICAgICAgICAgIC0+Y2FjaGVkX2Rldl9jYWNoZV9taXNzKCkgICAg
ICAgICB8DQogICAgICAgICAgICAgICAgLT5iY2hfYnRyZWVfaW5zZXJ0X2No
ZWNrX2tleSgpIC18DQogICAgICAgICAgICAgICAgICBbSWYgYnRyZWUtPnNl
cSBpcyBub3QgZXF1YWwgdG8gc2VxICsgMSwgd2Ugc2hvdWxkIHJldHVybg0K
ICAgICAgICAgICAgICAgICAgIEVJTlRSIGFuZCB0cmF2ZXJzZSBidHJlZSBh
Z2Fpbi5dDQoNCkluIGJjaF9idHJlZV9pbnNlcnRfY2hlY2tfa2V5KCkgZnVu
Y3Rpb24gd2UgZmlyc3QgbmVlZCB0byBjaGVjayB1cGdyYWRlDQpmbGFnIChv
cC0+bG9jayA9PSAtMSksIGFuZCB3aGVuIHRoaXMgZmxhZyBpcyB0cnVlIHdl
IG5lZWQgdG8gcmVsZWFzZQ0KcmVhZCBidHJlZS0+bG9jayBhbmQgdHJ5IHRv
IHRha2Ugd3JpdGUgYnRyZWUtPmxvY2suICBEdXJpbmcgdGFraW5nIGFuZA0K
cmVsZWFzaW5nIHRoaXMgd3JpdGUgbG9jaywgYnRyZWUtPnNlcSB3aWxsIGJl
IG1vbm90b25lIGluY3JlYXNlZCBpbg0Kb3JkZXIgdG8gcHJldmVudCBvdGhl
ciB0aHJlYWRzIG1vZGlmeSB0aGlzIGluIGNhY2hlIG1pc3MgKHNlZSBidHJl
ZS5oOjc0KS4NCkJ1dCBpZiB0aGVyZSBhcmUgc29tZSBjYWNoZSBtaXNzZXMg
Y2F1c2VkIGJ5IHNvbWUgcmVxdWVzdGVkLCB3ZSBjb3VsZA0KbWVldCBhIGxp
dmVsb2NrIGJlY2F1c2UgYnRyZWUtPnNlcSBpcyBhbHdheXMgY2hhbmdlZCBi
eSBvdGhlcnMuICBUaHVzIG5vDQpvbmUgY2FuIG1ha2UgcHJvZ3Jlc3MuDQoN
ClRoaXMgY29tbWl0IHdpbGwgdHJ5IHRvIHRha2Ugd3JpdGUgYnRyZWUtPmxv
Y2sgaWYgaXQgZW5jb3VudGVycyBhIHJhY2UNCndoZW4gd2UgdHJhdmVyc2Ug
YnRyZWUuICBBbHRob3VnaCBpdCBzYWNyaWZpY2UgdGhlIHNjYWxhYmlsaXR5
IGJ1dCB3ZQ0KY2FuIGVuc3VyZSB0aGF0IG9ubHkgb25lIGNhbiBtb2RpZnkg
dGhlIGJ0cmVlLg0KDQpTaWduZWQtb2ZmLWJ5OiBaaGVuZyBMaXUgPHdlbnFp
bmcubHpAdGFvYmFvLmNvbT4NClRlc3RlZC1ieTogSm9zaHVhIFNjaG1pZCA8
anNjaG1pZEBzdXNlLmNvbT4NCkNjOiBKb3NodWEgU2NobWlkIDxqc2NobWlk
QHN1c2UuY29tPg0KQ2M6IFpodSBZYW5oYWkgPHpodS55YW5oYWlAZ21haWwu
Y29tPg0KQ2M6IEtlbnQgT3ZlcnN0cmVldCA8a21vQGRhdGVyYWluYy5jb20+
DQotLS0NCmNoYW5nZWxvZzoNCnYyOiBmaXggYSBidWcgdGhhdCBzdG9wcyBh
bGwgY29uY3VycmVuY3kgd3JpdGVzIHVuY29uZGl0aW9uYWxseS4NCg0KIGRy
aXZlcnMvbWQvYmNhY2hlL2J0cmVlLmMgfCAgICA0ICsrKy0NCiAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNoZS9idHJlZS5jIGIvZHJpdmVy
cy9tZC9iY2FjaGUvYnRyZWUuYw0KaW5kZXggMjE4ZjIxYS4uNDM4MjlkOSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvYmNhY2hlL2J0cmVlLmMNCisrKyBi
L2RyaXZlcnMvbWQvYmNhY2hlL2J0cmVlLmMNCkBAIC0yMTYzLDggKzIxNjMs
MTAgQEAgaW50IGJjaF9idHJlZV9pbnNlcnRfY2hlY2tfa2V5KHN0cnVjdCBi
dHJlZSAqYiwgc3RydWN0IGJ0cmVlX29wICpvcCwNCiAJCXJ3X2xvY2sodHJ1
ZSwgYiwgYi0+bGV2ZWwpOw0KIA0KIAkJaWYgKGItPmtleS5wdHJbMF0gIT0g
YnRyZWVfcHRyIHx8DQotCQkgICAgYi0+c2VxICE9IHNlcSArIDEpDQorICAg
ICAgICAgICAgICAgICAgIGItPnNlcSAhPSBzZXEgKyAxKSB7DQorICAgICAg
ICAgICAgICAgICAgICAgICBvcC0+bG9jayA9IGItPmxldmVsOw0KIAkJCWdv
dG8gb3V0Ow0KKyAgICAgICAgICAgICAgIH0NCiAJfQ0KIA0KIAlTRVRfS0VZ
X1BUUlMoY2hlY2tfa2V5LCAxKTsNCg==

--1866506367-1181759750-1429041827=:12234
Content-Type: TEXT/x-diff; name=bcache-cond_resched.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-cond_resched.patch

RnJvbSBmMGU2MzIwYTc4NzRhZjQzNDU3NWYzN2ExMWVjNmU0OTkyY2VmNzkw
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogS2VudCBPdmVyc3Ry
ZWV0IDxrbW9AZGF0ZXJhaW5jLmNvbT4NCkRhdGU6IFNhdCwgMSBOb3YgMjAx
NCAxMzo0NDo0NyAtMDcwMA0KU3ViamVjdDogW1BBVENIIDEvNV0gYmNhY2hl
OiBBZGQgYSBjb25kX3Jlc2NoZWQoKSBjYWxsIHRvIGdjDQpHaXQtY29tbWl0
OiBmMGU2MzIwYTc4NzRhZjQzNDU3NWYzN2ExMWVjNmU0OTkyY2VmNzkwDQpQ
YXRjaC1tYWlubGluZTogU3VibWl0dGVkDQpSZWZlcmVuY2VzOiBibmMjOTEw
NDQwDQoNCkNoYW5nZS1pZDogSWQ0ZjE4YzUzM2I4MGRkYjQwZGY5NGVkMGJi
NWUyYTIzNmE0YmMzMjUNClNpZ25lZC1vZmYtYnk6IFRha2FzaGkgSXdhaSA8
dGl3YWlAc3VzZS5kZT4NCg0KLS0tDQogZHJpdmVycy9tZC9iY2FjaGUvYnRy
ZWUuYyB8IDEgKw0KICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykN
Cg0KLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYwkyMDE0LTExLTAz
IDE2OjUxOjAxLjcyMDAwMDAwMCAtMDgwMA0KKysrIGIvZHJpdmVycy9tZC9i
Y2FjaGUvYnRyZWUuYwkyMDE0LTExLTAzIDE2OjUxOjI2LjQ1NjAwMDAwMCAt
MDgwMA0KQEAgLTE3NDEsNiArMTc0MSw3IEBADQogCWRvIHsNCiAJCXJldCA9
IGJ0cmVlX3Jvb3QoZ2Nfcm9vdCwgYywgJm9wLCAmd3JpdGVzLCAmc3RhdHMp
Ow0KIAkJY2xvc3VyZV9zeW5jKCZ3cml0ZXMpOw0KKwkJY29uZF9yZXNjaGVk
KCk7DQogDQogCQlpZiAocmV0ICYmIHJldCAhPSAtRUFHQUlOKQ0KIAkJCXBy
X3dhcm4oImdjIGZhaWxlZCEiKTsNCg==

--1866506367-1181759750-1429041827=:12234--
