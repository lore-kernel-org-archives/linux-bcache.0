From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel BUG registering cache device
Date: Tue, 24 Jan 2012 21:37:23 -0800
Message-ID: <CAH+dOx+EsSKnhjLnu48RR1bMDhu2aOKz9HxkNVBuH0H3D1Dg6g@mail.gmail.com>
References: <CAFtEh-cC=eSSTQfxyN64CQtudwmjZmTh6UZae8tDXLYkR7vbvw@mail.gmail.com>
	<CAC7rs0v6VKfjTmUmkMvqPWwAeK6aS_iC8Diw8Lu9gxLHc4Pp=Q@mail.gmail.com>
	<CAH+dOxLVxag=Yx5TtcfP+dCh7sp8bu1OZy8gTtezn7b3j95J8A@mail.gmail.com>
	<CAFtEh-fr1Z0Va-cgFrfuvf3fCo5GJET8vfTYy_JcK2YwayEhig@mail.gmail.com>
	<CAH+dOx+Vk0aL0ETxzxri7PCHqhABYePXWp1yvUsrJxjQ7qXKdQ@mail.gmail.com>
	<CAFtEh-efCC3LM1Bm9WHfLyrnucBTTGHTiu7FR=1vtDTMyudmSw@mail.gmail.com>
	<CAC7rs0v8o6PEtMLraSdfWaSWa-cuukMqEK49cZTb4NLHr+qp+g@mail.gmail.com>
	<CAFtEh-fPW6j+ztQ5TJhS=H39vvTYCXY5hw4tmGeR8TU=CmjZ0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFtEh-fPW6j+ztQ5TJhS=H39vvTYCXY5hw4tmGeR8TU=CmjZ0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Not sure what that one is. Found another integer overflow bug, but I
don't think that could be causing this problem.

I just uploaded a patch which fixes that overflow and adds a BUG_ON()
which should help narrow it down. Mind giving that one a shot?

