From: Thomas Klaube <thomas@klaube.net>
Subject: Re: bcache bug / fs freeze on heavy IO
Date: Tue, 26 Aug 2014 08:38:15 +0200 (CEST)
Message-ID: <2025796026.5376048.1409035095370.JavaMail.zimbra@klaube.net>
References: <318258231.4483994.1408694008758.JavaMail.zimbra@klaube.net> <58978953.4484590.1408694179180.JavaMail.zimbra@klaube.net> <CALJ65zn9yWeRLPZd8EMJSW_+ff1VeN159VBexwgCHRbfENHNCw@mail.gmail.com> <CALJ65z=ky_rC_A7-DP0mqWVBiC3RqUFYR02vju4FUfizOuXhXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from orion.efm.de ([195.190.148.230]:34297 "EHLO orion.efm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbaHZGiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 26 Aug 2014 02:38:18 -0400
In-Reply-To: <CALJ65z=ky_rC_A7-DP0mqWVBiC3RqUFYR02vju4FUfizOuXhXg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org

----- Urspr=C3=BCngliche Mail -----
> Von: "Kent Overstreet" <kmo@daterainc.com>
> An: "Thomas Klaube" <thomas@klaube.net>
> CC: linux-bcache@vger.kernel.org
> Gesendet: Freitag, 22. August 2014 11:38:05
> Betreff: Re: bcache bug / fs freeze on heavy IO
>=20
> there weren't any bcache changes in 3.16 from 3.15, so unless you hit
> this again or someone else reports it I would think you just got
> unlucky.

Hi,

I have similar issue again. This is with kernel 3.13.0-34 (ubuntu
server 14.04.1 LTS). This also happend during a fio benchmark on a
bcache device:

Aug 26 01:52:06 ubuntu kernel: [18378.656038] BUG: unable to handle ker=
nel NULL pointer dereference at 0000000000000099
Aug 26 01:52:06 ubuntu kernel: [18378.656067] IP: [<ffffffffa0306bb6>] =
bch_btree_insert_node+0x16/0x2b0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656093] PGD 0=20
Aug 26 01:52:06 ubuntu kernel: [18378.656101] Oops: 0000 [#1] SMP=20
Aug 26 01:52:06 ubuntu kernel: [18378.656113] Modules linked in: bcache=
 binfmt_misc x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel k=
vm crct10dif_pclmul ast ttm crc32_pclmul ghash_clmulni_intel drm_kms_he=
lper aesni_intel aes_x86_64 drm lrw gf128mul glue_helper ablk_helper sy=
scopyarea cryptd sysfillrect sysimgblt lpc_ich shpchp mei_me mei bondin=
g lp parport ipmi_si video mac_hid acpi_pad hid_generic usbhid ses hid =
enclosure usb_storage megaraid_sas ahci libahci igb e1000e i2c_algo_bit=
 dca ptp pps_core
Aug 26 01:52:06 ubuntu kernel: [18378.656277] CPU: 3 PID: 1770 Comm: bc=
ache_gc Not tainted 3.13.0-34-generic #60-Ubuntu
Aug 26 01:52:06 ubuntu kernel: [18378.656299] Hardware name: Supermicro=
 X10SLM-F/X10SLM-F, BIOS 2.0 04/24/2014
Aug 26 01:52:06 ubuntu kernel: [18378.656319] task: ffff8804045fc7d0 ti=
: ffff880405b28000 task.ti: ffff880405b28000
Aug 26 01:52:06 ubuntu kernel: [18378.656340] RIP: 0010:[<ffffffffa0306=
bb6>]  [<ffffffffa0306bb6>] bch_btree_insert_node+0x16/0x2b0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656370] RSP: 0018:ffff880405b297d=
8  EFLAGS: 00010246
Aug 26 01:52:06 ubuntu kernel: [18378.656385] RAX: ffff8803fe5c0000 RBX=
: ffff8802f5824400 RCX: 0000000000000000
Aug 26 01:52:06 ubuntu kernel: [18378.656405] RDX: ffff880405b29858 RSI=
: ffff880405b29dd4 RDI: ffffffffffffffff
Aug 26 01:52:06 ubuntu kernel: [18378.656424] RBP: ffff880405b297f8 R08=
: 0000000000000000 R09: ffff880405b29880
Aug 26 01:52:06 ubuntu kernel: [18378.656444] R10: 0000000000000001 R11=
: 000007ffffffffff R12: 0000000000000000
Aug 26 01:52:06 ubuntu kernel: [18378.656464] R13: ffff880405b29858 R14=
: ffff880405b29828 R15: 0000000000004587
Aug 26 01:52:06 ubuntu kernel: [18378.656484] FS:  0000000000000000(000=
0) GS:ffff88041fd80000(0000) knlGS:0000000000000000
Aug 26 01:52:06 ubuntu kernel: [18378.656507] CS:  0010 DS: 0000 ES: 00=
00 CR0: 0000000080050033
Aug 26 01:52:06 ubuntu kernel: [18378.656524] CR2: 0000000000000099 CR3=
: 0000000001c0e000 CR4: 00000000001407e0
Aug 26 01:52:06 ubuntu kernel: [18378.656544] DR0: 0000000000000000 DR1=
: 0000000000000000 DR2: 0000000000000000
Aug 26 01:52:06 ubuntu kernel: [18378.656564] DR3: 0000000000000000 DR6=
: 00000000fffe0ff0 DR7: 0000000000000400
Aug 26 01:52:06 ubuntu kernel: [18378.656584] Stack:
Aug 26 01:52:06 ubuntu kernel: [18378.656590]  ffff8802f5824400 ffff880=
039161800 0000000000000000 ffff880405b29828
Aug 26 01:52:06 ubuntu kernel: [18378.656614]  ffff880405b29910 fffffff=
fa0306a71 0000000000000000 ffff880405b29ab0
Aug 26 01:52:06 ubuntu kernel: [18378.656638]  000010b71d30b6be ffff880=
405b29dd4 0000000000000000 ffff8804045fc7d0
Aug 26 01:52:06 ubuntu kernel: [18378.656661] Call Trace:
Aug 26 01:52:06 ubuntu kernel: [18378.656672]  [<ffffffffa0306a71>] btr=
ee_split+0x441/0x570 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656692]  [<ffffffff810753d5>] ? d=
el_timer+0x55/0x70
Aug 26 01:52:06 ubuntu kernel: [18378.656709]  [<ffffffff81081f89>] ? t=
ry_to_grab_pending+0xa9/0x160
Aug 26 01:52:06 ubuntu kernel: [18378.656728]  [<ffffffffa0306cc1>] bch=
_btree_insert_node+0x121/0x2b0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656750]  [<ffffffffa030787e>] btr=
ee_gc_recurse+0xa2e/0xbb0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656771]  [<ffffffffa0309755>] ? b=
ch_btree_ptr_invalid+0xa5/0xd0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656793]  [<ffffffffa03072d6>] btr=
ee_gc_recurse+0x486/0xbb0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656813]  [<ffffffff810a7145>] ? l=
oad_balance+0x185/0x890
Aug 26 01:52:06 ubuntu kernel: [18378.656831]  [<ffffffffa0309755>] ? b=
ch_btree_ptr_invalid+0xa5/0xd0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656852]  [<ffffffff8101b7e9>] ? s=
ched_clock+0x9/0x10
Aug 26 01:52:06 ubuntu kernel: [18378.656869]  [<ffffffffa0302380>] ? b=
tree_node_free+0x1d0/0x1d0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656889]  [<ffffffffa0305803>] ? b=
tree_gc_mark_node+0x63/0x210 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656910]  [<ffffffffa0307feb>] bch=
_btree_gc+0x41b/0x5a0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656930]  [<ffffffff8171fd41>] ? _=
_schedule+0x381/0x7d0
Aug 26 01:52:06 ubuntu kernel: [18378.656948]  [<ffffffffa03081a8>] bch=
_gc_thread+0x38/0x120 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656967]  [<ffffffffa0308170>] ? b=
ch_btree_gc+0x5a0/0x5a0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.656986]  [<ffffffff8108b3d2>] kth=
read+0xd2/0xf0
Aug 26 01:52:06 ubuntu kernel: [18378.657608]  [<ffffffff8108b300>] ? k=
thread_create_on_node+0x1d0/0x1d0
Aug 26 01:52:06 ubuntu kernel: [18378.658237]  [<ffffffff8172c6bc>] ret=
_from_fork+0x7c/0xb0
Aug 26 01:52:06 ubuntu kernel: [18378.658845]  [<ffffffff8108b300>] ? k=
thread_create_on_node+0x1d0/0x1d0
Aug 26 01:52:06 ubuntu kernel: [18378.659445] Code: 24 60 e8 5e a1 da e=
0 eb 8a 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 =
41 56 41 55 49 89 d5 41 54 49 89 cc 53 <80> bf 9a 00 00 00 00 48 89 fb =
0f 85 6c 02 00 00 4c 8b 8b 80 00=20
Aug 26 01:52:06 ubuntu kernel: [18378.660709] RIP  [<ffffffffa0306bb6>]=
 bch_btree_insert_node+0x16/0x2b0 [bcache]
Aug 26 01:52:06 ubuntu kernel: [18378.661333]  RSP <ffff880405b297d8>
Aug 26 01:52:06 ubuntu kernel: [18378.661938] CR2: 0000000000000099
Aug 26 01:52:06 ubuntu kernel: [18378.685807] ---[ end trace c759c6ac8f=
543aa1 ]---

There are several fio processes hanging in d state and kill -9 does
not work. Elevator is cfq, here is the fio setup:

[rnd]
rw=3Drandrw
ramp_time=3D30
runtime=3D36600
time_based
rwmixread=3D30
size=3D100g
refill_buffers=3D1
directory=3D.
iodepth=3D64
direct=3D1
blocksize=3D4k
numjobs=3D16
group_reporting
ioengine=3Dlibaio
loops=3D1

the fio job reads/writes to preallocated files and this fio job is
run in parallel with a similar fio job (same setup) on a non-bcached
device. There is no error on the fio job that runs on the non-bcache
device (job is successfully finishing after 36600 sec with reasonable
results). There are no errors in the controller logs and there are no
other errors in dmesg.

Any ideas? Probably I can reproduce this.=20

Regards
Thomas Klaube
