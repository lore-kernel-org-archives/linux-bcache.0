From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: bcache blocking ops and lockdep warnings
Date: Wed, 10 Dec 2014 11:51:13 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1412101149490.26982@ware.dreamhost.com>
References: <20141210061552.GA2062@sucs.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1866506367-744805583-1418241074=:26982"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:35423 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802AbaLJTvP (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 10 Dec 2014 14:51:15 -0500
In-Reply-To: <20141210061552.GA2062@sucs.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1866506367-744805583-1418241074=:26982
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Wed, 10 Dec 2014, Sitsofe Wheeler wrote:

> Hi,
> 
> After doing
> make-bcache -B /dev/sdf
> make-bcache -C /dev/sdh
> ls -l /sys/fs/bcache
> echo 1110734d-230c-4b8f-a63d-dff472a0977b > /sys/block/bcache0/bcache/attach
> 
> the following warnings were produced with a 3.18.0.x86_64-01967-g86c6a2f
> kernel:

Try the attached patches.

These have resolved all of the bcache backtraces that we have had issues 
with in the past few months.

--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298


> 
> [   75.218601] bcache: register_bdev() registered backing device sdf
> [   82.616568] bcache: run_cache_set() invalidating existing data
> [   82.621589] ------------[ cut here ]------------
> [   82.622890] WARNING: CPU: 1 PID: 979 at kernel/sched/core.c:7301 __might_sleep+0x5c/0xa0()
> [   82.624344] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff8155afc8>] bch_allocator_thread+0xd8/0xe30
> [   82.625979] CPU: 1 PID: 979 Comm: bcache_allocato Not tainted 3.18.0.x86_64-01967-g86c6a2f #162
> [   82.627468] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
> [   82.628949]  0000000000000009 ffff8800da963ce8 ffffffff816ea8af 0000000000000001
> [   82.634007]  ffff8800da963d38 ffff8800da963d28 ffffffff81073f3c ffff8800da963d28
> [   82.639020]  ffffffff819d431c 0000000000000038 0000000000000000 ffff8800e468a680
> [   82.643967] Call Trace:
> [   82.645045]  [<ffffffff816ea8af>] dump_stack+0x4e/0x68
> [   82.646345]  [<ffffffff81073f3c>] warn_slowpath_common+0x7c/0xa0
> [   82.647622]  [<ffffffff81073fc6>] warn_slowpath_fmt+0x46/0x50
> [   82.648954]  [<ffffffff8155afc8>] ? bch_allocator_thread+0xd8/0xe30
> [   82.650338]  [<ffffffff8155afc8>] ? bch_allocator_thread+0xd8/0xe30
> [   82.651667]  [<ffffffff810a2e2c>] __might_sleep+0x5c/0xa0
> [   82.652959]  [<ffffffff8155b0b7>] bch_allocator_thread+0x1c7/0xe30
> [   82.654335]  [<ffffffff8155aef0>] ? bch_invalidate_one_bucket+0x80/0x80
> [   82.655672]  [<ffffffff81091a03>] kthread+0x103/0x110
> [   82.656939]  [<ffffffff81091900>] ? __kthread_unpark+0x50/0x50
> [   82.658294]  [<ffffffff816f43fc>] ret_from_fork+0x7c/0xb0
> [   82.659664]  [<ffffffff81091900>] ? __kthread_unpark+0x50/0x50
> [   82.660970] ---[ end trace 15295ea1be01c8a2 ]---
> [   82.683570] ------------[ cut here ]------------
> [   82.684559] WARNING: CPU: 7 PID: 974 at kernel/locking/lockdep.c:712 __lock_acquire+0x21c/0x1c60()
> [   82.684559] CPU: 7 PID: 974 Comm: bcache-register Tainted: G        W      3.18.0.x86_64-01967-g86c6a2f #162
> [   82.684559] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
> [   82.684559]  0000000000000009 ffff8800dac8f988 ffffffff816ea8af 0000000000000000
> [   82.684559]  0000000000000000 ffff8800dac8f9c8 ffffffff81073f3c ffff8800dac8f9c8
> [   82.684559]  ffffffff82668240 0000000000000000 ffff8800dac3da88 0000000000000001
> [   82.684559] Call Trace:
> [   82.684559]  [<ffffffff816ea8af>] dump_stack+0x4e/0x68
> [   82.684559]  [<ffffffff81073f3c>] warn_slowpath_common+0x7c/0xa0
> [   82.684559]  [<ffffffff8107403a>] warn_slowpath_null+0x1a/0x20
> [   82.684559]  [<ffffffff810c0d5c>] __lock_acquire+0x21c/0x1c60
> [   82.684559]  [<ffffffff813b24ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   82.684559]  [<ffffffff810d624f>] ? rcu_irq_exit+0x8f/0xb0
> [   82.684559]  [<ffffffff810c2706>] ? __lock_acquire+0x1bc6/0x1c60
> [   82.684559]  [<ffffffff810c305c>] lock_acquire+0xfc/0x150
> [   82.684559]  [<ffffffff8156346c>] ? mca_reap+0x6c/0x170
> [   82.684559]  [<ffffffff810bc131>] down_write_trylock+0x61/0x80
> [   82.684559]  [<ffffffff8156346c>] ? mca_reap+0x6c/0x170
> [   82.684559]  [<ffffffff8156346c>] mca_reap+0x6c/0x170
> [   82.684559]  [<ffffffff81563900>] mca_alloc+0xe0/0x4b0
> [   82.684559]  [<ffffffff81564893>] __bch_btree_node_alloc+0xb3/0x240
> [   82.684559]  [<ffffffff815760da>] run_cache_set+0x6ea/0x950
> [   82.684559]  [<ffffffff8123fc6e>] ? kernfs_add_one+0x10e/0x160
> [   82.684559]  [<ffffffff815780cf>] register_bcache+0x167f/0x19e0
> [   82.684559]  [<ffffffff813a6bcf>] kobj_attr_store+0xf/0x20
> [   82.684559]  [<ffffffff812419a8>] sysfs_kf_write+0x48/0x60
> [   82.684559]  [<ffffffff81241247>] kernfs_fop_write+0xe7/0x170
> [   82.684559]  [<ffffffff811cde6b>] vfs_write+0xcb/0x1d0
> [   82.684559]  [<ffffffff816f50dc>] ? retint_swapgs+0x13/0x1b
> [   82.684559]  [<ffffffff811ce069>] SyS_write+0x49/0xb0
> [   82.684559]  [<ffffffff816f44a9>] system_call_fastpath+0x12/0x17
> [   82.684559] ---[ end trace 15295ea1be01c8a3 ]---
> [   82.763919] bcache: register_cache() registered cache device sdh
> 
> -- 
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1866506367-744805583-1418241074=:26982
Content-Type: TEXT/x-diff; name=bcache-rcu-sched-bugfix.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-rcu-sched-bugfix.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL2J0cmVlLmMgYi9kcml2
ZXJzL21kL2JjYWNoZS9idHJlZS5jDQppbmRleCAwMGNkZTQwLi5kMTQ1NjBh
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYw0KKysr
IGIvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYw0KQEAgLTIxNjIsOCArMjE2
MiwxMCBAQCBpbnQgYmNoX2J0cmVlX2luc2VydF9jaGVja19rZXkoc3RydWN0
IGJ0cmVlICpiLCBzdHJ1Y3QgYnRyZWVfb3AgKm9wLA0KIAkJcndfbG9jayh0
cnVlLCBiLCBiLT5sZXZlbCk7DQogDQogCQlpZiAoYi0+a2V5LnB0clswXSAh
PSBidHJlZV9wdHIgfHwNCi0JCSAgICBiLT5zZXEgIT0gc2VxICsgMSkNCisJ
CSAgICBiLT5zZXEgIT0gc2VxICsgMSkgew0KKwkJCW9wLT5sb2NrID0gYi0+
Yy0+cm9vdC0+bGV2ZWwgKyAxOw0KIAkJCWdvdG8gb3V0Ow0KKwkJfQ0KIAl9
DQogDQogCVNFVF9LRVlfUFRSUyhjaGVja19rZXksIDEpOw0KLS0gDQoxLjcu
MQ0K

--1866506367-744805583-1418241074=:26982
Content-Type: TEXT/x-diff; name=bcache-cond_resched.patch
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=bcache-cond_resched.patch

LS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYnRyZWUuYwkyMDE0LTExLTAzIDE2
OjUxOjAxLjcyMDAwMDAwMCAtMDgwMA0KKysrIGIvZHJpdmVycy9tZC9iY2Fj
aGUvYnRyZWUuYwkyMDE0LTExLTAzIDE2OjUxOjI2LjQ1NjAwMDAwMCAtMDgw
MA0KQEAgLTE3NDEsNiArMTc0MSw3IEBADQogCWRvIHsNCiAJCXJldCA9IGJ0
cmVlX3Jvb3QoZ2Nfcm9vdCwgYywgJm9wLCAmd3JpdGVzLCAmc3RhdHMpOw0K
IAkJY2xvc3VyZV9zeW5jKCZ3cml0ZXMpOw0KKwkJY29uZF9yZXNjaGVkKCk7
DQogDQogCQlpZiAocmV0ICYmIHJldCAhPSAtRUFHQUlOKQ0KIAkJCXByX3dh
cm4oImdjIGZhaWxlZCEiKTsNCg==

--1866506367-744805583-1418241074=:26982--
