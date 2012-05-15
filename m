From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel BUGS at fs/direct-io.c and drivers/scsi/scsi_lib.c
Date: Mon, 14 May 2012 18:20:59 -0700
Message-ID: <CAH+dOxKnVieeF-7yGQzBPv+9ET_wRDk8cJv1VWdhBeyvYqqJig@mail.gmail.com>
References: <1336993043.3305.64.camel@dimension7>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336993043.3305.64.camel@dimension7>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Pyrgiotis <apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vkoukis-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Well, it's not the 32 bit kernel that's causing it. Anything else you
can tell me about your configuration?

On Mon, May 14, 2012 at 3:57 AM, Alex Pyrgiotis
<apyrgio-Hpc4xzY4zrDSDkk6z29a7FAUjnlXr6A1@public.gmane.org> wrote:
> Hi all,
>
> I've been trying to test bcache, but I'm running into some kernel oop=
ses
> that might be of interest.
>
> I'm running a 32-bit build of the kernel in the linux-bache git repo =
on
> my machine (not using virtualisation) and I'm doing the following sim=
ple
> test*: I have two logical partitions in my hard drive (/dev/sda6
> and /dev/sda7), and I'm trying to use sda6 as a cache device for sda7
> (backing device).
>
> These are the steps that I take:
>
> mkfs -t ext4 /dev/sda6
> mkfs -t ext4 /dev/sda7
> /usr/sbin/make-bcache -C -w2k -b512k /dev/sda6
> /usr/sbin/make-bcache -B /dev/sda7
> echo /dev/sda6 > /sys/fs/bcache/register
> echo /dev/sda7 > /sys/fs/bcache/register
> echo CACHE_SET_UUID > /sys/block/sda/sda7/bcache/attach
> dev=3D`cat /sys/block/bcache0/dev | sed -e 's/:/ /'`
> mknod -m 0660 /dev/test b $dev
> mkfs -t ext4 /dev/test
> mount /dev/test /media/bcache
>
> So, after that last step, I should be able to have a writethrough cac=
he
> device (/dev/sda6) attached to a backing device (/dev/sda7) mounted
> at /media/bcache, right?
>
> However, a simple direct write to /media/bcache:
>
> dd if=3D/dev/urandom of=3D/media/bcache/tmp bs=3D16k count=3D500 ofla=
g=3Ddirect
>
> has the following result
>
> ---------------- START OF BUG REPORT ---------------------------
> May 14 12:49:07 dimension7 kernel: [ 2519.267614] kernel BUG at
> fs/direct-io.c:647!
> May 14 12:49:07 dimension7 kernel: [ 2519.267686] invalid opcode: 000=
0
> [#1] SMP
> May 14 12:49:07 dimension7 kernel: [ 2519.267762] Modules linked in:
> iwlwifi ext4 jbd2 acpi_cpufreq mperf cpufreq_stats cpufreq_powersave
> cpufreq_conservative cpufreq_userspace ebtable_nat ebtables
> ip6table_filter ip6_tables iptable_filter ip_tables x_tables parport_=
pc
> ppdev lp parport cryptd aes_i586 aes_generic bnep rfcomm binfmt_misc
> uinput fuse nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc loop
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> i915 snd_hwdep snd_pcm drm_kms_helper joydev snd_page_alloc drm snd_s=
eq
> arc4 snd_seq_device snd_timer evdev btusb battery snd psmouse
> i2c_algo_bit uvcvideo mac80211 videodev soundcore cfg80211 bluetooth
> media i2c_i801 rfkill i2c_core iTCO_wdt iTCO_vendor_support ac
> power_supply serio_raw processor pcspkr button video crc16 ext3 mbcac=
he
> jbd btrfs crc32c libcrc32c zlib_deflate dm_mod sd_mod crc_t10dif sr_m=
od
> cdrom fan thermal thermal_sys ahci libahci libata ehci_hcd r8169 mii
> scsi_mod usbcore usb_common [last unloaded: iwlwifi]
> May 14 12:49:07 dimension7 kernel: [ 2519.269498]
> May 14 12:49:07 dimension7 kernel: [ 2519.269528] Pid: 3123, comm: dd
> Not tainted 3.2.14-apyrgio-bcache-12.2+ #1 SAMSUNG ELECTRONICS CO., L=
TD.
> 300E4A/300E5A/300E7A/3430EA/3530EA/300E4A/300E5A/300E7A/3430EA/3530EA
> May 14 12:49:07 dimension7 kernel: [ 2519.269777] EIP: 0060:[<c10eec7=
4>]
> EFLAGS: 00010246 CPU: 0
> May 14 12:49:07 dimension7 kernel: [ 2519.269872] EIP is at
> dio_new_bio.isra.6+0x8e/0xfb
> May 14 12:49:07 dimension7 kernel: [ 2519.269948] EAX: 00000000 EBX:
> e4849c78 ECX: e4849d00 EDX: 00000000
> May 14 12:49:07 dimension7 kernel: [ 2519.270044] ESI: 00000004 EDI:
> e4849c78 EBP: f6d54e40 ESP: e4849bc4
> May 14 12:49:07 dimension7 kernel: [ 2519.270141] =A0DS: 007b ES: 007=
b FS:
> 00d8 GS: 00e0 SS: 0068
> May 14 12:49:07 dimension7 kernel: [ 2519.270228] Process dd (pid: 31=
23,
> ti=3De4848000 task=3Df0c2c670 task.ti=3De4848000)
> May 14 12:49:07 dimension7 kernel: [ 2519.270337] Stack:
> May 14 12:49:07 dimension7 kernel: [ 2519.270370] =A00000000c e4849c7=
8
> f6d54e40 e4849d00 f6d54e40 c10eed8f 00008600 00000000
> May 14 12:49:07 dimension7 kernel: [ 2519.270528] =A0e4849d1c e4849c7=
8
> 00001000 00000000 c10eee90 f6185760 f618b720 00008601
> May 14 12:49:07 dimension7 kernel: [ 2519.270683] =A000000000 0000000=
1
> 00000004 00000000 f6d54e40 c10ef7bb 00000000 00001000
> May 14 12:49:07 dimension7 kernel: [ 2519.270838] Call Trace:
> May 14 12:49:07 dimension7 kernel: [ 2519.270887] =A0[<c10eed8f>] ?
> dio_send_cur_page+0x5f/0xa9
> May 14 12:49:07 dimension7 kernel: [ 2519.270971] =A0[<c10eee90>] ?
> submit_page_section+0xb7/0x121
> May 14 12:49:07 dimension7 kernel: [ 2519.271061] =A0[<c10ef7bb>] ?
> __blockdev_direct_IO+0x787/0xa58
> May 14 12:49:07 dimension7 kernel: [ 2519.271169] =A0[<f95377e4>] ?
> noalloc_get_block_write+0x30/0x30 [ext4]
> May 14 12:49:07 dimension7 kernel: [ 2519.271287] =A0[<f955eb19>] ?
> ext4_ind_direct_IO+0x214/0x341 [ext4]
> May 14 12:49:07 dimension7 kernel: [ 2519.271392] =A0[<f95377e4>] ?
> noalloc_get_block_write+0x30/0x30 [ext4]
> May 14 12:49:07 dimension7 kernel: [ 2519.271503] =A0[<f953588d>] ?
> ext4_direct_IO+0x1e8/0x242 [ext4]
> May 14 12:49:07 dimension7 kernel: [ 2519.271596] =A0[<c10968c7>] ?
> generic_file_direct_write+0xde/0x164
> May 14 12:49:07 dimension7 kernel: [ 2519.271692] =A0[<c1096ac0>] ?
> __generic_file_aio_write+0x173/0x282
> May 14 12:49:07 dimension7 kernel: [ 2519.271788] =A0[<c107b6a0>] ?
> rcu_enter_nohz+0xc/0x55
> May 14 12:49:07 dimension7 kernel: [ 2519.271868] =A0[<c1024bcd>] ?
> arch_flush_lazy_mmu_mode+0x5/0x14
> May 14 12:49:07 dimension7 kernel: [ 2519.271958] =A0[<c1096c2c>] ?
> generic_file_aio_write+0x5d/0xb3
> May 14 12:49:07 dimension7 kernel: [ 2519.272058] =A0[<f9532afa>] ?
> ext4_file_write+0x1f4/0x242 [ext4]
> May 14 12:49:07 dimension7 kernel: [ 2519.272151] =A0[<c10cb985>] ?
> wait_on_retry_sync_kiocb+0x3c/0x3c
> May 14 12:49:07 dimension7 kernel: [ 2519.272241] =A0[<c10cba25>] ?
> do_sync_write+0xa0/0xd4
> May 14 12:49:07 dimension7 kernel: [ 2519.272321] =A0[<c102a3d0>] ?
> should_resched+0x5/0x1e
> May 14 12:49:07 dimension7 kernel: [ 2519.272402] =A0[<c12d5ff1>] ?
> _cond_resched+0x5/0x18
> May 14 12:49:07 dimension7 kernel: [ 2519.272479] =A0[<c10cbf37>] ?
> rw_verify_area+0xc6/0xe7drivers/scsi/scsi_lib.c
> May 14 12:49:07 dimension7 kernel: [ 2519.272557] =A0[<c10cc1d7>] ?
> vfs_write+0x83/0xd4
> May 14 12:49:07 dimension7 kernel: [ 2519.272629] =A0[<c10cc397>] ?
> sys_write+0x3d/0x61
> May 14 12:49:07 dimension7 kernel: [ 2519.272704] =A0[<c12db7df>] ?
> sysenter_do_call+0x12/0x28
> May 14 12:49:07 dimension7 kernel: [ 2519.272783] Code: 8b 43 04 8b 5=
4
> 24 20 8b 73 10 89 04 24 8b 02 e8 62 d1 ff ff 81 fe 00 01 00 00 ba 00 =
01
> 00 00 0f 4e d6 39 c2 0f 4f d0 85 d2 7f 02 <0f> 0b 8b 44 24 20 8b 38 b=
8
> d0 00 00 00 e8 b8 de ff ff 8b 0c 24
> May 14 12:49:07 dimension7 kernel: [ 2519.273357] EIP:
> [<c10eec74>]drivers/scsi/scsi_lib.c dio_new_bio.isra.6+0x8e/0xfb SS:E=
SP
> 0068:e4849bc4
> May 14 12:49:07 dimension7 kernel: [ 2519.331754] ---[ end trace
> 29cd0273421f55a6 ]---
> ---------------- END OF BUG REPORT ---------------------------
>
>
>
>
>
>
> I can assure you though that this problem is not restricted only to
> direct I/O.
> The following (incomplete due to a broken pipe) bug report is when
> writing without direct I/O flag:
>
>
>
>
>
>
> ---------------- START OF BUG REPORT ---------------------------
> May 14 10:45:18 dimension7 kernel: [ 5408.870981] ------------[ cut
> here ]------------
> May 14 10:45:18 dimension7 kernel: [ 5408.871019] kernel BUG at
> drivers/scsi/scsi_lib.c:1153!
> May 14 10:45:18 dimension7 kernel: [ 5408.871051] invalid opcode: 000=
0
> [#1] SMP
>
> Message from syslogd@dimension7 at May 14 10:45:18 ...
> =A0kernel:[ 5408.870981] ------------[ cut here ]------------
>
> Message from syslogd@dimension7 at May 14 10:45:18 ...
> =A0kernel:[ 5408.871051] invalid opcode: 0000 [#1] SMP
> May 14 10:45:18 dimension7 kernel: [ 5408.871082] Modules linked in:
> ext4 jbd2 xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack iwlwifi acpi_cpufreq mperf cpufreq_stats cpufreq_powersa=
ve
> cpufreq_conservative cpufreq_userspace ebtable_nat ebtables
> ip6table_filter ip6_tables iptable_filter ip_tables x_tables parport_=
pc
> ppdev lp parport bnep rfcomm cryptd binfmt_misc aes_i586 aes_generic
> uinput fuse nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc loop
> snd_hda_codec_hdmi snd_hda_codec_realtek arc4 snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq snd_seq_device
> snd_timer mac80211 snd joydev cfg80211 i915 btusb uvcvideo bluetooth
> videodev soundcore drm_kms_helper drm media psmouse i2c_algo_bit batt=
ery
> evdev i2c_i801 rfkill i2c_core iTCO_wdt iTCO_vendor_support serio_raw=
 ac
> power_supply crc16 pcspkr video button processor ext3 mbcache jbd btr=
fs
> crc32c libcrc32c zlib_deflate dm_mod sr_mod cdrom sd_mod crc_t10dif
> thermal fan thermal_sys ahci libahci ehci_hcd libata r8169 mii scsi_m=
od
> usb
> May 14 10:45:18 dimension7 kernel: core usb_common [last unloaded:
> iwlwifi]
> May 14 10:45:18 dimension7 kernel: [ 5408.871790]
> May 14 10:45:18 dimension7 kernel: [ 5408.871802] Pid: 4265, comm:
> flush-254:0 Not tainted 3.2.14-apyrgio-bcache-12.2+ #1 SAMSUNG
> ELECTRONICS CO., LTD.
> 300E4A/300E5A/300E7A/3430EA/3530EA/300E4A/300E5A/300E7A/3430EA/3530EA
> May 14 10:45:18 dimension7 kernel: [ 5408.871903] EIP: 0060:[<f8249c1=
e>]
> EFLAGS: 00010046 CPU: 0
> May 14 10:45:18 dimension7 kernel: [ 5408.871943] EIP is at
> scsi_setup_fs_cmnd+0x3b/0x72 [scsi_mod]
> May 14 10:45:18 dimension7 kernel: [ 5408.871978] EAX: 00000000 EBX:
> f1ecec00 ECX: f1ecec00 EDX: eb5ebb40
> May 14 10:45:18 dimension7 kernel: [ 5408.872016] ESI: eb5ebb40 EDI:
> f6c1f400 EBP: 00000000 ESP: d0291ae8
> May 14 10:45:18 dimension7 kernel: [ 5408.872052] =A0DS: 007b ES: 007=
b FS:
> 00d8 GS: 00e0 SS: 0068
> May 14 10:45:18 dimension7 kernel: [ 5408.872086] Process flush-254:0
> (pid: 4265, ti=3Dd0290000 task=3Df0c709a0 task.ti=3Dd0290000)
> May 14 10:45:18 dimension7 kernel: [ 5408.872131] Stack:
> May 14 10:45:18 dimension7 kernel: [ 5408.872144] =A000044010 0000000=
0
> f6c1f400 f83375d1 c1158870 eb5ebb40 00000000 f1e75800
> May 14 10:45:18 dimension7 kernel: [ 5408.872205] =A0eb5ebb40 0000000=
1
> f1ecec00 c115a8ff 06a96028 f1ed9ad8 f1e75a01 00000000
> May 14 10:45:18 dimension7 kernel: [ 5408.872264] =A0eb5ebb40 f1ed9ad=
8
> f1ed9ad8 f1ecec28 c114e00b f1ecec00 f1f22400 f1ed9ad8
> May 14 10:45:18 dimension7 kernel: [ 5408.872324] Call Trace:
> May 14 10:45:18 dimension7 kernel: [ 5408.872346] =A0[<f83375d1>] ?
> sd_prep_fn+0x2a5/0xb3e [sd_mod]
> May 14 10:45:18 dimension7 kernel: [ 5408.872383] =A0[<c1158870>] ?
> cfq_dispatch_insert+0xc0/0xc7
> May 14 10:45:18 dimension7 kernel: [ 5408.872416] =A0[<c115a8ff>] ?
> cfq_dispatch_requests+0x635/0x751
> May 14 10:45:18 dimension7 kernel: [ 5408.872452] =A0[<c114e00b>] ?
> blk_peek_request+0xad/0x17a
> May 14 10:45:18 dimension7 kernel: [ 5408.872490] =A0[<f82496c6>] ?
> scsi_request_fn+0x4d/0x38c [scsi_mod]
> May 14 10:45:18 dimension7 kernel: [ 5408.872527] =A0[<c1149e2f>] ?
> __blk_run_queue+0x11/0x12
> May 14 10:45:18 dimension7 kernel: [ 5408.872558] =A0[<c114dc3e>] ?
> queue_unplugged+0x5e/0x6c
> May 14 10:45:18 dimension7 kernel: [ 5408.872590] =A0[<c114e338>] ?
> blk_flush_plug_list+0x153/0x162
> May 14 10:45:18 dimension7 kernel: [ 5408.872625] =A0[<c12d6312>] ?
> io_schedule_timeout+0x3a/0x6a
> May 14 10:45:18 dimension7 kernel: [ 5408.872660] =A0[<c10979bf>] ?
> mempool_alloc+0xbb/0xd7
> May 14 10:45:18 dimension7 kernel: [ 5408.872691] =A0[<c104d628>] ?
> add_wait_queue+0x30/0x30
> May 14 10:45:18 dimension7 kernel: [ 5408.872723] =A0[<c10eca6a>] ?
> bio_alloc_bioset+0x23/0x9e
> May 14 10:45:18 dimension7 kernel: [ 5408.872754] =A0[<c10ecb49>] ?
> bio_alloc+0xb/0x20
> May 14 10:45:18 dimension7 kernel: [ 5408.872789] =A0[<f9531677>] ?
> ext4_bio_write_page+0x1ec/0x335 [ext4]
> May 14 10:45:18 dimension7 kernel: [ 5408.872831] =A0[<f952e492>] ?
> mpage_da_submit_io+0x30c/0x3ab [ext4]
> May 14 10:45:18 dimension7 kernel: [ 5408.872873] =A0[<f95301ea>] ?
> mpage_da_map_and_submit+0x39f/0x3ae [ext4]
> May 14 10:45:18 d
> ---------------- END OF BUG REPORT ---------------------------
>
>
>
> All the above can be reproduced at will.
>
> Well, does anyone have a clue? If more debug info is needed, I'll be
> glad to provide it.
>
> Regards,
> Alex
>
> *this test is moot of course. I did as the simplest work scenario to
> check if everything works ok.
>
> --
>
> Alex Pyrgiotis, a.k.a 03107422
> Undergrad Student
>
> School of Electrical & Computer Engineering
> National Technical University of Athens, Greece
>
> Paper Street Soap Co.
> work: (288) 555-0153
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
