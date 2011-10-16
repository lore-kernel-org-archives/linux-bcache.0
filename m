From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Bcache explodes when trying to attach
Date: Sat, 15 Oct 2011 22:08:09 -0700
Message-ID: <CAC7rs0sm5BgEawAZYjJjnrqAgyK+D96vmpn=1NEQuTJGk+BgAg@mail.gmail.com>
References: <4E991D90.1040008@fnarfbargle.com>
	<4E9983B1.9060803@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E9983B1.9060803-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brad Campbell <lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Doh, I just keep breaking stuff.

There are unfortunately known issues with running on top of dm/md -
they are high on my list but I've had a lot on my plate lately =3D/

Worst part of the md/dm issues are that passthrough mode is affected.
Apologies for having to find out the hard way.

Thanks for the heads up about the cgroup issue. I'm gonna post a new
version on lkml just as soon as I have time to finish the md/dm stuff
and thoroughly test it myself.

On Sat, Oct 15, 2011 at 5:59 AM, Brad Campbell
<lists2009-+nnirC7rrGZibQn6LdNjmg@public.gmane.org> wrote:
> On 15/10/11 13:43, Brad Campbell wrote:
>>
>> I'm trying bcache merged with linus' git head (-rc9). I suppose I sh=
ould
>> really try it with a vanilla bcache-dev tree.
>>
>> Anyway, I can register the cache and backing device but when I try a=
nd
>> attach the cache set to the backing device this happens :
>
> Ok, so the build was broken in some odd way. Turns out the latest git=
 does
