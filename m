From: =?ISO-8859-1?Q?Jo=E3o_Trindade?= <trindade.joao@gmail.com>
Subject: Kernel bug 3.13.0 at drivers/md/bcache/btree.c:1168!
Date: Mon, 27 Jan 2014 23:41:29 +0000
Message-ID: <CAK7wQSjBvjoCCg=LGOvZZk_BBMa228sR4GObcc+1-12rKXsUPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:53124 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaA0Xlu (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 27 Jan 2014 18:41:50 -0500
Received: by mail-qa0-f51.google.com with SMTP id f11so8221757qae.24
        for <linux-bcache@vger.kernel.org>; Mon, 27 Jan 2014 15:41:49 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

Just had a kernel bug which froze the system. Running ext4 -> lvm -> bcache.

EL281373.738405J -L cut here j- .
.[281373.738686} kernel BUG at drivers/md/bcache/btree.c:1168! .
.[281373.739004} invalid opcode: 0000 [#1} SMP .
.[281373.739262} Modules linked in: quota_v2 quota_tree nfsd
auth_rpcgss Did_registr nfs_acl nfs lockd fscache sunrpc his_utfs n.
.Is_cp437 vfat fat loop x86_pkg_temp_thermal coretemp kvm_intel kvm
crc32c_intel ghash_clmulni_intel aesni_intel Bes_x86_64 ablk_
.helper Cr ptd Irw gfl2Smul glue_helper snd_pcm snd_page_alloc
snd_timer mgag2OO ipmi_si snd ttm soundcore ioatdma iTCO_wdt iTCO_
.vendor_support drm_kms_helper Ipc_ich mfd_core sh_edac edac_core
i2C_1801 evdev pcspkr mei_me drm mei ipmi_msghandler microcode .
.processor wmi thermal_s s button e t4 crc16 jbd2 mbcache dm_mod
bcache hid_generic sg usbhid hid sd_mod crc_tlOdif crctlOdif_com
.mon ehci_Dci ehci_hcd igb ahci isci usbcore libahci libsas
i2c_algo_bit usb_common scsi_transport_sas i2c_core dca libata ptp pp.
.s_core megaraid_sas scsi_mod .
.[281373.743815} CPU: 17 PID: 573 Comm: bcache_gc Not tainted 3.13.0-dsi #4 .
.[281373.744188} Hardware name: Supermicro
SYS-6O27R-72RF/X9DRH-7TF/7F/iTF/iF, BIDS 3.0 07/26/2013 .
.[281373.744710} task: ffffSS2o2deccO9O ti: ffff882O2ca96OOO taSk.ti:
ffff882O2ca96OOO .
.[281373.745155} RIP: 0010:[<ffffffffaOlSS4le>} [<ffffffffaOlSS4le>}
__bch_btree_mark_kc +O 171/o las [bcache} .
.[281373.745736} RSP: 0018:ffffSS2O2ca97cbS EFL GS: 00010246 .
.[281373.764512} R X: 0000000000000002 RSX: ffff88Offb9cO3f8 RCX:
0000000000002000 .
.[281373.783484} RDX: 0000000000000002 RSI: ffff88Offb9cO3f8 ROI:
ffffSS2o2baeOOOO .
.[281373.802490} RBP: 0000000000000000 ROB: O0OOOOOOOOOOOOO1 RO9:
ffffSS2o2bSe2OOO .
.[281373.821186} RIO: 0000000000000800 Rll: ffffSSlo2dldlcOO Rl2:
0000000000000000 .
.[281373.839640} R13: ffffSS2o2baeOOOO Rl4: 0000000000000001 R15:
ffffc9oo2e2399dc .
.[281373.858103} FS: 0000000000000000(0000) GS:ffffSSlo7fd2ooOO(0000)
knlGS:0000000000000OOO .
.[281373.876583} CS: 0010 OS: 0000 ES: 0000 CRO: 0000000080050033 .
.[281373.894913} CR2: OOOO7f9bcf6d5flO CR3: 0000000OO16OCOOO CR4:
ooooooooool4o7eo .
.[281373.913513} StaCk: .
.[281373.931462} ffff88Offb9cO3f8 OOOOOOO25be8OOOO ffffSSlo2dldlcOO
ffffSSlo2dldlcOO .
.[281373.949820} ffff88Offb9cO3f8 0000000000000029 0000000000000001
ffffSS2o2ca97dcS .
.[281373.968013} ffffSS2O2ca97dlS ffffffffaOlSS72a ffffSS2o2deccO9O
OOOOO0000OOOOOOO .
.[281373.986104} Call Trace: .
.[281374.003937} [<ffffffffaOlSS72a>} btree_gc_mark_node+O 4c!O 16d [bcache} .
.[281374.022020} [<ffffffff811e8f13>} call_rwsem_down_write_failed+O 13!0 20 .
.[281374.039955} [<ffffffffaol8ao5e>} bch_btree_gc+O 187/0 387 [bcache} .
.[281374.057762} [<ffffffff81070064>} idle_balance+ox12b!ox166 .
.[281374.075458} [<ffffffff81066b48>} mmdrop+Oxd!Oxlc .
.[281374.092871} [<ffffffffaolSa2ab>} bch_gc_thread+O 2d!O ES [bcache} .
.[281374.110258} [<ffffffffaolSa27e>} bch_btree_gc+O 3a7!Ox3a7 [bcache} .
.[281374.127438} [<ffffffffaolSa27e>} bch_btree_gc+O 3a7!Ox3a7 [bcache} .
.[281374.144299} [<ffffffff8lO5f7aa>} kthread+Ox99/Oxal .
.[281374.160937} [<ffffffff8105f711>} __kthread_parkme+O 59/0 59 .
.[281374.177390} [<ffffffff813b588c>} ret_from_fork+Ox7c/OxbO .
.[281374.193553} [<ffffffff8105f711>} __kthread_parkme+O 59/0 59 .
.[281374.209619} Code: 00 01 cl bS ff 3f 00 00 81 f9 ff 3f 00 00 Of 46
cl 66 81 e2 03 80 25 ff if 00 00 CI eO 02 09 dO 66 a9 fC 7.
.f 66 41 89 47 oa 75 02 <Of> Ob ff CS eb 05 31 ed 45 31 e4 48 Sb 03 89
ea 48 cl ea 3c 83 .
.[281374.242894} RIP [<ffffffffaOlSS4le>} __bch_btree_mark_kc +O 171!0
las [bcache} .
.[281374.259593} RSP <ffffSS2o2ca97cbS> .
.[281374.339219} -[ end trace Of023c3ec916751b }- .
