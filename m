From: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Subject: bcache hangs on writes, recovers after disabling discard on cache
 device
Date: Mon, 24 Jun 2013 20:36:57 +0200
Message-ID: <51C891C9.4060809@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hey all!

In a rather old thread of mine (514C4FC1.6090804-EqIAFqbRPK3NLxjTenLetw@public.gmane.org), I 
already stated a problem I was seeing back at the time, namely that 
bcache seems to hang on writes to the SSD device after some time, 
writing 50 MB/s continuously to the output device. Back at that time I 
thought that the problem was resolved by compiling the bcache module 
statically into the kernel, but it seems this was not the case. With a 
slightly different workload which I tested this afternoon (and which 
made me decide to write the email from earlier about "doubling" of the 
I/O bandwidth when discard is active), I managed to get the bcache 
device to hang again with the same symptoms: continuous write I/O of 50 
MB/s to the cache device without any I/O being accepted on the bcache1 
device.

Statistics I'm seeing:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00  100,00     0,00    50,00 
1024,00     1,00   10,00    0,00   10,00  10,00 100,00
md2               0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00
bcache1           0,00     0,00    0,00    0,00     0,00     0,00 
0,00     0,00    0,00    0,00    0,00   0,00   0,00

(where sda is the SSD-device in a cache set and md2 is the backing device).

While the bcache device is in this state, I'm seeing the following 
output in dmesg (this is from a kernel which has bcache compiled as a 
module, but I got the same output from the statically compiled bcache):

