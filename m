From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Can't register existing backing devices anymore
Date: Fri, 27 Oct 2017 19:38:19 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1710271937260.24585@mail.ewheeler.net>
References: <a3c0c8b9df96dc16c6bc682359c2893c@889215b17b02> <5eb849fa-8f0b-776a-b635-e3f5af122d75@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1344855302-1509133099=:24585"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:53848 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751417AbdJ0TiU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 15:38:20 -0400
In-Reply-To: <5eb849fa-8f0b-776a-b635-e3f5af122d75@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Michael Lyle <mlyle@lyle.org>, Jorg Bornschein <jb@capsec.org>, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1344855302-1509133099=:24585
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 25 Aug 2017, Coly Li wrote:

> On 2017/8/13 下午8:22, Jorg Bornschein wrote:
> > Hi, 
> > 
> > I just updated my kernel to 4.12.6 and I cant access my bcache partitions anymore: it seems it can't register the backing devices. I have a couple of '/usr/lib/udev/bcache-register /dev/dm-?' processes in state D and during boot I see the attached dmesg logs. 
> > 
> > My cache-set shows up in /sys/fs/bcache, but any interaction with the files therein block and I get more 'D' processes. Similarly, trying to explicitly register a backing device by running 'echo /dev/dm-? > /sys/fs/bcache/register' blocks indefinitely. I should probably mention that my backing devices are encrypted and get created by cryptsetup/crypttab.
> > 
> > 
> > Any ideas how to get this working again / how to debug this?
> >   
> 
> From the code of v4.12.6, it seems like sysfs entries can be accessed
> before allocator thread assigned to a cache set. Then I assume in
> bch_bucket_alloc() when waking up ca->alloc_thread, a NULL pointer sent
> in and finally trigger a NULL pointer deference on p->pi_lock.
> 
> A fast fix can be:
> @@ -404,7 +404,8 @@ long bch_bucket_alloc(struct cache *ca, unsigned
> reserve, bool wait)
> 
>         finish_wait(&ca->set->bucket_wait, &w);
>  out:
> -       wake_up_process(ca->alloc_thread);
> +       if (ca->alloc_thread)
> +               wake_up_process(ca->alloc_thread);
> 
>         trace_bcache_alloc(ca, reserve);
> 
> But for a proper fix, we should not open user space access interface
> before necessary resources are ready.


Has this been fixed elsewhere?  The suggested quick-fix doesn't appear in 
4.14-rc6 so maybe it was solved some other way?

--
Eric Wheeler

	


> 
> Coly
> 
> 
> > 
> > 
> > -- dmesg -- 
> > [   20.250680] BUG: unable to handle kernel NULL pointer dereference at 000000000000071c
> > [   20.266915] IP: _raw_spin_lock_irqsave+0x29/0x50
> > [   20.275259] PGD 6205dc067 
> > [   20.275259] P4D 6205dc067 
> > [   20.283582] PUD 62082b067 
> > [   20.291696] PMD 0 
> > [   20.314622] Oops: 0002 [#1] PREEMPT SMP
> > [   20.322296] Modules linked in: snd_hda_codec_realtek snd_hda_codec_generic ext4 crc16 jbd2 fscrypto mbcache nvidia_drm(PO) nvidia_modeset(PO) nvidia(PO) joydev input_leds iTCO_wdt iTCO_vendor_support bcache eeepc_wmi asus_wmi sparse_keymap rfkill evdev mxm_wmi mac_hid intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass intel_cstate intel_rapl_perf pcspkr snd_hda_intel drm_kms_helper snd_hda_codec e1000e drm mei_me syscopyarea sysfillrect sysimgblt fb_sys_fops snd_soc_rt5640 snd_hda_core i2c_i801 lpc_ich ptp snd_hwdep mei pps_core shpchp snd_soc_ssm4567 battery snd_soc_rl6231 snd_soc_core snd_compress snd_pcm_dmaengine snd_pcm snd_timer tpm_infineon snd wmi video soundcore elan_i2c ac97_bus i2c_hid i2c_designware_platform snd_soc_sst_acpi 8250_dw i2c_des
 ignware_core snd_soc_sst_match
> > [   20.421693]  spi_pxa2xx_platform button acpi_pad thermal fan tpm_tis tpm_tis_core tpm sch_fq_codel nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc vboxnetflt(O) vboxnetadp(O) pci_stub vboxpci(O) vboxdrv(O) sg ip_tables x_tables btrfs xor raid6_pq algif_skcipher af_alg dm_crypt dm_mod dax sd_mod hid_generic usbhid hid crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd ahci libahci xhci_pci libata ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore usb_common serio sdhci_acpi sdhci led_class mmc_core
> > [   20.508586] CPU: 1 PID: 442 Comm: bcache_allocato Tainted: P           O    4.12.6-1-ARCH #1
> > [   20.532011] Hardware name: ASUS All Series/Z97-A, BIOS 1204 06/20/2014
> > [   20.543827] task: ffffa08b20702ac0 task.stack: ffffc3d4040b8000
> > [   20.555664] RIP: 0010:_raw_spin_lock_irqsave+0x29/0x50
> > [   20.567536] RSP: 0000:ffffc3d4040bbd18 EFLAGS: 00010046
> > [   20.579663] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
> > [   20.592200] RDX: 0000000000000001 RSI: 0000000000000003 RDI: 000000000000071c
> > [   20.604749] RBP: ffffc3d4040bbd20 R08: ffffffffc08b1aa0 R09: 0000000000000400
> > [   20.617538] R10: 00000000000001ff R11: ffffc3d403e01000 R12: 000000000000071c
> > [   20.630385] R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000000
> > [   20.642974] FS:  0000000000000000(0000) GS:ffffa08b3ec80000(0000) knlGS:0000000000000000
> > [   20.667306] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   20.679479] CR2: 000000000000071c CR3: 000000061f609000 CR4: 00000000001406e0
> > [   20.691625] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   20.703440] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [   20.714882] Call Trace:
> > [   20.725912]  try_to_wake_up+0x40/0x440
> > [   20.736717]  wake_up_process+0x15/0x20
> > [   20.747215]  bch_bucket_alloc+0xa5/0x350 [bcache]
> > [   20.757541]  ? wake_bit_function+0x60/0x60
> > [   20.767605]  bch_prio_write+0x186/0x330 [bcache]
> > [   20.777471]  bch_allocator_thread+0x569/0xc80 [bcache]
> > [   20.787124]  kthread+0x125/0x140
> > [   20.796430]  ? bch_invalidate_one_bucket+0x80/0x80 [bcache]
> > [   20.805724]  ? kthread_create_on_node+0x70/0x70
> > [   20.814722]  ret_from_fork+0x25/0x30
> > [   20.823404] Code: 40 00 0f 1f 44 00 00 55 48 89 e5 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 65 ff 05 3e 03 9b 63 31 c0 ba 01 00 00 00 <f0> 0f b1 17 85 c0 75 06 48 89 d8 5b 5d c3 89 c6 e8 e2 14 a7 ff 
> > [   20.849925] RIP: _raw_spin_lock_irqsave+0x29/0x50 RSP: ffffc3d4040bbd18
> > [   20.858827] CR2: 000000000000071c
> > [   20.867491] ---[ end trace a9fcbcbb689c1804 ]---
> > [   20.876143] note: bcache_allocato[442] exited with preempt_count 1
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> Coly Li
> 
--1641074820-1344855302-1509133099=:24585--
