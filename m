From: Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel BUG registering cache device
Date: Mon, 23 Jan 2012 12:33:28 +0000
Message-ID: <CAFtEh-efCC3LM1Bm9WHfLyrnucBTTGHTiu7FR=1vtDTMyudmSw@mail.gmail.com>
References: <CAFtEh-cC=eSSTQfxyN64CQtudwmjZmTh6UZae8tDXLYkR7vbvw@mail.gmail.com>
	<CAC7rs0v6VKfjTmUmkMvqPWwAeK6aS_iC8Diw8Lu9gxLHc4Pp=Q@mail.gmail.com>
	<CAH+dOxLVxag=Yx5TtcfP+dCh7sp8bu1OZy8gTtezn7b3j95J8A@mail.gmail.com>
	<CAFtEh-fr1Z0Va-cgFrfuvf3fCo5GJET8vfTYy_JcK2YwayEhig@mail.gmail.com>
	<CAH+dOx+Vk0aL0ETxzxri7PCHqhABYePXWp1yvUsrJxjQ7qXKdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOx+Vk0aL0ETxzxri7PCHqhABYePXWp1yvUsrJxjQ7qXKdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Cool thanks, let me know when there's something to test and I'll let
you know how it goes.

On 23 January 2012 12:09, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
> So, we called a null function pointer. Looks like I broke the ioctl
> handler somehow, I'll check that out tomorrow.
>
> On Mon, Jan 23, 2012 at 3:52 AM, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>> Excellent thanks a lot Kent, that's fixed the problem with the lv ca=
che device.
>>
>> I am experiencing a problem attempting to use a rbd as a backing
>> device also. This was working in 3.1 partially so I'm not sure what'=
s
>> changed there. The following is output to console & syslog whenever
>> the bcache0 device is accessed by something. Well by blkid or
>> mkfs.ext4.
>>
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0280.993416] BUG: unable to hand=
le
>> kernel NULL pointer dereference at =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 (null)
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0280.995317] IP: [< =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0(null)>]
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0(null)
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0280.997180] PGD 401b0d067 PUD 3=
fbfa1067 PMD 0
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0280.999034] Oops: 0010 [#2] SMP
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.000831] CPU 2
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.000843] Modules linked in: =
bnep
>> rfcomm bluetooth ip6table_filter ip6_tables ebtable_nat ebtables
>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpud=
p
>> iptable_filter ip_tables x_tables kvm_intel kvm parport_pc ppdev
>> binfmt_misc usbhid hid snd_hda_codec_hdmi snd_hda_codec_realtek brid=
ge
>> stp snd_seq_midi psmouse eeepc_wmi radeon ttm drm_kms_helper asus_wm=
i
>> snd_rawmidi drm sparse_keymap snd_seq_midi_event snd_hda_intel
>> snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device snd
>> mac_hid video serio_raw soundcore dm_multipath wmi i2c_algo_bit
>> snd_page_alloc mei(C) rbd libceph lp parport firewire_ohci
>> firewire_core btrfs pata_marvell crc_itu_t e1000e r8169 zlib_deflate
>> libcrc32c
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.012308]
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.014277] Pid: 4152, comm: bl=
kid
>> Tainted: G =C2=A0 =C2=A0 =C2=A0D =C2=A0C =C2=A0 3.2.0-9-generic #17~=
oneiric1 System
>> manufacturer System Product Name/P8H67-M EVO
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.016330] RIP:
>> 0010:[<0000000000000000>] =C2=A0[< =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
(null)>] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (null)
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.018364] RSP: 0018:ffff8803f=
bc3de60
>> =C2=A0EFLAGS: 00010282
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.020397] RAX: ffffffffa00763=
a0 RBX:
>> 0000000000005331 RCX: 0000000000000000
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.022447] RDX: 00000000000053=
31 RSI:
>> 000000000000101d RDI: ffff880423649380
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.024502] RBP: ffff8803fbc3de=
68 R08:
>> 0000000000005331 R09: 000000000000101d
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.026563] R10: 00007fff9286b9=
90 R11:
>> 0000000000000246 R12: 00000000ffffffe7
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.028628] R13: 00000000000000=
00 R14:
>> ffff8804236496c0 R15: ffff880420abd800
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.030698] FS:
>> 00007f62be453760(0000) GS:ffff88043f500000(0000)
>> knlGS:0000000000000000
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.032772] CS: =C2=A00010 DS: =
0000 ES:
>> 0000 CR0: 0000000080050033
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.034832] CR2: 00000000000000=
00 CR3:
>> 00000003fa2da000 CR4: 00000000000406e0
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.036908] DR0: 00000000000000=
00 DR1:
>> 0000000000000000 DR2: 0000000000000000
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.038972] DR3: 00000000000000=
00 DR6:
>> 00000000ffff0ff0 DR7: 0000000000000400
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.041019] Process blkid (pid:=
 4152,
>> threadinfo ffff8803fbc3c000, task ffff8803faa18000)
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.043083] Stack:
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.045138] =C2=A0ffffffff8141f=
a0f
>> ffff8803fbc3dec8 ffffffff812f5110 0000000000000000
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.047243] =C2=A0ffff880423649=
6c0
>> 0000000000000000 000000004f1d4903 00000000329f0436
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.049312] =C2=A00000000000000=
003
>> ffff8804217ad3c0 ffff880404ae0a50 0000000000000000
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.051352] Call Trace:
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.053334] =C2=A0[<ffffffff814=
1fa0f>] ?
>> ioctl_dev+0x2f/0x40
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.055284] =C2=A0[<ffffffff812=
f5110>]
>> blkdev_ioctl+0x2e0/0x740
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.057191] =C2=A0[<ffffffff811=
acf10>]
>> block_ioctl+0x40/0x50
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.059056] =C2=A0[<ffffffff811=
8843a>]
>> do_vfs_ioctl+0x8a/0x340
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.060888] =C2=A0[<ffffffff811=
7b2ea>] ?
>> sys_newfstat+0x2a/0x40
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.062687] =C2=A0[<ffffffff811=
88781>]
>> sys_ioctl+0x91/0xa0
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.064478] =C2=A0[<ffffffff816=
78ec2>]
>> system_call_fastpath+0x16/0x1b
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.066259] Code: =C2=A0Bad RIP=
 value.
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.068035] RIP =C2=A0[< =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0(null)>]
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 (null)
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.069812] =C2=A0RSP <ffff8803=
fbc3de60>
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.071573] CR2: 00000000000000=
00
>> Jan 23 11:49:29 dev1 kernel: [ =C2=A0281.073342] ---[ end trace 644c=
98d7f838705d ]---
>>
>>
>> On 21 January 2012 08:15, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> w=
rote:
>>> just tracked down a bug I was seeing when I was testing bcache on a=
rm.
>>>
>>> Turns out whoever wrote bio_get_nr_vecs() never heard of integer ov=
erflow.
>>>
>>> But I bet it's the same bug you were seeing, and there's a trivial
>>> workaround in bcache.
>>>
>>> Patch will be up momentarily.
>>>
>>> On Fri, Jan 20, 2012 at 6:43 PM, Kent Overstreet
>>> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> Have you tried the bcache (3.1 based) branch with the same setup? =
Did
>>>> it occur there?
>>>>
>>>> On Fri, Jan 20, 2012 at 3:27 AM, Damien Churchill <damoxc-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>>>> Hi there,
>>>>>
>>>>> I'm receiving the following after attempting to register a cache
>>>>> device, I've built the kernel using the Ubuntu Precise kernel wit=
h a
>>>>> patch from bcache-3.2-dev applied to the tree.
>>>>>
>>>>> The cache device was created by running:
>>>>> $ make-bcache -C -w 2k -b 1M /dev/sysvg/bcache-test
>>>>>
>>>>> The cache device is a logical volume, I'm unsure if that will hav=
e an impact?
>>>>>
>>>>> Regards,
>>>>> Damien
>>>>>
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.025724] bio: create slab=
 <bio-1> at 1
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.025902] bcache: invalida=
ting existing data
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026324] ------------[ cu=
t here ]------------
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026341] kernel BUG at
>>>>> /home/dchurchill/Packages/oneiric/linux/linux-3.2.0~bcache/includ=
e/linux/scatterlist.h:63!
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026367] invalid opcode: =
0000 [#1] SMP
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026380] CPU 0
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026385] Modules linked i=
n: rfcomm
>>>>> bnep bluetooth ip6table_filter ip6_tables ebtable_nat ebtables
>>>>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv=
4
>>>>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tc=
pudp
>>>>> iptable_filter ip_tables x_tables kvm_intel kvm parport_pc ppdev
>>>>> snd_hda_codec_hdmi snd_hda_codec_realtek binfmt_misc bridge usbhi=
d hid
>>>>> psmouse snd_hda_intel stp snd_hda_codec snd_hwdep snd_pcm snd_seq=
_midi
>>>>> eeepc_wmi asus_wmi sparse_keymap radeon ttm drm_kms_helper drm wm=
i
>>>>> mac_hid serio_raw video snd_rawmidi snd_seq_midi_event mei(C) snd=
_seq
>>>>> snd_timer snd_seq_device snd i2c_algo_bit soundcore dm_multipath
>>>>> snd_page_alloc rbd libceph lp parport firewire_ohci firewire_core
>>>>> crc_itu_t e1000e pata_marvell r8169 btrfs zlib_deflate libcrc32c
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026612]
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026617] Pid: 2420, comm:=
 bash