> not build unless you have cgroups enabled (which by default I don't).
>
> This came from the same scenario using a vanilla bcache git clone..
>
> [ =A0162.412296] bio: create slab <bio-2> at 2
> [ =A0162.441711] bcache: journal entries 3-4 missing! (replaying 2-4)
> [ =A0162.441805] bcache: journal replay done, 0 keys in 2 entries, se=
q 2-4
> [ =A0181.955480] md: resync of RAID array md10
> [ =A0181.955526] ------------[ cut here ]------------
> [ =A0181.955533] kernel BUG at drivers/scsi/scsi_lib.c:1152!
> [ =A0181.955539] invalid opcode: 0000 [#1] SMP
> [ =A0181.955546] CPU 1
> [ =A0181.955549] Modules linked in: nfs ipt_MASQUERADE xt_tcpudp
> iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> nf_defrag_ipv4 ip_tables x_tables deflate zlib_deflate des_generic cb=
c ecb
> crypto_blkcipher sha1_generic md5 hmac crypto_hash cryptomgr aead
> crypto_algapi af_key fuse w83627ehf hwmon_vid netconsole configfs vho=
st_net
> powernow_k8 mperf kvm_amd kvm xhci_hcd i2c_piix4 k10temp ohci_hcd ehc=
i_hcd
> usbcore ahci libahci atl1c megaraid_sas [last unloaded: scsi_wait_sca=
n]
> [ =A0181.955600]
> [ =A0181.955606] Pid: 1422, comm: md10_raid10 Not tainted
> 3.1.0-rc9-00152-g3900b5a-dirty #6 To Be Filled By O.E.M. To Be Filled=
 By
> O.E.M./890GX Extreme4 R2.0
> [ =A0181.955616] RIP: 0010:[<ffffffff812ad4ee>] =A0[<ffffffff812ad4ee=
>]
> scsi_setup_fs_cmnd+0xae/0xf0
> [ =A0181.955631] RSP: 0018:ffff88041bfdbbe0 =A0EFLAGS: 00010046
> [ =A0181.955636] RAX: 0000000000000000 RBX: ffff88041c4d3830 RCX:
> 0000000000001000
> [ =A0181.955641] RDX: 0000000000000000 RSI: ffff88041c4d3830 RDI:
> ffff88041c754800
> [ =A0181.955645] RBP: ffff88041c754800 R08: 0000000000000000 R09:
> 0000000000000001
> [ =A0181.955650] R10: 4080000000000000 R11: 0000000000000000 R12:
> ffff88041c754800
> [ =A0181.955654] R13: 0000000000000808 R14: ffff88041c754848 R15:
> ffff88041c3cbc00
> [ =A0181.955661] FS: =A000007fc823617700(0000) GS:ffff88042fc40000(00=
00)
> knlGS:0000000000000000
> [ =A0181.955668] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ =A0181.955672] CR2: ffffffffff600400 CR3: 00000003ffe02000 CR4:
> 00000000000006e0
> [ =A0181.955677] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ =A0181.955681] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [ =A0181.955687] Process md10_raid10 (pid: 1422, threadinfo ffff88041=
bfda000,
> task ffff88041c1bcb00)
> [ =A0181.955691] Stack:
> [ =A0181.955693] =A00000000000000000 ffff88041c4d3830 ffff88041bd83c3=
0
> ffffffff812b7fec
> [ =A0181.955701] =A001ff88041c755000 ffff880400000001 ffff88040000100=
0
> 0000000000000000
> [ =A0181.955707] =A0ffff88041c4d3830 ffff88041c4d3830 ffff88041c4d383=
0
> ffff88041bd83c30
> [ =A0181.955714] Call Trace:
> [ =A0181.955723] =A0[<ffffffff812b7fec>] ? sd_prep_fn+0x15c/0xa50
> [ =A0181.955732] =A0[<ffffffff811c8c04>] ? blk_peek_request+0xb4/0x1d=
0
> [ =A0181.955739] =A0[<ffffffff812aca10>] ? scsi_request_fn+0x50/0x4a0
> [ =A0181.955747] =A0[<ffffffff811c95b8>] ? blk_flush_plug_list+0x188/=
0x210
> [ =A0181.955755] =A0[<ffffffff811c964b>] ? blk_finish_plug+0xb/0x30
> [ =A0181.955762] =A0[<ffffffff812fa768>] ? raid10d+0x908/0xb50
> [ =A0181.955770] =A0[<ffffffff81041183>] ? lock_timer_base+0x33/0x70
> [ =A0181.955779] =A0[<ffffffff814082b5>] ? schedule_timeout+0x1c5/0x2=
30
> [ =A0181.955786] =A0[<ffffffff8130e57f>] ? md_thread+0x10f/0x140
> [ =A0181.955795] =A0[<ffffffff81050260>] ? wake_up_bit+0x40/0x40
> [ =A0181.955801] =A0[<ffffffff8130e470>] ? md_register_thread+0x100/0=
x100
> [ =A0181.955807] =A0[<ffffffff8130e470>] ? md_register_thread+0x100/0=
x100
> [ =A0181.955814] =A0[<ffffffff8104fe06>] ? kthread+0x96/0xa0
> [ =A0181.955821] =A0[<ffffffff8140b4f4>] ? kernel_thread_helper+0x4/0=
x10
> [ =A0181.955829] =A0[<ffffffff8104fd70>] ? kthread_worker_fn+0x120/0x=
120
> [ =A0181.955836] =A0[<ffffffff8140b4f0>] ? gs_change+0xb/0xb
> [ =A0181.955839] Code: 80 00 00 00 00 48 83 c4 08 5b 5d c3 90 48 89 e=
f be 20
> 00 00 00 e8 73 a2 ff ff 48 85 c0 48 89 c7 74 d7 48 89 83 d8 00 00 00 =
eb 8d
> <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 48 8b 40 50 48
> [ =A0181.955879] RIP =A0[<ffffffff812ad4ee>] scsi_setup_fs_cmnd+0xae/=
0xf0
> [ =A0181.955887] =A0RSP <ffff88041bfdbbe0>
> [ =A0181.955892] ---[ end trace 56499f30ff553488 ]---
> [ =A0181.955896] Kernel panic - not syncing: Fatal exception
> [ =A0181.955902] Pid: 1422, comm: md10_raid10 Tainted: G =A0 =A0 =A0D
> 3.1.0-rc9-00152-g3900b5a-dirty #6
> [ =A0181.955906] Call Trace:
> [ =A0181.955913] =A0[<ffffffff81406f69>] ? panic+0x92/0x193
> [ =A0181.955920] =A0[<ffffffff81035451>] ? kmsg_dump+0x41/0xf0
> [ =A0181.955929] =A0[<ffffffff8100504d>] ? oops_end+0x8d/0xa0
> [ =A0181.955936] =A0[<ffffffff81002e34>] ? do_invalid_op+0x84/0xa0
> [ =A0181.955943] =A0[<ffffffff812ad4ee>] ? scsi_setup_fs_cmnd+0xae/0x=
f0
> [ =A0181.955952] =A0[<ffffffff811d69ae>] ? cfq_set_request+0x15e/0x3b=
0
> [ =A0181.955958] =A0[<ffffffff8140b375>] ? invalid_op+0x15/0x20
> [ =A0181.955966] =A0[<ffffffff812ad4ee>] ? scsi_setup_fs_cmnd+0xae/0x=
f0
> [ =A0181.955972] =A0[<ffffffff812b7fec>] ? sd_prep_fn+0x15c/0xa50
> [ =A0181.955979] =A0[<ffffffff811c8c04>] ? blk_peek_request+0xb4/0x1d=
0
> [ =A0181.955986] =A0[<ffffffff812aca10>] ? scsi_request_fn+0x50/0x4a0
> [ =A0181.955993] =A0[<ffffffff811c95b8>] ? blk_flush_plug_list+0x188/=
0x210
> [ =A0181.956001] =A0[<ffffffff811c964b>] ? blk_finish_plug+0xb/0x30
> [ =A0181.956007] =A0[<ffffffff812fa768>] ? raid10d+0x908/0xb50
> [ =A0181.956013] =A0[<ffffffff81041183>] ? lock_timer_base+0x33/0x70
> [ =A0181.956021] =A0[<ffffffff814082b5>] ? schedule_timeout+0x1c5/0x2=
30
> [ =A0181.956028] =A0[<ffffffff8130e57f>] ? md_thread+0x10f/0x140
> [ =A0181.956035] =A0[<ffffffff81050260>] ? wake_up_bit+0x40/0x40
> [ =A0181.956041] =A0[<ffffffff8130e470>] ? md_register_thread+0x100/0=
x100
> [ =A0181.956047] =A0[<ffffffff8130e470>] ? md_register_thread+0x100/0=
x100
> [ =A0181.956054] =A0[<ffffffff8104fe06>] ? kthread+0x96/0xa0
> [ =A0181.956060] =A0[<ffffffff8140b4f4>] ? kernel_thread_helper+0x4/0=
x10
> [ =A0181.956068] =A0[<ffffffff8104fd70>] ? kthread_worker_fn+0x120/0x=
120
> [ =A0181.956075] =A0[<ffffffff8140b4f0>] ? gs_change+0xb/0xb
> [ =A0181.958475] Rebooting in 10 seconds..
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