On Tue, Jan 24, 2012 at 3:13 AM, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> The fix worked perfectly, thanks. I am now able to:
>
> 1) create cache device on LVM & register it
> 2) create backing device on rbd & register it
> 3) use backing device without attaching the cache perfectly fine
> (format as ext4 + mount it and write some files)
> 4) attach the cache device to the backing device
>
> Unfortunately when trying to mount the backing device after attaching
> the cache I end up with a kernel BUG, the syslog output is below.
>
> [ =A0232.762594] bio: create slab <bio-1> at 1
> [ =A0232.770175] bcache: btree_journal_read() done
> [ =A0232.778854] bcache: btree_check() done
> [ =A0232.778867] bcache: journal replay done, 1 keys in 1 entries, se=
q 3-3
> [ =A0232.780579] bcache: registered cache device dm-1
> [ =A0242.271440] libceph: client0 fsid 58c297c0-018a-4c13-9a21-0140b9=
fb2f25
> [ =A0242.271973] libceph: mon1 10.10.20.1:6789 session established
> [ =A0242.277119] =A0rbd0: unknown partition table
> [ =A0242.277236] rbd: rbd0: added with size 0x3e80000000
> [ =A0251.360401] bcache: Caching rbd0, looked up UUID
> 12378985-91b3-4165-b3a6-6657831f050b
> [ =A0280.083396] EXT4-fs (bcache0): recovery complete
> [ =A0280.083403] EXT4-fs (bcache0): mounted filesystem with ordered d=
ata
> mode. Opts: (null)
> [ =A0283.160575] ------------[ cut here ]------------
> [ =A0283.160609] kernel BUG at
> /home/dchurchill/Packages/oneiric/linux/linux-3.2.0~bcache/include/li=
nux/scatterlist.h:63!
> [ =A0283.162338] invalid opcode: 0000 [#1] SMP
> [ =A0283.164064] CPU 0
> [ =A0283.164076] Modules linked in: bnep rfcomm bluetooth
> ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE
> iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
> iptable_filter ip_tables x_tables parport_pc ppdev kvm_intel kvm
> snd_hda_codec_hdmi snd_hda_codec_realtek eeepc_wmi asus_wmi
> sparse_keymap dm_multipath binfmt_misc bridge stp psmouse
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm serio_raw snd_seq_midi
> snd_rawmidi snd_seq_midi_event snd_seq radeon ttm snd_timer
> snd_seq_device mei(C) drm_kms_helper drm i2c_algo_bit video snd
> mac_hid soundcore snd_page_alloc wmi rbd libceph lp parport usbhid hi=
d
> e1000e btrfs zlib_deflate firewire_ohci pata_marvell r8169
> firewire_core crc_itu_t libcrc32c
> [ =A0283.175414]
> [ =A0283.177376] Pid: 4222, comm: ext4lazyinit Tainted: G =A0 =A0 =A0=
 =A0 C
> 3.2.0-9-generic #17~oneiric2 System manufacturer System Product
> Name/P8H67-M EVO
> [ =A0283.179432] RIP: 0010:[<ffffffff812f3588>] =A0[<ffffffff812f3588=
>]
> blk_rq_map_sg+0x178/0x350
> [ =A0283.181502] RSP: 0018:ffff8803f01f99d0 =A0EFLAGS: 00010006
> [ =A0283.183562] RAX: 0000000000000000 RBX: ffff8803f5019020 RCX: 4ac=
fa4aaf8e1e9bf
> [ =A0283.185635] RDX: 0000000000000001 RSI: 00000000d6679dfb RDI: fff=
f8803f5019000
> [ =A0283.187711] RBP: ffff8803f01f9a30 R08: 0000000000000000 R09: fff=
f8803eeb49e40
> [ =A0283.189786] R10: 0000000000000001 R11: 0000000000000001 R12: fff=
f8803f561c800
> [ =A0283.191858] R13: 000000008a430cfb R14: ffff8803f561c810 R15: 000=
0000000000082
> [ =A0283.193941] FS: =A00000000000000000(0000) GS:ffff88043f400000(00=
00)
> knlGS:0000000000000000
> [ =A0283.196022] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ =A0283.198100] CR2: 0000000001b1d278 CR3: 0000000001c05000 CR4: 000=
00000000406f0
> [ =A0283.200191] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> [ =A0283.202284] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
> [ =A0283.204382] Process ext4lazyinit (pid: 4222, threadinfo
> ffff8803f01f8000, task ffff8803f57a2e20)
> [ =A0283.206504] Stack:
> [ =A0283.208584] =A0ffff880400000001 ffff8803f57bb870 ffff8803f501900=
0
> 0100000000000001
> [ =A0283.210686] =A0ffff8804213a3368 ffff8803eeb49e40 ffff8803f01f9a3=
0
> ffff8803f54f9158
> [ =A0283.212778] =A0ffff8803f57bb870 0000000000000001 000000000000002=
0
> ffff880424e96800
> [ =A0283.214833] Call Trace:
> [ =A0283.216848] =A0[<ffffffff81442011>] scsi_init_sgtable+0x41/0x70
> [ =A0283.218894] =A0[<ffffffff8144207d>] scsi_init_io+0x3d/0x150
> [ =A0283.220930] =A0[<ffffffff8144228a>] scsi_setup_fs_cmnd.part.34+0=
x5a/0x90
> [ =A0283.222942] =A0[<ffffffff814422ef>] scsi_setup_fs_cmnd+0x2f/0x40
> [ =A0283.224918] =A0[<ffffffff8145f62f>] sd_prep_fn+0xaf/0xaf0
> [ =A0283.226882] =A0[<ffffffff813017f4>] ? cfq_dispatch_request+0x64/=
0xa0
> [ =A0283.228835] =A0[<ffffffff812eecda>] blk_peek_request+0xba/0x240
> [ =A0283.230784] =A0[<ffffffff814427e8>] scsi_request_fn+0x58/0x4c0
> [ =A0283.232727] =A0[<ffffffff812e7c73>] ? __elv_add_request+0x1b3/0x=
290
> [ =A0283.234668] =A0[<ffffffff812ef590>] blk_queue_bio+0x290/0x380
> [ =A0283.236611] =A0[<ffffffff812ec114>] generic_make_request.part.50=
+0x74/0xb0
> [ =A0283.238570] =A0[<ffffffff812ec528>] generic_make_request+0x68/0x=
70
> [ =A0283.240517] =A0[<ffffffff812ec5b5>] submit_bio+0x85/0x110
> [ =A0283.242434] =A0[<ffffffff811ac61a>] ? bio_alloc_bioset+0xba/0x10=
0
> [ =A0283.244332] =A0[<ffffffff812f4900>] blkdev_issue_zeroout+0x110/0=
x170
> [ =A0283.246223] =A0[<ffffffff8121163b>] ext4_init_inode_table+0x15b/=
0x370
> [ =A0283.248070] =A0[<ffffffff8166ef75>] ? schedule_timeout+0x175/0x3=
20
> [ =A0283.249887] =A0[<ffffffff81224c65>] ext4_run_li_request+0x85/0xe=
0
> [ =A0283.251686] =A0[<ffffffff81224d5c>] ext4_lazyinit_thread+0x9c/0x=
1c0
> [ =A0283.253478] =A0[<ffffffff81224cc0>] ? ext4_run_li_request+0xe0/0=
xe0
> [ =A0283.255273] =A0[<ffffffff8108832c>] kthread+0x8c/0xa0
> [ =A0283.257048] =A0[<ffffffff8167b034>] kernel_thread_helper+0x4/0x1=
0
> [ =A0283.258824] =A0[<ffffffff810882a0>] ? flush_kthread_worker+0xa0/=
0xa0
>
> On 24 January 2012 03:24, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>> New code up, should be fixed.
>>
>> On Mon, Jan 23, 2012 at 4:33 AM, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>>> Cool thanks, let me know when there's something to test and I'll le=
t
>>> you know how it goes.
>>>
>>> On 23 January 2012 12:09, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>>>> So, we called a null function pointer. Looks like I broke the ioct=
l
>>>> handler somehow, I'll check that out tomorrow.
>>>>
>>>> On Mon, Jan 23, 2012 at 3:52 AM, Damien Churchill <damoxc-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>>>> Excellent thanks a lot Kent, that's fixed the problem with the lv=
 cache device.