[23866.442387] INFO: task jbd2/bcache1-8:11826 blocked for more than 120 
seconds.
[23866.442453] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[23866.442518] jbd2/bcache1-8  D ffff88081fb14040     0 11826      2 
0x00000000
[23866.442523]  ffff8807feb6c800 0000000000000046 000112001b8a61c0 
ffff88081bf0e080
[23866.442528]  0000000000014040 ffff8804f9191fd8 ffff8804f9191fd8 
ffff8807feb6c800
[23866.442531]  0000000000011200 ffff8807fec08ad0 ffff8807feb6c800 
0000000000000000
[23866.442535] Call Trace:
[23866.442544]  [<ffffffff8139617a>] ? rwsem_down_read_failed+0xc8/0xde
[23866.442550]  [<ffffffff811ce814>] ? call_rwsem_down_read_failed+0x14/0x30
[23866.442553]  [<ffffffff81394ff3>] ? down_read+0x17/0x19
[23866.442565]  [<ffffffffa04c135b>] ? request_write+0x7e/0x2c8 [bcache]
[23866.442569]  [<ffffffff811ab87f>] ? generic_make_request+0x96/0xd5
[23866.442572]  [<ffffffff811ac48a>] ? submit_bio+0x10a/0x13b
[23866.442577]  [<ffffffff811301e4>] ? _submit_bh+0x1b9/0x1d7
[23866.442594]  [<ffffffffa015cc45>] ? 
jbd2_journal_commit_transaction+0x9a3/0x138e [jbd2]
[23866.442601]  [<ffffffff81048129>] ? lock_timer_base.isra.35+0x23/0x48
[23866.442605]  [<ffffffff813964db>] ? _raw_spin_lock_irqsave+0x14/0x35
[23866.442614]  [<ffffffffa01616b3>] ? kjournald2+0xb7/0x239 [jbd2]
[23866.442619]  [<ffffffff81058643>] ? abort_exclusive_wait+0x79/0x79
[23866.442627]  [<ffffffffa01615fc>] ? jbd2_superblock_csum+0x35/0x35 [jbd2]
[23866.442635]  [<ffffffffa01615fc>] ? jbd2_superblock_csum+0x35/0x35 [jbd2]
[23866.442638]  [<ffffffff81057ca9>] ? kthread+0x81/0x89
[23866.442641]  [<ffffffff81057c28>] ? __kthread_parkme+0x5d/0x5d
[23866.442645]  [<ffffffff8139b83c>] ? ret_from_fork+0x7c/0xb0
[23866.442648]  [<ffffffff81057c28>] ? __kthread_parkme+0x5d/0x5d
[23866.442653] INFO: task qemu-system-x86:13253 blocked for more than 
120 seconds.
[23866.442713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[23866.442777] qemu-system-x86 D ffff88081fa14040     0 13253      1 
0x00000000
[23866.442780]  ffff88040c317880 0000000000000082 0001120076ecd958 
ffffffff81613400
[23866.442784]  0000000000014040 ffff880176ecdfd8 ffff880176ecdfd8 
ffff88040c317880
[23866.442787]  0000000000011200 ffff8807fec08ad0 ffff88040c317880 
0000000000000000
[23866.442791] Call Trace:
[23866.442795]  [<ffffffff8139617a>] ? rwsem_down_read_failed+0xc8/0xde
[23866.442799]  [<ffffffff811ce814>] ? call_rwsem_down_read_failed+0x14/0x30
[23866.442802]  [<ffffffff81394ff3>] ? down_read+0x17/0x19
[23866.442809]  [<ffffffffa04c135b>] ? request_write+0x7e/0x2c8 [bcache]
[23866.442812]  [<ffffffff811ab87f>] ? generic_make_request+0x96/0xd5
[23866.442815]  [<ffffffff811ac48a>] ? submit_bio+0x10a/0x13b
[23866.442820]  [<ffffffff81135a87>] ? dio_new_bio.isra.10+0xc9/0x114
[23866.442833]  [<ffffffffa0175d6a>] ? _ext4_get_block+0x12f/0x149 [ext4]
[23866.442837]  [<ffffffff81135bc5>] ? dio_bio_submit+0x68/0x88
[23866.442841]  [<ffffffff81136971>] ? do_blockdev_direct_IO+0x957/0xae8
[23866.442846]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.442858]  [<ffffffffa0175d8e>] ? 
ext4_get_block_write_nolock+0xa/0xa [ext4]
[23866.442870]  [<ffffffffa017450a>] ? ext4_direct_IO+0x1d6/0x324 [ext4]
[23866.442880]  [<ffffffffa0175d8e>] ? 
ext4_get_block_write_nolock+0xa/0xa [ext4]
[23866.442890]  [<ffffffffa0172c20>] ? pagevec_release+0xb/0xb [ext4]
[23866.442894]  [<ffffffff810c312a>] ? generic_file_direct_write+0xe3/0x14a
[23866.442898]  [<ffffffff810c32ac>] ? __generic_file_aio_write+0x11b/0x1ff
[23866.442902]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.442912]  [<ffffffffa01706ae>] ? ext4_file_write+0x2b3/0x365 [ext4]
[23866.442917]  [<ffffffff8110d550>] ? __sb_start_write+0xb6/0xe8
[23866.442926]  [<ffffffffa01703fb>] ? ext4_unwritten_wait+0x98/0x98 [ext4]
[23866.442930]  [<ffffffff811413f7>] ? do_io_submit+0x384/0x5e4
[23866.442934]  [<ffffffff8139b8e9>] ? system_call_fastpath+0x16/0x1b
[23866.442938] INFO: task qemu-system-x86:13379 blocked for more than 
120 seconds.
[23866.442997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[23866.443068] qemu-system-x86 D ffff88081fa94040     0 13379      1 
0x00000000
[23866.443073]  ffff88056fcbd7c0 0000000000000082 ffff88049862ffd8 
ffff88081bf0c040
[23866.443087]  0000000000014040 ffff88049862ffd8 ffff88049862ffd8 
ffff88056fcbd7c0
[23866.443092]  ffffffff8139649c ffff88055990af28 ffff8803d6efa678 
ffff8805ef7f5280
[23866.443098] Call Trace:
[23866.443104]  [<ffffffff8139649c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
[23866.443117]  [<ffffffffa015b997>] ? do_get_write_access+0x219/0x402 
[jbd2]
[23866.443122]  [<ffffffff813964db>] ? _raw_spin_lock_irqsave+0x14/0x35
[23866.443127]  [<ffffffff81047fa1>] ? internal_add_timer+0xd/0x28
[23866.443131]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.443135]  [<ffffffff8105866d>] ? autoremove_wake_function+0x2a/0x2a
[23866.443148]  [<ffffffffa0178cd3>] ? ext4_dirty_inode+0x34/0x4f [ext4]
[23866.443155]  [<ffffffffa015bc74>] ? 
jbd2_journal_get_write_access+0x21/0x38 [jbd2]
[23866.443162]  [<ffffffffa015a667>] ? start_this_handle+0x453/0x46b [jbd2]
[23866.443166]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.443181]  [<ffffffffa01967a1>] ? 
__ext4_journal_get_write_access+0x58/0x69 [ext4]
[23866.443192]  [<ffffffffa0176691>] ? 
ext4_reserve_inode_write+0x37/0x7a [ext4]
[23866.443198]  [<ffffffff810fc59c>] ? kmem_cache_alloc+0x8d/0xff
[23866.443208]  [<ffffffffa0176737>] ? ext4_mark_inode_dirty+0x63/0x1f3 
[ext4]
[23866.443219]  [<ffffffffa0178cd3>] ? ext4_dirty_inode+0x34/0x4f [ext4]
[23866.443229]  [<ffffffffa0178c9f>] ? ext4_evict_inode+0x2aa/0x2aa [ext4]
[23866.443233]  [<ffffffff811299f1>] ? __mark_inode_dirty+0x56/0x1ef
[23866.443237]  [<ffffffff8111dc23>] ? update_time+0xa0/0xa9
[23866.443241]  [<ffffffff811194ca>] ? set_restore_sigmask+0x2d/0x2d
[23866.443245]  [<ffffffff8111e455>] ? file_update_time+0x95/0xb5
[23866.443248]  [<ffffffff810c326e>] ? __generic_file_aio_write+0xdd/0x1ff
[23866.443252]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.443262]  [<ffffffffa01706ae>] ? ext4_file_write+0x2b3/0x365 [ext4]
[23866.443266]  [<ffffffff8110d550>] ? __sb_start_write+0xb6/0xe8
[23866.443276]  [<ffffffffa01703fb>] ? ext4_unwritten_wait+0x98/0x98 [ext4]
[23866.443279]  [<ffffffff811413f7>] ? do_io_submit+0x384/0x5e4
[23866.443283]  [<ffffffff8139b8e9>] ? system_call_fastpath+0x16/0x1b
[23866.443287] INFO: task qemu-system-x86:13511 blocked for more than 
120 seconds.
[23866.443347] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[23866.443411] qemu-system-x86 D ffff88081fa94040     0 13511      1 
0x00000000
[23866.443414]  ffff8807e45f90c0 0000000000000082 000112007753f958 
ffff88081bf0c040
[23866.443417]  0000000000014040 ffff88017753ffd8 ffff88017753ffd8 
ffff8807e45f90c0
[23866.443420]  0000000000011200 ffff8807fec08ad0 ffff8807e45f90c0 
0000000000000000
[23866.443424] Call Trace:
[23866.443428]  [<ffffffff8139617a>] ? rwsem_down_read_failed+0xc8/0xde
[23866.443432]  [<ffffffff811ce814>] ? call_rwsem_down_read_failed+0x14/0x30
[23866.443435]  [<ffffffff81394ff3>] ? down_read+0x17/0x19
[23866.443442]  [<ffffffffa04c135b>] ? request_write+0x7e/0x2c8 [bcache]
[23866.443446]  [<ffffffff811ab87f>] ? generic_make_request+0x96/0xd5
[23866.443449]  [<ffffffff811ac48a>] ? submit_bio+0x10a/0x13b
[23866.443453]  [<ffffffff81135dbe>] ? dio_bio_add_page+0x36/0x4c
[23866.443457]  [<ffffffff81135e22>] ? dio_send_cur_page+0x4e/0xa8
[23866.443461]  [<ffffffff810cc08f>] ? put_page+0x18/0x27
[23866.443465]  [<ffffffff81135bc5>] ? dio_bio_submit+0x68/0x88
[23866.443469]  [<ffffffff81136971>] ? do_blockdev_direct_IO+0x957/0xae8
[23866.443472]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.443484]  [<ffffffffa0175d8e>] ? 
ext4_get_block_write_nolock+0xa/0xa [ext4]
[23866.443495]  [<ffffffffa017450a>] ? ext4_direct_IO+0x1d6/0x324 [ext4]
[23866.443505]  [<ffffffffa0175d8e>] ? 
ext4_get_block_write_nolock+0xa/0xa [ext4]
[23866.443515]  [<ffffffffa0172c20>] ? pagevec_release+0xb/0xb [ext4]
[23866.443518]  [<ffffffff810c312a>] ? generic_file_direct_write+0xe3/0x14a
[23866.443522]  [<ffffffff810c32ac>] ? __generic_file_aio_write+0x11b/0x1ff
[23866.443526]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.443535]  [<ffffffffa01706ae>] ? ext4_file_write+0x2b3/0x365 [ext4]
[23866.443539]  [<ffffffff8110d550>] ? __sb_start_write+0xb6/0xe8
[23866.443549]  [<ffffffffa01703fb>] ? ext4_unwritten_wait+0x98/0x98 [ext4]
[23866.443552]  [<ffffffff811413f7>] ? do_io_submit+0x384/0x5e4
[23866.443556]  [<ffffffff8139b8e9>] ? system_call_fastpath+0x16/0x1b
[23866.443561] INFO: task qemu-system-x86:17124 blocked for more than 
120 seconds.
[23866.443620] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[23866.443683] qemu-system-x86 D ffff88081fa94040     0 17124      1 
0x00000000
[23866.443686]  ffff88081b837780 0000000000000082 ffff8807fbf94440 
ffff88081bf0c040
[23866.443689]  0000000000014040 ffff8807fd3f5fd8 ffff8807fd3f5fd8 
ffff88081b837780
[23866.443692]  ffffffff810fbfe7 ffff8807fec08ad0 ffff88081b837780 
0000000000000000
[23866.443696] Call Trace:
[23866.443700]  [<ffffffff810fbfe7>] ? __kmalloc+0xde/0xf0
[23866.443703]  [<ffffffff8139617a>] ? rwsem_down_read_failed+0xc8/0xde
[23866.443707]  [<ffffffff811ce814>] ? call_rwsem_down_read_failed+0x14/0x30
[23866.443710]  [<ffffffff81394ff3>] ? down_read+0x17/0x19
[23866.443717]  [<ffffffffa04c135b>] ? request_write+0x7e/0x2c8 [bcache]
[23866.443720]  [<ffffffff811ab87f>] ? generic_make_request+0x96/0xd5
[23866.443723]  [<ffffffff811ac48a>] ? submit_bio+0x10a/0x13b
[23866.443727]  [<ffffffff81135dbe>] ? dio_bio_add_page+0x36/0x4c
[23866.443731]  [<ffffffff81135e22>] ? dio_send_cur_page+0x4e/0xa8
[23866.443734]  [<ffffffff810cc08f>] ? put_page+0x18/0x27
[23866.443738]  [<ffffffff81135bc5>] ? dio_bio_submit+0x68/0x88
[23866.443742]  [<ffffffff81136971>] ? do_blockdev_direct_IO+0x957/0xae8
[23866.443746]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.443757]  [<ffffffffa0175d8e>] ? 
ext4_get_block_write_nolock+0xa/0xa [ext4]
[23866.443767]  [<ffffffffa017450a>] ? ext4_direct_IO+0x1d6/0x324 [ext4]
[23866.443777]  [<ffffffffa0175d8e>] ? 
ext4_get_block_write_nolock+0xa/0xa [ext4]
[23866.443787]  [<ffffffffa0172c20>] ? pagevec_release+0xb/0xb [ext4]
[23866.443790]  [<ffffffff810c312a>] ? generic_file_direct_write+0xe3/0x14a
[23866.443794]  [<ffffffff810c32ac>] ? __generic_file_aio_write+0x11b/0x1ff
[23866.443797]  [<ffffffff81060245>] ? should_resched+0x5/0x23
[23866.443807]  [<ffffffffa01706ae>] ? ext4_file_write+0x2b3/0x365 [ext4]
[23866.443811]  [<ffffffff8110d550>] ? __sb_start_write+0xb6/0xe8
[23866.443821]  [<ffffffffa01703fb>] ? ext4_unwritten_wait+0x98/0x98 [ext4]
[23866.443824]  [<ffffffff811413f7>] ? do_io_submit+0x384/0x5e4
[23866.443827]  [<ffffffff8139b8e9>] ? system_call_fastpath+0x16/0x1b
[23866.443833] INFO: task kworker/7:1:23798 blocked for more than 120 
seconds.
[23866.443889] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[23866.443952] kworker/7:1     D ffff88081fbd4040     0 23798      2 
0x00000000
[23866.443961] Workqueue: events update_writeback_rate [bcache]
[23866.443962]  ffff8807fc485140 0000000000000046 ffff88081fbd4040 
ffff88081bf11840
[23866.443966]  0000000000014040 ffff880403119fd8 ffff880403119fd8 
ffff8807fc485140
[23866.443969]  0000000000014040 ffff8807fec08ad0 ffff8807fc485140 
0000000000000000
[23866.443972] Call Trace:
[23866.443976]  [<ffffffff8139617a>] ? rwsem_down_read_failed+0xc8/0xde
[23866.443980]  [<ffffffff811ce814>] ? call_rwsem_down_read_failed+0x14/0x30
[23866.443983]  [<ffffffff81394ff3>] ? down_read+0x17/0x19
[23866.443989]  [<ffffffffa04bdbc0>] ? update_writeback_rate+0x1a/0x187 
[bcache]
[23866.443994]  [<ffffffff81053300>] ? process_one_work+0x191/0x28f
[23866.443998]  [<ffffffff810537ad>] ? worker_thread+0x121/0x1e7
[23866.444001]  [<ffffffff8105368c>] ? rescuer_thread+0x269/0x269
[23866.444004]  [<ffffffff81057ca9>] ? kthread+0x81/0x89
[23866.444007]  [<ffffffff81057c28>] ? __kthread_parkme+0x5d/0x5d
[23866.444010]  [<ffffffff8139b83c>] ? ret_from_fork+0x7c/0xb0
[23866.444013]  [<ffffffff81057c28>] ? __kthread_parkme+0x5d/0x5d
[23866.444018] INFO: task kworker/u16:3:24718 blocked for more than 120 
seconds.
[23866.444076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[23866.444139] kworker/u16:3   D ffff88081fa54040     0 24718      2 
0x00000000
[23866.444147] Workqueue: bcache_writeback read_dirty [bcache]
[23866.444148]  ffff8807fbc4e140 0000000000000046 ffff8807fec08010 
ffff8807e4994040
[23866.444151]  0000000000014040 ffff88050282bfd8 ffff88050282bfd8 
ffff8807fbc4e140
[23866.444155]  0000000000000003 ffff8807fec08ad0 ffff8807fbc4e140 
ffffffff00000001
[23866.444158] Call Trace:
[23866.444162]  [<ffffffff8139629c>] ? rwsem_down_write_failed+0x10c/0x18e
[23866.444165]  [<ffffffff81396465>] ? _raw_spin_lock_irq+0xb/0x15
[23866.444169]  [<ffffffff811ce843>] ? 
call_rwsem_down_write_failed+0x13/0x20
[23866.444172]  [<ffffffff81395019>] ? down_write+0x24/0x26
[23866.444178]  [<ffffffffa04be1f3>] ? refill_dirty+0x5d/0x1f2 [bcache]
[23866.444185]  [<ffffffffa04be6a5>] ? read_dirty+0x31d/0x369 [bcache]
[23866.444189]  [<ffffffff8100c02f>] ? load_TLS+0x7/0xa
[23866.444193]  [<ffffffff81053300>] ? process_one_work+0x191/0x28f
[23866.444197]  [<ffffffff810537ad>] ? worker_thread+0x121/0x1e7
[23866.444200]  [<ffffffff8105368c>] ? rescuer_thread+0x269/0x269
[23866.444203]  [<ffffffff81057ca9>] ? kthread+0x81/0x89
[23866.444207]  [<ffffffff81057c28>] ? __kthread_parkme+0x5d/0x5d
[23866.444209]  [<ffffffff8139b83c>] ? ret_from_fork+0x7c/0xb0
[23866.444213]  [<ffffffff81057c28>] ? __kthread_parkme+0x5d/0x5d

Disabling discard on the SSD device (by echo 0 > 
/sys/fs/bcache/.../cache0/discard) makes the bcache device become 
responsive again.

Possibly these hints help at diagnosing the problem at hand; if there's 
any more request for information, feel free to mail me. I'll keep 
pounding on the server now that discard is off and try to reproduce the 
problem, but from what I can see now, on the machine that I originally 
thought had the problem fixed by statically compiling bcache, discards 
are and have always been off for the SSD device. So most probably, that 
was also the cause for that "miracle" cure.

Thanks for your time.

-- 
--- Heiko.
