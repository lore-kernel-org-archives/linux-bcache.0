From: Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Subject: Re: New version up with fix for md and other block devices
Date: Tue, 29 Nov 2011 16:30:22 +0800
Message-ID: <4ED4981E.6040501@fnarfbargle.com>
References: <20111121101402.GA17787@dhcp-172-18-216-138.mtv.corp.google.com> <4ED47771.9030309@fnarfbargle.com> <20111129063126.GA14194@dhcp-172-18-216-138.mtv.corp.google.com> <4ED48A64.4080406@fnarfbargle.com> <20111129075440.GB14194@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111129075440.GB14194-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On 29/11/11 15:54, Kent Overstreet wrote:
> On Tue, Nov 29, 2011 at 03:31:48PM +0800, Brad Campbell wrote:
>> I'm not sure that stacking is the issue. I simply did
>>
>> echo /dev/md10>  /sys/fs/bcache/register
>> echo /dev/md10>  /sys/fs/bcache/register
>>
>> at that point it all came crashing down. I'd have thought simply
>> detecting that a particular device was already registered would
>> solve the problem.
>
> Ok, that's weird. It shouldn't be able to register the second time
> because the first register opens it exclusively, and the second open
> will fail with -EBUSY.

Can reproduce it at will here.

Just to prove it wasn't a fluke and is not related to md10 :

[ 7991.108197] ------------[ cut here ]------------
[ 7991.108238] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb9/0xf0()
[ 7991.108256] Hardware name: To Be Filled By O.E.M.
[ 7991.108272] sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:03.0/0000:03:00.0/host5/target5:0:13/5:0:13:0/block/sde/bcache'
[ 7991.108299] Modules linked in: xt_state ipt_REJECT xt_CHECKSUM 
iptable_mangle nfs ipt_MASQUERADE xt_tcpudp iptable_filter iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables 
deflate zlib_deflate des_generic cbc ecb crypto_blkcipher sha1_generic 
md5 hmac crypto_hash cryptomgr aead crypto_algapi af_key fuse w83627ehf 
hwmon_vid netconsole configfs vhost_net powernow_k8 mperf kvm_amd kvm 
xhci_hcd k10temp i2c_piix4 ohci_hcd ehci_hcd usbcore ahci libahci atl1c 
megaraid_sas [last unloaded: scsi_wait_scan]
[ 7991.108667] Pid: 16579, comm: bash Not tainted 3.1.0-g143cdea #1
[ 7991.108684] Call Trace:
[ 7991.108705]  [<ffffffff81034eeb>] ? warn_slowpath_common+0x7b/0xc0
[ 7991.108726]  [<ffffffff81034fe5>] ? warn_slowpath_fmt+0x45/0x50
[ 7991.108747]  [<ffffffff811210c9>] ? sysfs_add_one+0xb9/0xf0
[ 7991.108767]  [<ffffffff81121b69>] ? create_dir+0x79/0xe0
[ 7991.108788]  [<ffffffff81121c42>] ? sysfs_create_dir+0x72/0xb0
[ 7991.108807]  [<ffffffff811dc18f>] ? kobject_add_internal+0xaf/0x1e0
[ 7991.108826]  [<ffffffff811dc4c6>] ? kobject_add+0x46/0x70
[ 7991.108847]  [<ffffffff810995b0>] ? bdi_init+0x170/0x1c0
[ 7991.108864]  [<ffffffff811dbd3d>] ? kobject_init+0x2d/0xb0
[ 7991.108885]  [<ffffffff812a435d>] ? register_bcache+0x72d/0xac0
[ 7991.108908]  [<ffffffff81120222>] ? sysfs_write_file+0xd2/0x160
[ 7991.108928]  [<ffffffff810c7348>] ? vfs_write+0xc8/0x190
[ 7991.108946]  [<ffffffff810c750e>] ? sys_write+0x4e/0x90
[ 7991.108966]  [<ffffffff8140a87b>] ? system_call_fastpath+0x16/0x1b
[ 7991.108984] ---[ end trace 88a7af6bca09c44d ]---
[ 7991.109002] kobject_add_internal failed for bcache with -EEXIST, 
don't try to register things with the same name in the same directory.
[ 7991.109030] Pid: 16579, comm: bash Tainted: G        W 
3.1.0-g143cdea #1
[ 7991.109048] Call Trace:
[ 7991.109064]  [<ffffffff811dc22a>] ? kobject_add_internal+0x14a/0x1e0
[ 7991.109083]  [<ffffffff811dc4c6>] ? kobject_add+0x46/0x70
[ 7991.109103]  [<ffffffff810995b0>] ? bdi_init+0x170/0x1c0
[ 7991.109122]  [<ffffffff811dbd3d>] ? kobject_init+0x2d/0xb0
[ 7991.109142]  [<ffffffff812a435d>] ? register_bcache+0x72d/0xac0
[ 7991.109163]  [<ffffffff81120222>] ? sysfs_write_file+0xd2/0x160
[ 7991.109182]  [<ffffffff810c7348>] ? vfs_write+0xc8/0x190
[ 7991.109201]  [<ffffffff810c750e>] ? sys_write+0x4e/0x90
[ 7991.109220]  [<ffffffff8140a87b>] ? system_call_fastpath+0x16/0x1b
[ 7991.109259] bcache: Device sde unregistered


>> Well, I had intended to run some tests with it stacked on top of md,
>> but as I pointed out in the last oops in my prior mail, every time I
>> try and attach the cache set to /dev/md10 the machine panics, so
>> I've not really progressed to actually trying things out. I figured
>> re-running the tests I'd already run with it stacked on a single
>> drive was pretty pointless.
>
> Bah, I suck at reading comprehension tonight, didn't see the second
> oops.
>
> That one looks strange, I haven't seen an oops there before. Which raid
> type are you using, and which driver? Hopefully it's related to the raid
> type and not the driver...


I doubt its the driver as the RAID is on the same card as the single 
drive I tested with last time.

brad@test:~$ sudo mdadm --detail /dev/md10
/dev/md10:
         Version : 1.2
   Creation Time : Sat Oct 15 11:16:29 2011
      Raid Level : raid10
      Array Size : 490231808 (467.52 GiB 502.00 GB)
   Used Dev Size : 245115904 (233.76 GiB 251.00 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Nov 29 14:08:52 2011
           State : active, resyncing
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : far=2
      Chunk Size : 512K

  Rebuild Status : 0% complete

            Name : test:10  (local to host test)
            UUID : 3c5cbbdb:c1ea4d76:8ddc8037:973dbdc5
          Events : 54

     Number   Major   Minor   RaidDevice State
        0       8       16        0      active sync   /dev/sdb
        1       8       48        1      active sync   /dev/sdd
        2       8       32        2      active sync   /dev/sdc
        3       8        0        3      active sync   /dev/sda



Driver is

[    4.413958] megasas: 00.00.05.40-rc1 Tue. Jul. 26 17:00:00 PDT 2011
[    4.414015] megasas: 0x1000:0x0073:0x1014:0x03b1: bus 2:slot 0:func 0
[    4.414082] megaraid_sas 0000:02:00.0: PCI INT A -> GSI 18 (level, 
low) -> IRQ 18

Standard LSI megaraid SAS card.

I can probably try some other RAID levels this evening if it would help. 
I trashed the RAID recently anyway so I need to re-build it from scratch.