>>>>>
>>>>> I am experiencing a problem attempting to use a rbd as a backing
>>>>> device also. This was working in 3.1 partially so I'm not sure wh=
at's
>>>>> changed there. The following is output to console & syslog whenev=
er
>>>>> the bcache0 device is accessed by something. Well by blkid or
>>>>> mkfs.ext4.
>>>>>
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.993416] BUG: unable to hand=
le
>>>>> kernel NULL pointer dereference at =A0 =A0 =A0 =A0 =A0 (null)
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.995317] IP: [< =A0 =A0 =A0 =
=A0 =A0(null)>]
>>>>> =A0 =A0 =A0 =A0(null)
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.997180] PGD 401b0d067 PUD 3=
fbfa1067 PMD 0
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0280.999034] Oops: 0010 [#2] SMP
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.000831] CPU 2
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.000843] Modules linked in: =
bnep
>>>>> rfcomm bluetooth ip6table_filter ip6_tables ebtable_nat ebtables
>>>>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv=
4
>>>>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tc=
pudp
>>>>> iptable_filter ip_tables x_tables kvm_intel kvm parport_pc ppdev
>>>>> binfmt_misc usbhid hid snd_hda_codec_hdmi snd_hda_codec_realtek b=
ridge
>>>>> stp snd_seq_midi psmouse eeepc_wmi radeon ttm drm_kms_helper asus=
_wmi
>>>>> snd_rawmidi drm sparse_keymap snd_seq_midi_event snd_hda_intel
>>>>> snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device =
snd
>>>>> mac_hid video serio_raw soundcore dm_multipath wmi i2c_algo_bit
>>>>> snd_page_alloc mei(C) rbd libceph lp parport firewire_ohci
>>>>> firewire_core btrfs pata_marvell crc_itu_t e1000e r8169 zlib_defl=
ate
>>>>> libcrc32c
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.012308]
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.014277] Pid: 4152, comm: bl=
kid
>>>>> Tainted: G =A0 =A0 =A0D =A0C =A0 3.2.0-9-generic #17~oneiric1 Sys=
tem
>>>>> manufacturer System Product Name/P8H67-M EVO
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.016330] RIP:
>>>>> 0010:[<0000000000000000>] =A0[< =A0 =A0 =A0 =A0 =A0(null)>] =A0 =A0=
 =A0 =A0 =A0 (null)
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.018364] RSP: 0018:ffff8803f=
bc3de60
>>>>> =A0EFLAGS: 00010282
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.020397] RAX: ffffffffa00763=
a0 RBX:
>>>>> 0000000000005331 RCX: 0000000000000000
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.022447] RDX: 00000000000053=
31 RSI:
>>>>> 000000000000101d RDI: ffff880423649380
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.024502] RBP: ffff8803fbc3de=
68 R08:
>>>>> 0000000000005331 R09: 000000000000101d
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.026563] R10: 00007fff9286b9=
90 R11:
>>>>> 0000000000000246 R12: 00000000ffffffe7
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.028628] R13: 00000000000000=
00 R14:
>>>>> ffff8804236496c0 R15: ffff880420abd800
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.030698] FS:
>>>>> 00007f62be453760(0000) GS:ffff88043f500000(0000)
>>>>> knlGS:0000000000000000
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.032772] CS: =A00010 DS: 000=
0 ES:
>>>>> 0000 CR0: 0000000080050033
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.034832] CR2: 00000000000000=
00 CR3:
>>>>> 00000003fa2da000 CR4: 00000000000406e0
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.036908] DR0: 00000000000000=
00 DR1:
>>>>> 0000000000000000 DR2: 0000000000000000
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.038972] DR3: 00000000000000=
00 DR6:
>>>>> 00000000ffff0ff0 DR7: 0000000000000400
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.041019] Process blkid (pid:=
 4152,
>>>>> threadinfo ffff8803fbc3c000, task ffff8803faa18000)
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.043083] Stack:
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.045138] =A0ffffffff8141fa0f
>>>>> ffff8803fbc3dec8 ffffffff812f5110 0000000000000000
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.047243] =A0ffff8804236496c0
>>>>> 0000000000000000 000000004f1d4903 00000000329f0436
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.049312] =A00000000000000003
>>>>> ffff8804217ad3c0 ffff880404ae0a50 0000000000000000
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.051352] Call Trace:
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.053334] =A0[<ffffffff8141fa=
0f>] ?
>>>>> ioctl_dev+0x2f/0x40
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.055284] =A0[<ffffffff812f51=
10>]
>>>>> blkdev_ioctl+0x2e0/0x740
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.057191] =A0[<ffffffff811acf=
10>]
>>>>> block_ioctl+0x40/0x50
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.059056] =A0[<ffffffff811884=
3a>]
>>>>> do_vfs_ioctl+0x8a/0x340
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.060888] =A0[<ffffffff8117b2=
ea>] ?
>>>>> sys_newfstat+0x2a/0x40
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.062687] =A0[<ffffffff811887=
81>]
>>>>> sys_ioctl+0x91/0xa0
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.064478] =A0[<ffffffff81678e=
c2>]
>>>>> system_call_fastpath+0x16/0x1b
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.066259] Code: =A0Bad RIP va=
lue.
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.068035] RIP =A0[< =A0 =A0 =A0=
 =A0 =A0(null)>]
