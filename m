From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel BUG registering cache device
Date: Sat, 21 Jan 2012 00:15:11 -0800
Message-ID: <CAH+dOxLVxag=Yx5TtcfP+dCh7sp8bu1OZy8gTtezn7b3j95J8A@mail.gmail.com>
References: <CAFtEh-cC=eSSTQfxyN64CQtudwmjZmTh6UZae8tDXLYkR7vbvw@mail.gmail.com>
	<CAC7rs0v6VKfjTmUmkMvqPWwAeK6aS_iC8Diw8Lu9gxLHc4Pp=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0v6VKfjTmUmkMvqPWwAeK6aS_iC8Diw8Lu9gxLHc4Pp=Q@mail.gmail.com>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

just tracked down a bug I was seeing when I was testing bcache on arm.

Turns out whoever wrote bio_get_nr_vecs() never heard of integer overfl=
ow.

But I bet it's the same bug you were seeing, and there's a trivial
workaround in bcache.

Patch will be up momentarily.

On Fri, Jan 20, 2012 at 6:43 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Have you tried the bcache (3.1 based) branch with the same setup? Did
> it occur there?
>
> On Fri, Jan 20, 2012 at 3:27 AM, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>> Hi there,
>>
>> I'm receiving the following after attempting to register a cache
>> device, I've built the kernel using the Ubuntu Precise kernel with a
>> patch from bcache-3.2-dev applied to the tree.
>>
>> The cache device was created by running:
>> $ make-bcache -C -w 2k -b 1M /dev/sysvg/bcache-test
>>
>> The cache device is a logical volume, I'm unsure if that will have a=
n impact?
>>
>> Regards,
>> Damien
>>
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.025724] bio: create slab <bio-=
1> at 1
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.025902] bcache: invalidating e=
xisting data
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026324] ------------[ cut here=
 ]------------
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026341] kernel BUG at
>> /home/dchurchill/Packages/oneiric/linux/linux-3.2.0~bcache/include/l=
inux/scatterlist.h:63!
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026367] invalid opcode: 0000 [=
#1] SMP
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026380] CPU 0
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026385] Modules linked in: rfc=
omm
>> bnep bluetooth ip6table_filter ip6_tables ebtable_nat ebtables
>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpud=
p
>> iptable_filter ip_tables x_tables kvm_intel kvm parport_pc ppdev
>> snd_hda_codec_hdmi snd_hda_codec_realtek binfmt_misc bridge usbhid h=
id
>> psmouse snd_hda_intel stp snd_hda_codec snd_hwdep snd_pcm snd_seq_mi=
di
>> eeepc_wmi asus_wmi sparse_keymap radeon ttm drm_kms_helper drm wmi
>> mac_hid serio_raw video snd_rawmidi snd_seq_midi_event mei(C) snd_se=
q
>> snd_timer snd_seq_device snd i2c_algo_bit soundcore dm_multipath
>> snd_page_alloc rbd libceph lp parport firewire_ohci firewire_core
>> crc_itu_t e1000e pata_marvell r8169 btrfs zlib_deflate libcrc32c
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026612]
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026617] Pid: 2420, comm: bash
>> Tainted: G =A0 =A0 =A0 =A0 C =A0 3.2.0-9-generic #17~oneiric1 System
>> manufacturer System Product Name/P8H67-M EVO
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026649] RIP:
>> 0010:[<ffffffff812f3588>] =A0[<ffffffff812f3588>]
>> blk_rq_map_sg+0x178/0x350
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.027607] RSP: 0018:ffff880420fb=
f7c8
>> =A0EFLAGS: 00010002
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.028564] RAX: 0000000000000000 =
RBX:
>> ffff8803fa608a20 RCX: 2700013524000135
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.029529] RDX: 0000000000000011 =
RSI:
>> 0000000027000135 RDI: ffff8803fa608a00
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.030492] RBP: ffff880420fbf828 =
R08:
>> 0000000000001000 R09: ffff880421862f00
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.031455] R10: 0000000000000001 =
R11:
>> 0000000000000001 R12: ffff8803fa60a510
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.032417] R13: 0000000027000135 =
R14:
>> ffff8803fa60a520 R15: 00000000000000d3
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.033385] FS:
>> 00007f5259391720(0000) GS:ffff88043f400000(0000)
>> knlGS:0000000000000000
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.034361] CS: =A00010 DS: 0000 E=
S:
>> 0000 CR0: 000000008005003b
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.035336] CR2: 00007f6d332e8000 =
CR3:
>> 0000000401c16000 CR4: 00000000000406f0
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.036310] DR0: 0000000000000000 =
DR1:
>> 0000000000000000 DR2: 0000000000000000
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.037287] DR3: 0000000000000000 =
DR6:
>> 00000000ffff0ff0 DR7: 0000000000000400
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.038266] Process bash (pid: 242=
0,
>> threadinfo ffff880420fbe000, task ffff880403b3dc40)
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.039252] Stack:
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.040220] =A00000000000000011
>> ffff880400fcd2b0 ffff8803fa608800 0100000000000001
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.041196] =A0ffff8804213a3368
>> ffff880421862f00 ffff880420fbf828 ffff8804209cb858
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.042171] =A0ffff880400fcd2b0
>> 0000000000000001 0000000000000020 ffff880424e96800
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.043130] Call Trace:
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.044070] =A0[<ffffffff81442521>=
]
>> scsi_init_sgtable+0x41/0x70
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.045036] =A0[<ffffffff8144258d>=
]
>> scsi_init_io+0x3d/0x150
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.045983] =A0[<ffffffff8144279a>=
]
>> scsi_setup_fs_cmnd.part.34+0x5a/0x90
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.046917] =A0[<ffffffff814427ff>=
]
>> scsi_setup_fs_cmnd+0x2f/0x40
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.047837] =A0[<ffffffff8145fb3f>=
]
>> sd_prep_fn+0xaf/0xaf0
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.048747] =A0[<ffffffff813017f4>=
] ?
>> cfq_dispatch_request+0x64/0xa0
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.049654] =A0[<ffffffff812eecda>=
]
>> blk_peek_request+0xba/0x240
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.050558] =A0[<ffffffff81442cf8>=
]
>> scsi_request_fn+0x58/0x4c0
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.051461] =A0[<ffffffff812e7c73>=
] ?
>> __elv_add_request+0x1b3/0x290
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.052361] =A0[<ffffffff812ef590>=
]
>> blk_queue_bio+0x290/0x380
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.053262] =A0[<ffffffff812ec114>=
]
>> generic_make_request.part.50+0x74/0xb0
>> Jan 20 11:24:36 dev1 kernel: [ =A0119.054170] =A0[<ffffffff812ec528>=
]
>> generic_make_request+0x68/0x70
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