>>>>> Tainted: G =C2=A0 =C2=A0 =C2=A0 =C2=A0 C =C2=A0 3.2.0-9-generic #=
17~oneiric1 System
>>>>> manufacturer System Product Name/P8H67-M EVO
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.026649] RIP:
>>>>> 0010:[<ffffffff812f3588>] =C2=A0[<ffffffff812f3588>]
>>>>> blk_rq_map_sg+0x178/0x350
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.027607] RSP: 0018:ffff88=
0420fbf7c8
>>>>> =C2=A0EFLAGS: 00010002
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.028564] RAX: 00000000000=
00000 RBX:
>>>>> ffff8803fa608a20 RCX: 2700013524000135
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.029529] RDX: 00000000000=
00011 RSI:
>>>>> 0000000027000135 RDI: ffff8803fa608a00
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.030492] RBP: ffff880420f=
bf828 R08:
>>>>> 0000000000001000 R09: ffff880421862f00
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.031455] R10: 00000000000=
00001 R11:
>>>>> 0000000000000001 R12: ffff8803fa60a510
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.032417] R13: 00000000270=
00135 R14:
>>>>> ffff8803fa60a520 R15: 00000000000000d3
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.033385] FS:
>>>>> 00007f5259391720(0000) GS:ffff88043f400000(0000)
>>>>> knlGS:0000000000000000
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.034361] CS: =C2=A00010 D=
S: 0000 ES:
>>>>> 0000 CR0: 000000008005003b
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.035336] CR2: 00007f6d332=
e8000 CR3:
>>>>> 0000000401c16000 CR4: 00000000000406f0
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.036310] DR0: 00000000000=
00000 DR1:
>>>>> 0000000000000000 DR2: 0000000000000000
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.037287] DR3: 00000000000=
00000 DR6:
>>>>> 00000000ffff0ff0 DR7: 0000000000000400
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.038266] Process bash (pi=
d: 2420,
>>>>> threadinfo ffff880420fbe000, task ffff880403b3dc40)
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.039252] Stack:
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.040220] =C2=A00000000000=
000011
>>>>> ffff880400fcd2b0 ffff8803fa608800 0100000000000001
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.041196] =C2=A0ffff880421=
3a3368
>>>>> ffff880421862f00 ffff880420fbf828 ffff8804209cb858
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.042171] =C2=A0ffff880400=
fcd2b0
>>>>> 0000000000000001 0000000000000020 ffff880424e96800
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.043130] Call Trace:
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.044070] =C2=A0[<ffffffff=
81442521>]
>>>>> scsi_init_sgtable+0x41/0x70
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.045036] =C2=A0[<ffffffff=
8144258d>]
>>>>> scsi_init_io+0x3d/0x150
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.045983] =C2=A0[<ffffffff=
8144279a>]
>>>>> scsi_setup_fs_cmnd.part.34+0x5a/0x90
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.046917] =C2=A0[<ffffffff=
814427ff>]
>>>>> scsi_setup_fs_cmnd+0x2f/0x40
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.047837] =C2=A0[<ffffffff=
8145fb3f>]
>>>>> sd_prep_fn+0xaf/0xaf0
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.048747] =C2=A0[<ffffffff=
813017f4>] ?
>>>>> cfq_dispatch_request+0x64/0xa0
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.049654] =C2=A0[<ffffffff=
812eecda>]
>>>>> blk_peek_request+0xba/0x240
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.050558] =C2=A0[<ffffffff=
81442cf8>]
>>>>> scsi_request_fn+0x58/0x4c0
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.051461] =C2=A0[<ffffffff=
812e7c73>] ?
>>>>> __elv_add_request+0x1b3/0x290
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.052361] =C2=A0[<ffffffff=
812ef590>]
>>>>> blk_queue_bio+0x290/0x380
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.053262] =C2=A0[<ffffffff=
812ec114>]
>>>>> generic_make_request.part.50+0x74/0xb0
>>>>> Jan 20 11:24:36 dev1 kernel: [ =C2=A0119.054170] =C2=A0[<ffffffff=
812ec528>]
>>>>> generic_make_request+0x68/0x70
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-b=
cache" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-inf=
o.html
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-bc=
ache" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