>>>>> =A0 =A0 =A0 =A0 (null)
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.069812] =A0RSP <ffff8803fbc=
3de60>
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.071573] CR2: 00000000000000=
00
>>>>> Jan 23 11:49:29 dev1 kernel: [ =A0281.073342] ---[ end trace 644c=
98d7f838705d ]---
>>>>>
>>>>>
>>>>> On 21 January 2012 08:15, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
>>>>>> just tracked down a bug I was seeing when I was testing bcache o=
n arm.
>>>>>>
>>>>>> Turns out whoever wrote bio_get_nr_vecs() never heard of integer=
 overflow.
>>>>>>
>>>>>> But I bet it's the same bug you were seeing, and there's a trivi=
al
>>>>>> workaround in bcache.
>>>>>>
>>>>>> Patch will be up momentarily.
>>>>>>
>>>>>> On Fri, Jan 20, 2012 at 6:43 PM, Kent Overstreet
>>>>>> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>>> Have you tried the bcache (3.1 based) branch with the same setu=
p? Did
>>>>>>> it occur there?
>>>>>>>
>>>>>>> On Fri, Jan 20, 2012 at 3:27 AM, Damien Churchill <damoxc@gmail=
=2Ecom> wrote:
>>>>>>>> Hi there,
>>>>>>>>
>>>>>>>> I'm receiving the following after attempting to register a cac=
he
>>>>>>>> device, I've built the kernel using the Ubuntu Precise kernel =
with a
>>>>>>>> patch from bcache-3.2-dev applied to the tree.
>>>>>>>>
>>>>>>>> The cache device was created by running:
>>>>>>>> $ make-bcache -C -w 2k -b 1M /dev/sysvg/bcache-test
>>>>>>>>
>>>>>>>> The cache device is a logical volume, I'm unsure if that will =
have an impact?
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>> Damien
>>>>>>>>
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.025724] bio: create slab=
 <bio-1> at 1
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.025902] bcache: invalida=
ting existing data
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026324] ------------[ cu=
t here ]------------
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026341] kernel BUG at
>>>>>>>> /home/dchurchill/Packages/oneiric/linux/linux-3.2.0~bcache/inc=
lude/linux/scatterlist.h:63!
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026367] invalid opcode: =
0000 [#1] SMP
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026380] CPU 0
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026385] Modules linked i=
n: rfcomm
>>>>>>>> bnep bluetooth ip6table_filter ip6_tables ebtable_nat ebtables
>>>>>>>> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_=
ipv4
>>>>>>>> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt=
_tcpudp
>>>>>>>> iptable_filter ip_tables x_tables kvm_intel kvm parport_pc ppd=
ev
>>>>>>>> snd_hda_codec_hdmi snd_hda_codec_realtek binfmt_misc bridge us=
bhid hid
>>>>>>>> psmouse snd_hda_intel stp snd_hda_codec snd_hwdep snd_pcm snd_=
seq_midi
>>>>>>>> eeepc_wmi asus_wmi sparse_keymap radeon ttm drm_kms_helper drm=
 wmi
