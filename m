From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel BUG registering cache device
Date: Mon, 23 Jan 2012 19:24:40 -0800
Message-ID: <CAC7rs0v8o6PEtMLraSdfWaSWa-cuukMqEK49cZTb4NLHr+qp+g@mail.gmail.com>
References: <CAFtEh-cC=eSSTQfxyN64CQtudwmjZmTh6UZae8tDXLYkR7vbvw@mail.gmail.com>
	<CAC7rs0v6VKfjTmUmkMvqPWwAeK6aS_iC8Diw8Lu9gxLHc4Pp=Q@mail.gmail.com>
	<CAH+dOxLVxag=Yx5TtcfP+dCh7sp8bu1OZy8gTtezn7b3j95J8A@mail.gmail.com>
	<CAFtEh-fr1Z0Va-cgFrfuvf3fCo5GJET8vfTYy_JcK2YwayEhig@mail.gmail.com>
	<CAH+dOx+Vk0aL0ETxzxri7PCHqhABYePXWp1yvUsrJxjQ7qXKdQ@mail.gmail.com>
	<CAFtEh-efCC3LM1Bm9WHfLyrnucBTTGHTiu7FR=1vtDTMyudmSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFtEh-efCC3LM1Bm9WHfLyrnucBTTGHTiu7FR=1vtDTMyudmSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

New code up, should be fixed.

On Mon, Jan 23, 2012 at 4:33 AM, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> Cool thanks, let me know when there's something to test and I'll let
> you know how it goes.
>
> On 23 January 2012 12:09, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> So, we called a null function pointer. Looks like I broke the ioctl
>> handler somehow, I'll check that out tomorrow.
>>
>> On Mon, Jan 23, 2012 at 3:52 AM, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>>> Excellent thanks a lot Kent, that's fixed the problem with the lv c=
ache device.
>>>
>>> I am experiencing a problem attempting to use a rbd as a backing
>>> device also. This was working in 3.1 partially so I'm not sure what=
's
>>> changed there. The following is output to console & syslog whenever
>>> the bcache0 device is accessed by something. Well by blkid or
>>> mkfs.ext4.
>>>
>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.993416] BUG: unable to handle
>>> kernel NULL pointer dereference at =A0 =A0 =A0 =A0 =A0 (null)
>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.995317] IP: [< =A0 =A0 =A0 =A0=
 =A0(null)>]
>>> =A0 =A0 =A0 =A0(null)
>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.997180] PGD 401b0d067 PUD 3fb=
fa1067 PMD 0
>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.999034] Oops: 0010 [#2] SMP
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.000831] CPU 2
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.000843] Modules linked in: bn=
ep
>>> rfcomm bluetooth ip6table_filter ip6_tables ebtable_nat ebtables
>>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
>>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpu=
dp
>>> iptable_filter ip_tables x_tables kvm_intel kvm parport_pc ppdev
>>> binfmt_misc usbhid hid snd_hda_codec_hdmi snd_hda_codec_realtek bri=
dge
>>> stp snd_seq_midi psmouse eeepc_wmi radeon ttm drm_kms_helper asus_w=
mi
>>> snd_rawmidi drm sparse_keymap snd_seq_midi_event snd_hda_intel
>>> snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device sn=
d
>>> mac_hid video serio_raw soundcore dm_multipath wmi i2c_algo_bit
>>> snd_page_alloc mei(C) rbd libceph lp parport firewire_ohci
>>> firewire_core btrfs pata_marvell crc_itu_t e1000e r8169 zlib_deflat=
e
>>> libcrc32c
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.012308]
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.014277] Pid: 4152, comm: blki=
d
>>> Tainted: G =A0 =A0 =A0D =A0C =A0 3.2.0-9-generic #17~oneiric1 Syste=
m
>>> manufacturer System Product Name/P8H67-M EVO
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.016330] RIP:
>>> 0010:[<0000000000000000>] =A0[< =A0 =A0 =A0 =A0 =A0(null)>] =A0 =A0=
 =A0 =A0 =A0 (null)
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.018364] RSP: 0018:ffff8803fbc=
3de60
>>> =A0EFLAGS: 00010282
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.020397] RAX: ffffffffa00763a0=
 RBX:
>>> 0000000000005331 RCX: 0000000000000000
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.022447] RDX: 0000000000005331=
 RSI:
>>> 000000000000101d RDI: ffff880423649380
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.024502] RBP: ffff8803fbc3de68=
 R08:
>>> 0000000000005331 R09: 000000000000101d
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.026563] R10: 00007fff9286b990=
 R11:
>>> 0000000000000246 R12: 00000000ffffffe7
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.028628] R13: 0000000000000000=
 R14:
>>> ffff8804236496c0 R15: ffff880420abd800
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.030698] FS:
>>> 00007f62be453760(0000) GS:ffff88043f500000(0000)
>>> knlGS:0000000000000000
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.032772] CS: =A00010 DS: 0000 =
ES:
>>> 0000 CR0: 0000000080050033
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.034832] CR2: 0000000000000000=
 CR3:
>>> 00000003fa2da000 CR4: 00000000000406e0
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.036908] DR0: 0000000000000000=
 DR1:
>>> 0000000000000000 DR2: 0000000000000000
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.038972] DR3: 0000000000000000=
 DR6:
>>> 00000000ffff0ff0 DR7: 0000000000000400
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.041019] Process blkid (pid: 4=
152,
>>> threadinfo ffff8803fbc3c000, task ffff8803faa18000)
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.043083] Stack:
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.045138] =A0ffffffff8141fa0f
>>> ffff8803fbc3dec8 ffffffff812f5110 0000000000000000
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.047243] =A0ffff8804236496c0
>>> 0000000000000000 000000004f1d4903 00000000329f0436
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.049312] =A00000000000000003
>>> ffff8804217ad3c0 ffff880404ae0a50 0000000000000000
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.051352] Call Trace:
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.053334] =A0[<ffffffff8141fa0f=
>] ?
>>> ioctl_dev+0x2f/0x40
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.055284] =A0[<ffffffff812f5110=
>]
>>> blkdev_ioctl+0x2e0/0x740
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.057191] =A0[<ffffffff811acf10=
>]
>>> block_ioctl+0x40/0x50
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.059056] =A0[<ffffffff8118843a=
>]
>>> do_vfs_ioctl+0x8a/0x340
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.060888] =A0[<ffffffff8117b2ea=
>] ?
>>> sys_newfstat+0x2a/0x40
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.062687] =A0[<ffffffff81188781=
>]
>>> sys_ioctl+0x91/0xa0
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.064478] =A0[<ffffffff81678ec2=
>]
>>> system_call_fastpath+0x16/0x1b
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.066259] Code: =A0Bad RIP valu=
e.
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.068035] RIP =A0[< =A0 =A0 =A0=
 =A0 =A0(null)>]
>>> =A0 =A0 =A0 =A0 (null)
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.069812] =A0RSP <ffff8803fbc3d=
e60>
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.071573] CR2: 0000000000000000
>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.073342] ---[ end trace 644c98=
d7f838705d ]---
>>>
>>>
>>> On 21 January 2012 08:15, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>>>> just tracked down a bug I was seeing when I was testing bcache on =
arm.
>>>>
>>>> Turns out whoever wrote bio_get_nr_vecs() never heard of integer o=
verflow.
>>>>
>>>> But I bet it's the same bug you were seeing, and there's a trivial
>>>> workaround in bcache.
>>>>
>>>> Patch will be up momentarily.
>>>>
>>>> On Fri, Jan 20, 2012 at 6:43 PM, Kent Overstreet
>>>> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> Have you tried the bcache (3.1 based) branch with the same setup?=
 Did
>>>>> it occur there?
>>>>>
>>>>> On Fri, Jan 20, 2012 at 3:27 AM, Damien Churchill <damoxc@gmail.c=
om> wrote:
>>>>>> Hi there,
>>>>>>
>>>>>> I'm receiving the following after attempting to register a cache
>>>>>> device, I've built the kernel using the Ubuntu Precise kernel wi=
th a
>>>>>> patch from bcache-3.2-dev applied to the tree.
>>>>>>
>>>>>> The cache device was created by running:
>>>>>> $ make-bcache -C -w 2k -b 1M /dev/sysvg/bcache-test
>>>>>>
>>>>>> The cache device is a logical volume, I'm unsure if that will ha=
ve an impact?
>>>>>>
>>>>>> Regards,
>>>>>> Damien
>>>>>>
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.025724] bio: create slab <=
bio-1> at 1
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.025902] bcache: invalidati=
ng existing data
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026324] ------------[ cut =
here ]------------
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026341] kernel BUG at
>>>>>> /home/dchurchill/Packages/oneiric/linux/linux-3.2.0~bcache/inclu=
de/linux/scatterlist.h:63!
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026367] invalid opcode: 00=
00 [#1] SMP
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026380] CPU 0
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026385] Modules linked in:=
 rfcomm
