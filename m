From: Nick Payne <nick.payne-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Subject: Re: Bcache volume no longer mounts
Date: Fri, 23 Aug 2013 15:30:36 +1000
Message-ID: <5216F37C.5020003@internode.on.net>
References: <5216ACAB.7090603@internode.on.net> <CAPBO7TZ0+eK3a0-tEXn1iDbk716AzZg3+8K=LmUj8+wDbnOCFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPBO7TZ0+eK3a0-tEXn1iDbk716AzZg3+8K=LmUj8+wDbnOCFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On 23/08/2013 3:15 PM, Josep Lladonosa wrote:
> On 23 August 2013 02:28, Nick Payne <nick.payne-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org> wrote:
>> I have /home on a bcache partition - cache device is a 120GB Intel 330 SSD
>> on /dev/sdb, backing store device a WD Green 2TB on /dev/sdd. Kernel is
>> 3.10.9 installed from the Ubuntu mainline PPA. Was working fine up to
>> shutdown last night. On bootup this morning, /home would not mount. Running
>> fdisk shows sdb and sdd are recognised. Extracts from syslog this morning
>> below. Any suggestions on how to recover the partition?
>>
>> Aug 23 06:38:15 nick-desktop kernel: [    4.741912] bcache:
>> bch_journal_replay() journal replay done, 126 keys in 20 entries, seq 141014
>> Aug 23 06:38:15 nick-desktop kernel: [    4.742069] bcache: register_cache()
>> registered cache device sdb
>> Aug 23 06:38:15 nick-desktop kernel: [    4.742542] bcache: register_bdev()
>> registered backing device sdd
>> Aug 23 06:38:15 nick-desktop kernel: [    4.892531] bcache:
>> bch_cached_dev_attach() Caching sdd as bcache0 on set
>> 07df2e18-1b29-4226-a937-4b3cda8a6bb3
>> ...
>> Aug 23 06:38:15 nick-desktop kernel: [   23.049339] bcache:
>> register_bcache() error opening /dev/sdd: device busy
>> Aug 23 06:38:15 nick-desktop kernel: [   23.049834] bcache:
>> register_bcache() error opening /dev/sdb: device busy
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050117] input: HDA Intel PCH
>> Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050184] input: HDA Intel PCH
>> Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050237] input: HDA Intel PCH
>> Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050294] input: HDA Intel PCH
>> Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050347] input: HDA Intel PCH
>> Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050393] input: HDA Intel PCH
>> Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050441] input: HDA Intel PCH
>> Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050492] input: HDA Intel PCH
>> Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050767] hda_intel: Disabling MSI
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050776] hda-intel 0000:01:00.1:
>> Handle VGA-switcheroo audio client
>> Aug 23 06:38:15 nick-desktop kernel: [   23.050812] hda-intel 0000:01:00.1:
>> Disabling 64bit DMA
>> Aug 23 06:38:15 nick-desktop kernel: [   23.054591] hda-intel 0000:01:00.1:
>> Enable delay in RIRB handling
>> Aug 23 06:38:15 nick-desktop kernel: [   23.058089] device-mapper:
>> multipath: version 1.5.1 loaded
>> Aug 23 06:38:15 nick-desktop kernel: [   23.108359] microcode: CPU1
>> sig=0x206d7, pf=0x4, revision=0x70c
>> Aug 23 06:38:15 nick-desktop kernel: [   23.106489] asus_wmi: ASUS WMI
>> generic driver loaded
>> Aug 23 06:38:15 nick-desktop kernel: [   23.108989] asus_wmi:
>> Initialization: 0x0asus_wmi: BIOS WMI version: 0.9asus_wmi: SFUN value:
>> 0x0<6>[   23.109392] input: Eee PC WMI hotkeys as
>> /devices/platform/eeepc-wmi/input/input15
>> Aug 23 06:38:15 nick-desktop kernel: [   23.109693] microcode: CPU2
>> sig=0x206d7, pf=0x4, revision=0x70c
>> Aug 23 06:38:15 nick-desktop kernel: [   23.110802] microcode: CPU3
>> sig=0x206d7, pf=0x4, revision=0x70c
>> Aug 23 06:38:15 nick-desktop kernel: [   23.110827] asus_wmi: Disabling ACPI
>> video driver
>> Aug 23 06:38:15 nick-desktop kernel: [   23.112529] microcode: CPU4
>> sig=0x206d7, pf=0x4, revision=0x70c
>> Aug 23 06:38:15 nick-desktop kernel: [   23.114268] microcode: CPU5
>> sig=0x206d7, pf=0x4, revision=0x70c
>> Aug 23 06:38:15 nick-desktop kernel: [   23.115423] microcode: CPU6
>> sig=0x206d7, pf=0x4, revision=0x70c
>> Aug 23 06:38:15 nick-desktop kernel: [   23.116318] microcode: CPU7
>> sig=0x206d7, pf=0x4, revision=0x70c
>> Aug 23 06:38:15 nick-desktop kernel: [   23.117328] microcode: Microcode
>> Update Driver: v2.00 <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, Peter Oruba
>> Aug 23 06:38:15 nick-desktop kernel: [   23.157780] EXT4-fs (sdc2): mounted
>> filesystem with ordered data mode. Opts: (null)
>> Aug 23 06:38:15 nick-desktop kernel: [   23.521662] input: HDA NVidia
>> HDMI/DP,pcm=9 as
>> /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input16
>> Aug 23 06:38:15 nick-desktop kernel: [   23.521735] input: HDA NVidia
>> HDMI/DP,pcm=8 as
>> /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input17
>> Aug 23 06:38:15 nick-desktop kernel: [   23.521793] input: HDA NVidia
>> HDMI/DP,pcm=7 as
>> /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input18
>> Aug 23 06:38:15 nick-desktop kernel: [   23.521865] input: HDA NVidia
>> HDMI/DP,pcm=3 as
>> /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input19
>> Aug 23 06:38:15 nick-desktop kernel: [   23.535242] EXT4-fs (bcache0):
>> mounted filesystem with ordered data mode. Opts: (null)
>> ...
>> Aug 23 06:38:35 nick-desktop kernel: [   42.281256] EXT4-fs error (device
>> bcache0): __ext4_new_inode:912: comm xdg-user-dirs-g: failed to insert inode
>> 73538126: doubly allocated?
>> Aug 23 06:38:35 nick-desktop dbus[1627]: [system] Activating service
>> name='org.freedesktop.UDisks2' (using servicehelper)
>> Aug 23 06:38:35 nick-desktop udisksd[3246]: udisks daemon version 2.1.0
>> starting
>> Aug 23 06:38:35 nick-desktop dbus[1627]: [system] Successfully activated
>> service 'org.freedesktop.UDisks2'
>> Aug 23 06:38:35 nick-desktop udisksd[3246]: Acquired the name
>> org.freedesktop.UDisks2 on the system message bus
>> Aug 23 06:38:35 nick-desktop kernel: [   42.480907] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:35 nick-desktop kernel: [   42.988373] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:35 nick-desktop kernel: [   43.024971] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:35 nick-desktop kernel: [   43.027903] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:35 nick-desktop kernel: [   43.038062] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:35 nick-desktop kernel: [   43.038596] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:35 nick-desktop kernel: [   43.040174] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.273651] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 8978, 9666 clusters in bitmap,
>> 9663 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.325750] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.325996] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.326652] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.327458] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.328120] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.328809] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.328992] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.329304] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.329481] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.329598] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.329822] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.330179] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.330420] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.330667] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.330887] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.356401] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924624: comm cinnamon: deleted inode
>> referenced: 73925384
>> Aug 23 06:38:36 nick-desktop kernel: [   43.423294] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 0, 23179 clusters in bitmap,
>> 23325 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.438000] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 21, 2089 clusters in bitmap,
>> 1995 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.438501] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 23, 4725 clusters in bitmap,
>> 4492 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.445559] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 52, 1161 clusters in bitmap,
>> 1064 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.470211] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924620: comm cinnamon: deleted inode
>> referenced: 73925381
>> Aug 23 06:38:36 nick-desktop kernel: [   43.662031] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 1046, 4460 clusters in bitmap,
>> 4505 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.666754] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.666842] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.667112] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.667305] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 1048, 32338 clusters in bitmap,
>> 32242 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.667347] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.667627] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.667700] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm pool: deleted inode
>> referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.686535] EXT4-fs error (device
>> bcache0): ext4_lookup:1437: inode #73924632: comm gvfsd-metadata: deleted
>> inode referenced: 73925382
>> Aug 23 06:38:36 nick-desktop kernel: [   43.686818] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 9026, 10258 clusters in bitmap,
>> 10256 in gd
>> Aug 23 06:38:36 nick-desktop kernel: [   43.686920] JBD2: Spotted dirty
>> metadata buffer (dev = bcache0, blocknr = 0). There's a risk of filesystem
>> corruption in case of system crash.
>> Aug 23 06:38:36 nick-desktop kernel: [   43.689092] JBD2: Spotted dirty
>> metadata buffer (dev = bcache0, blocknr = 0). There's a risk of filesystem
>> corruption in case of system crash.
>> Aug 23 06:38:37 nick-desktop kernel: [   44.639789] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 9218, 866 clusters in bitmap,
>> 909 in gd
>> Aug 23 06:38:37 nick-desktop kernel: [   44.720574] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 9889, 32250 clusters in bitmap,
>> 32262 in gd
>> Aug 23 06:38:37 nick-desktop kernel: [   45.084439] JBD2: Spotted dirty
>> metadata buffer (dev = bcache0, blocknr = 0). There's a risk of filesystem
>> corruption in case of system crash.
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [pulseaudio] authkey.c:
>> Failed to open cookie file '/etc/timidity/.config/pulse/cookie': No such
>> file or directory
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [pulseaudio] authkey.c:
>> Failed to load authorization key '/etc/timidity/.config/pulse/cookie': No
>> such file or directory
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [pulseaudio] authkey.c:
>> Failed to open cookie file '/etc/timidity/.pulse-cookie': No such file or
>> directory
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [pulseaudio] authkey.c:
>> Failed to load authorization key '/etc/timidity/.pulse-cookie': No such file
>> or directory
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [pulseaudio] authkey.c:
>> Failed to open cookie file '/etc/timidity/.config/pulse/cookie': No such
>> file or directory
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [pulseaudio] authkey.c:
>> Failed to load authorization key '/etc/timidity/.config/pulse/cookie': No
>> such file or directory
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [autospawn] core-util.c: Home
>> directory not accessible: Permission denied
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [autospawn] lock-autospawn.c:
>> Cannot access autospawn lock.
>> Aug 23 06:38:38 nick-desktop pulseaudio[3442]: [pulseaudio] main.c: Failed
>> to acquire autospawn lock
>> Aug 23 06:38:38 nick-desktop NetworkManager[1703]: <info> (eth0): IP6
>> addrconf timed out or failed.
>> Aug 23 06:38:38 nick-desktop NetworkManager[1703]: <info> Activation (eth0)
>> Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
>> Aug 23 06:38:38 nick-desktop NetworkManager[1703]: <info> Activation (eth0)
>> Stage 4 of 5 (IPv6 Configure Timeout) started...
>> Aug 23 06:38:38 nick-desktop NetworkManager[1703]: <info> Activation (eth0)
>> Stage 4 of 5 (IPv6 Configure Timeout) complete.
>> Aug 23 06:39:10 nick-desktop kernel: [   77.755195] EXT4-fs error (device
>> bcache0): mb_free_blocks:1426: group 8965, block 293776389:freeing already
>> freed block (bit 11269)
>> Aug 23 06:39:10 nick-desktop kernel: [   77.755208] EXT4-fs error (device
>> bcache0): ext4_mb_generate_buddy:755: group 8965, 16121 clusters in bitmap,
>> 16124 in gd
>> Aug 23 06:39:36 nick-desktop kernel: [  103.731157] EXT4-fs warning (device
>> bcache0): ext4_unlink:2762: Deleting nonexistent file (73925382), 0
>>
>> At this point, msg on console about inability to mount /home. I selected
>> manual recovery, tried to look at a few logs, then rebooted. Bcache msgs
>> from syslog on reboot:
>>
>> Aug 23 06:44:12 nick-desktop kernel: [    1.985894] bcache: error on
>> 07df2e18-1b29-4226-a937-4b3cda8a6bb3: spotted bad key 0:3178037263 len 65535
>> -> []: bad, no pointers, disabling caching
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986037] CPU: 0 PID: 74 Comm:
>> kworker/0:1 Not tainted 3.10.9-031009-generic #201308201935
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986104] Hardware name: System
>> manufacturer System Product Name/P9X79 LE, BIOS 4106 07/15/2013
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986177] Workqueue: events
>> bch_btree_read_done [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986259] ffff8807f9de6020
>> ffff88080357bc48 ffffffff816fb2ea ffff88080357bcd8
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986450] ffffffffa00712d8
>> ffff8808034e2ee0 3330383731333a30 6e656c2033363237
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986640] 2d20353335353620
>> ffff88005d5b203e ffffffff81038078 ffff88080357bc08
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986829] Call Trace:
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986880] [<ffffffff816fb2ea>]
>> dump_stack+0x19/0x1b
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986933] [<ffffffffa00712d8>]
>> __bch_ptr_invalid+0x198/0x1b0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.986988] [<ffffffff81038078>] ?
>> native_smp_send_reschedule+0x48/0x60
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987050] [<ffffffff8108d986>] ?
>> resched_task+0x76/0x80
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987105] [<ffffffffa00712f0>] ?
>> __bch_ptr_invalid+0x1b0/0x1b0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987168] [<ffffffffa007130a>]
>> bch_ptr_invalid+0x1a/0x20 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987228] [<ffffffffa0072c63>]
>> btree_mergesort+0x83/0x1c0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987282] [<ffffffffa0072e1b>]
>> __btree_sort+0x7b/0x260 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987336] [<ffffffffa00733c7>]
>> bch_btree_sort_and_fix_extents+0x27/0x30 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987404] [<ffffffffa0069d39>]
>> bch_btree_read_done+0x409/0x4f0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987459] [<ffffffff81078710>]
>> process_one_work+0x170/0x4a0
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987511] [<ffffffff81079a11>]
>> worker_thread+0x121/0x390
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987563] [<ffffffff810798f0>] ?
>> manage_workers.isra.20+0x170/0x170
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987616] [<ffffffff810802c0>]
>> kthread+0xc0/0xd0
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987667] [<ffffffff81080200>] ?
>> flush_kthread_worker+0xb0/0xb0
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987721] [<ffffffff8170f9ac>]
>> ret_from_fork+0x7c/0xb0
>> Aug 23 06:44:12 nick-desktop kernel: [    1.987773] [<ffffffff81080200>] ?
>> flush_kthread_worker+0xb0/0xb0
>> Aug 23 06:44:12 nick-desktop kernel: [    1.991828] bcache: register_cache()
>> registered cache device sdb
>> Aug 23 06:44:12 nick-desktop kernel: [    1.992117] bcache: cache_set_free()
>> Cache set 07df2e18-1b29-4226-a937-4b3cda8a6bb3 unregistered
>> Aug 23 06:44:12 nick-desktop kernel: [    2.095031] usb 2-1.4.2: new
>> high-speed USB device number 4 using ehci-pci
>> Aug 23 06:44:12 nick-desktop kernel: [    2.111318] bio: create slab <bio-1>
>> at 1
>> Aug 23 06:44:12 nick-desktop kernel: [    2.111492] bcache: register_bdev()
>> registered backing device sdd
>> ...
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740439] bcache: error on
>> 07df2e18-1b29-4226-a937-4b3cda8a6bb3: spotted bad key 0:3178037263 len 65535
>> -> []: bad, no pointers, disabling caching
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740498] CPU: 0 PID: 74 Comm:
>> kworker/0:1 Tainted: PF          O 3.10.9-031009-generic #201308201935
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740499] Hardware name: System
>> manufacturer System Product Name/P9X79 LE, BIOS 4106 07/15/2013
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740510] Workqueue: events
>> bch_btree_read_done [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740512] ffff8808028a6020
>> ffff88080357bc48 ffffffff816fb2ea ffff88080357bcd8
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740514] ffffffffa00712d8
>> ffff8808034e2ee0 3330383731333a30 6e656c2033363237
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740516] 2d20353335353620
>> ffff88005d5b203e 0000000000000000 ffff88080357bc38
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740518] Call Trace:
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740522] [<ffffffff816fb2ea>]
>> dump_stack+0x19/0x1b
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740526] [<ffffffffa00712d8>]
>> __bch_ptr_invalid+0x198/0x1b0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740530] [<ffffffff814b0ccf>] ?
>> scsi_execute+0x11f/0x180
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740534] [<ffffffffa00712f0>] ?
>> __bch_ptr_invalid+0x1b0/0x1b0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740537] [<ffffffffa007130a>]
>> bch_ptr_invalid+0x1a/0x20 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740540] [<ffffffffa0072c63>]
>> btree_mergesort+0x83/0x1c0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740544] [<ffffffffa0072e1b>]
>> __btree_sort+0x7b/0x260 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740547] [<ffffffffa00733c7>]
>> bch_btree_sort_and_fix_extents+0x27/0x30 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740550] [<ffffffffa0069d39>]
>> bch_btree_read_done+0x409/0x4f0 [bcache]
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740553] [<ffffffff81078710>]
>> process_one_work+0x170/0x4a0
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740555] [<ffffffff81079a11>]
>> worker_thread+0x121/0x390
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740557] [<ffffffff810798f0>] ?
>> manage_workers.isra.20+0x170/0x170
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740559] [<ffffffff810802c0>]
>> kthread+0xc0/0xd0
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740561] [<ffffffff81080200>] ?
>> flush_kthread_worker+0xb0/0xb0
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740564] [<ffffffff8170f9ac>]
>> ret_from_fork+0x7c/0xb0
>> Aug 23 06:44:12 nick-desktop kernel: [   22.740565] [<ffffffff81080200>] ?
>> flush_kthread_worker+0xb0/0xb0
>> Aug 23 06:44:12 nick-desktop kernel: [   22.744286] bcache: register_cache()
>> registered cache device sdb
>> Aug 23 06:44:12 nick-desktop kernel: [   22.744362] bcache:
>> register_bcache() error opening /dev/sdd: device busy
>> Aug 23 06:44:12 nick-desktop kernel: [   22.744620] bcache: cache_set_free()
>> Cache set 07df2e18-1b29-4226-a937-4b3cda8a6bb3 unregistered
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Hello Nick,
>
> I am not a bcache expert, but have you tried to fsck the filesystem?:
>
> fsck.ext4 -cDfty -C 0 /dev/bcache0

Problem is that /dev/bcache0 isn't there...