>>>>>>>> mac_hid serio_raw video snd_rawmidi snd_seq_midi_event mei(C) =
snd_seq
>>>>>>>> snd_timer snd_seq_device snd i2c_algo_bit soundcore dm_multipa=
th
>>>>>>>> snd_page_alloc rbd libceph lp parport firewire_ohci firewire_c=
ore
>>>>>>>> crc_itu_t e1000e pata_marvell r8169 btrfs zlib_deflate libcrc3=
2c
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026612]
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026617] Pid: 2420, comm:=
 bash
>>>>>>>> Tainted: G =A0 =A0 =A0 =A0 C =A0 3.2.0-9-generic #17~oneiric1 =
System
>>>>>>>> manufacturer System Product Name/P8H67-M EVO
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.026649] RIP:
>>>>>>>> 0010:[<ffffffff812f3588>] =A0[<ffffffff812f3588>]
>>>>>>>> blk_rq_map_sg+0x178/0x350
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.027607] RSP: 0018:ffff88=
0420fbf7c8
>>>>>>>> =A0EFLAGS: 00010002
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.028564] RAX: 00000000000=
00000 RBX:
>>>>>>>> ffff8803fa608a20 RCX: 2700013524000135
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.029529] RDX: 00000000000=
00011 RSI:
>>>>>>>> 0000000027000135 RDI: ffff8803fa608a00
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.030492] RBP: ffff880420f=
bf828 R08:
>>>>>>>> 0000000000001000 R09: ffff880421862f00
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.031455] R10: 00000000000=
00001 R11:
>>>>>>>> 0000000000000001 R12: ffff8803fa60a510
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.032417] R13: 00000000270=
00135 R14:
>>>>>>>> ffff8803fa60a520 R15: 00000000000000d3
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.033385] FS:
>>>>>>>> 00007f5259391720(0000) GS:ffff88043f400000(0000)
>>>>>>>> knlGS:0000000000000000
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.034361] CS: =A00010 DS: =
0000 ES:
>>>>>>>> 0000 CR0: 000000008005003b
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.035336] CR2: 00007f6d332=
e8000 CR3:
>>>>>>>> 0000000401c16000 CR4: 00000000000406f0
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.036310] DR0: 00000000000=
00000 DR1:
>>>>>>>> 0000000000000000 DR2: 0000000000000000
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.037287] DR3: 00000000000=
00000 DR6:
>>>>>>>> 00000000ffff0ff0 DR7: 0000000000000400
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.038266] Process bash (pi=
d: 2420,
>>>>>>>> threadinfo ffff880420fbe000, task ffff880403b3dc40)
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.039252] Stack:
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.040220] =A00000000000000=
011
>>>>>>>> ffff880400fcd2b0 ffff8803fa608800 0100000000000001
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.041196] =A0ffff8804213a3=
368
>>>>>>>> ffff880421862f00 ffff880420fbf828 ffff8804209cb858
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.042171] =A0ffff880400fcd=
2b0
>>>>>>>> 0000000000000001 0000000000000020 ffff880424e96800
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.043130] Call Trace:
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.044070] =A0[<ffffffff814=
42521>]
>>>>>>>> scsi_init_sgtable+0x41/0x70
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.045036] =A0[<ffffffff814=
4258d>]
>>>>>>>> scsi_init_io+0x3d/0x150
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.045983] =A0[<ffffffff814=
4279a>]
>>>>>>>> scsi_setup_fs_cmnd.part.34+0x5a/0x90
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.046917] =A0[<ffffffff814=
427ff>]
>>>>>>>> scsi_setup_fs_cmnd+0x2f/0x40
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.047837] =A0[<ffffffff814=
5fb3f>]
>>>>>>>> sd_prep_fn+0xaf/0xaf0
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.048747] =A0[<ffffffff813=
017f4>] ?
>>>>>>>> cfq_dispatch_request+0x64/0xa0
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.049654] =A0[<ffffffff812=
eecda>]
>>>>>>>> blk_peek_request+0xba/0x240
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.050558] =A0[<ffffffff814=
42cf8>]
>>>>>>>> scsi_request_fn+0x58/0x4c0
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.051461] =A0[<ffffffff812=
e7c73>] ?
>>>>>>>> __elv_add_request+0x1b3/0x290
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.052361] =A0[<ffffffff812=
ef590>]
>>>>>>>> blk_queue_bio+0x290/0x380
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.053262] =A0[<ffffffff812=
ec114>]
>>>>>>>> generic_make_request.part.50+0x74/0xb0
>>>>>>>> Jan 20 11:24:36 dev1 kernel: [ =A0119.054170] =A0[<ffffffff812=
ec528>]
>>>>>>>> generic_make_request+0x68/0x70
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linu=
x-bcache" in
>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-inf=
o.html
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-bcache" in
>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info=
=2Ehtml