>>>>>> bnep bluetooth ip6table_filter ip6_tables ebtable_nat ebtables
>>>>>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ip=
v4
>>>>>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_t=
cpudp
>>>>>> iptable_filter ip_tables x_tables kvm_intel kvm parport_pc ppdev
>>>>>> snd_hda_codec_hdmi snd_hda_codec_realtek binfmt_misc bridge usbh=
id hid
>>>>>> psmouse snd_hda_intel stp snd_hda_codec snd_hwdep snd_pcm snd_se=
q_midi
>>>>>> eeepc_wmi asus_wmi sparse_keymap radeon ttm drm_kms_helper drm w=
mi
>>>>>> mac_hid serio_raw video snd_rawmidi snd_seq_midi_event mei(C) sn=
d_seq
>>>>>> snd_timer snd_seq_device snd i2c_algo_bit soundcore dm_multipath
>>>>>> snd_page_alloc rbd libceph lp parport firewire_ohci firewire_cor=
e
>>>>>> crc_itu_t e1000e pata_marvell r8169 btrfs zlib_deflate libcrc32c
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026612]
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026617] Pid: 2420, comm: b=
ash
>>>>>> Tainted: G =A0 =A0 =A0 =A0 C =A0 3.2.0-9-generic #17~oneiric1 Sy=
stem
>>>>>> manufacturer System Product Name/P8H67-M EVO
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026649] RIP:
>>>>>> 0010:[<ffffffff812f3588>] =A0[<ffffffff812f3588>]
>>>>>> blk_rq_map_sg+0x178/0x350
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.027607] RSP: 0018:ffff8804=
20fbf7c8
>>>>>> =A0EFLAGS: 00010002
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.028564] RAX: 0000000000000=
000 RBX:
>>>>>> ffff8803fa608a20 RCX: 2700013524000135
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.029529] RDX: 0000000000000=
011 RSI:
>>>>>> 0000000027000135 RDI: ffff8803fa608a00
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.030492] RBP: ffff880420fbf=
828 R08:
>>>>>> 0000000000001000 R09: ffff880421862f00
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.031455] R10: 0000000000000=
001 R11:
>>>>>> 0000000000000001 R12: ffff8803fa60a510
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.032417] R13: 0000000027000=
135 R14:
>>>>>> ffff8803fa60a520 R15: 00000000000000d3
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.033385] FS:
>>>>>> 00007f5259391720(0000) GS:ffff88043f400000(0000)
>>>>>> knlGS:0000000000000000
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.034361] CS: =A00010 DS: 00=
00 ES:
>>>>>> 0000 CR0: 000000008005003b
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.035336] CR2: 00007f6d332e8=
000 CR3:
>>>>>> 0000000401c16000 CR4: 00000000000406f0
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.036310] DR0: 0000000000000=
000 DR1:
>>>>>> 0000000000000000 DR2: 0000000000000000
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.037287] DR3: 0000000000000=
000 DR6:
>>>>>> 00000000ffff0ff0 DR7: 0000000000000400
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.038266] Process bash (pid:=
 2420,
>>>>>> threadinfo ffff880420fbe000, task ffff880403b3dc40)
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.039252] Stack:
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.040220] =A0000000000000001=
1
>>>>>> ffff880400fcd2b0 ffff8803fa608800 0100000000000001
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.041196] =A0ffff8804213a336=
8
>>>>>> ffff880421862f00 ffff880420fbf828 ffff8804209cb858
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.042171] =A0ffff880400fcd2b=
0
>>>>>> 0000000000000001 0000000000000020 ffff880424e96800
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.043130] Call Trace:
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.044070] =A0[<ffffffff81442=
521>]
>>>>>> scsi_init_sgtable+0x41/0x70
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.045036] =A0[<ffffffff81442=
58d>]
>>>>>> scsi_init_io+0x3d/0x150
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.045983] =A0[<ffffffff81442=
79a>]
>>>>>> scsi_setup_fs_cmnd.part.34+0x5a/0x90
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.046917] =A0[<ffffffff81442=
7ff>]
>>>>>> scsi_setup_fs_cmnd+0x2f/0x40
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.047837] =A0[<ffffffff8145f=
b3f>]
>>>>>> sd_prep_fn+0xaf/0xaf0
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.048747] =A0[<ffffffff81301=
7f4>] ?
>>>>>> cfq_dispatch_request+0x64/0xa0
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.049654] =A0[<ffffffff812ee=
cda>]
>>>>>> blk_peek_request+0xba/0x240
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.050558] =A0[<ffffffff81442=
cf8>]
>>>>>> scsi_request_fn+0x58/0x4c0
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.051461] =A0[<ffffffff812e7=
c73>] ?
>>>>>> __elv_add_request+0x1b3/0x290
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.052361] =A0[<ffffffff812ef=
590>]
>>>>>> blk_queue_bio+0x290/0x380
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.053262] =A0[<ffffffff812ec=
114>]
>>>>>> generic_make_request.part.50+0x74/0xb0
>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.054170] =A0[<ffffffff812ec=
528>]
>>>>>> generic_make_request+0x68/0x70
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
bcache" in
>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-b=
cache" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
