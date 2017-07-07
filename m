From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: lock, Workqueue: bcache bch_data_insert_keys [bcache]
Date: Fri, 7 Jul 2017 17:16:03 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707071710550.17052@mail.ewheeler.net>
References: <4e51563b-bb3d-efcc-0f84-76572c87c352@k0ste.ru>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1652761076-1499447763=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:49232 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750726AbdGGRQF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jul 2017 13:16:05 -0400
In-Reply-To: <4e51563b-bb3d-efcc-0f84-76572c87c352@k0ste.ru>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Konstantin Shalygin <k0ste@k0ste.ru>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1652761076-1499447763=:17052
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Jul 2017, Konstantin Shalygin wrote:

> Hello. I caught lock (only hard reset helped to reboot kernel), when I started
> "every week rsync backup" of my laptop '/home'. After reboot I started the
> same task and this don't get any issues.

Hi Konstantin,

Try this patch:

https://www.spinics.net/lists/stable/msg178933.html



--
Eric Wheeler



> 
> I run bcache over md raid5.
> 
> [k0ste@home ~]$ lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
> sda           8:0    0   5.5T  0 disk
> └─md0         9:0    0    15T  0 raid5
>   └─bcache0 254:0    0    15T  0 disk  /srv/raid
> sdb           8:16   0   5.5T  0 disk
> └─md0         9:0    0    15T  0 raid5
>   └─bcache0 254:0    0    15T  0 disk  /srv/raid
> sdc           8:32   0   5.5T  0 disk
> └─md0         9:0    0    15T  0 raid5
>   └─bcache0 254:0    0    15T  0 disk  /srv/raid
> sdd           8:48   1  14.3G  0 disk
> └─sdd1        8:49   1  14.3G  0 part  /boot
> sde           8:64   0   5.5T  0 disk
> └─md0         9:0    0    15T  0 raid5
>   └─bcache0 254:0    0    15T  0 disk  /srv/raid
> sdf           8:80   0 119.2G  0 disk
> └─sdf1        8:81   0 119.2G  0 part  /
> nvme0n1     259:0    0 119.2G  0 disk
> └─bcache0   254:0    0    15T  0 disk  /srv/raid
> 
> dmesg:
> 
> 
> > Jul 07 19:59:59 home kernel: INFO: task bcache:86 blocked for more than 120
> > seconds.
> > Jul 07 19:59:59 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 19:59:59 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 19:59:59 home kernel: bcache          D    0    86      2 0x00000000
> > Jul 07 19:59:59 home kernel: Workqueue: bcache bch_data_insert_keys [bcache]
> > Jul 07 19:59:59 home kernel: Call Trace:
> > Jul 07 19:59:59 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 19:59:59 home kernel:  schedule+0x3d/0x90
> > Jul 07 19:59:59 home kernel:  closure_sync+0x23/0x90 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_journal+0x115/0x3a0 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_data_insert_keys+0x95/0x130 [bcache]
> > Jul 07 19:59:59 home kernel:  process_one_work+0x1e0/0x490
> > Jul 07 19:59:59 home kernel:  rescuer_thread+0x20c/0x390
> > Jul 07 19:59:59 home kernel:  kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? cancel_delayed_work_sync+0x20/0x20
> > Jul 07 19:59:59 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 19:59:59 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 19:59:59 home kernel: INFO: task xfsaild/bcache0:5174 blocked for
> > more than 120 seconds.
> > Jul 07 19:59:59 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 19:59:59 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 19:59:59 home kernel: xfsaild/bcache0 D    0  5174      2 0x00000000
> > Jul 07 19:59:59 home kernel: Call Trace:
> > Jul 07 19:59:59 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 19:59:59 home kernel:  schedule+0x3d/0x90
> > Jul 07 19:59:59 home kernel:  schedule_timeout+0x224/0x3c0
> > Jul 07 19:59:59 home kernel:  ? check_preempt_curr+0x27/0x80
> > Jul 07 19:59:59 home kernel:  ? ttwu_do_wakeup.isra.16+0x1e/0x170
> > Jul 07 19:59:59 home kernel:  wait_for_common+0xb9/0x180
> > Jul 07 19:59:59 home kernel:  ? wait_for_common+0xb9/0x180
> > Jul 07 19:59:59 home kernel:  ? wake_up_q+0x80/0x80
> > Jul 07 19:59:59 home kernel:  wait_for_completion+0x1d/0x20
> > Jul 07 19:59:59 home kernel:  flush_work+0x13b/0x1c0
> > Jul 07 19:59:59 home kernel:  ? flush_workqueue_prep_pwqs+0x190/0x190
> > Jul 07 19:59:59 home kernel:  xlog_cil_force_lsn+0x7c/0x200 [xfs]
> > Jul 07 19:59:59 home kernel:  ? try_to_del_timer_sync+0x53/0x80
> > Jul 07 19:59:59 home kernel:  _xfs_log_force+0x85/0x290 [xfs]
> > Jul 07 19:59:59 home kernel:  ? del_timer_sync+0x50/0x50
> > Jul 07 19:59:59 home kernel:  ? xfsaild+0x16a/0x7c0 [xfs]
> > Jul 07 19:59:59 home kernel:  xfs_log_force+0x2c/0x90 [xfs]
> > Jul 07 19:59:59 home kernel:  xfsaild+0x16a/0x7c0 [xfs]
> > Jul 07 19:59:59 home kernel:  kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> > Jul 07 19:59:59 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 19:59:59 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 19:59:59 home kernel: INFO: task kworker/0:1:84671 blocked for more
> > than 120 seconds.
> > Jul 07 19:59:59 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 19:59:59 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 19:59:59 home kernel: kworker/0:1     D    0 84671      2 0x00000000
> > Jul 07 19:59:59 home kernel: Workqueue: bcache bch_data_insert_keys [bcache]
> > Jul 07 19:59:59 home kernel: Call Trace:
> > Jul 07 19:59:59 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 19:59:59 home kernel:  schedule+0x3d/0x90
> > Jul 07 19:59:59 home kernel:  closure_sync+0x23/0x90 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_journal+0x115/0x3a0 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_data_insert_keys+0x95/0x130 [bcache]
> > Jul 07 19:59:59 home kernel:  process_one_work+0x1e0/0x490
> > Jul 07 19:59:59 home kernel:  worker_thread+0x48/0x4e0
> > Jul 07 19:59:59 home kernel:  kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? process_one_work+0x490/0x490
> > Jul 07 19:59:59 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 19:59:59 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 19:59:59 home kernel: INFO: task kworker/0:3:84673 blocked for more
> > than 120 seconds.
> > Jul 07 19:59:59 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 19:59:59 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 19:59:59 home kernel: kworker/0:3     D    0 84673      2 0x00000000
> > Jul 07 19:59:59 home kernel: Workqueue: bcache bch_data_insert_keys [bcache]
> > Jul 07 19:59:59 home kernel: Call Trace:
> > Jul 07 19:59:59 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 19:59:59 home kernel:  schedule+0x3d/0x90
> > Jul 07 19:59:59 home kernel:  closure_sync+0x23/0x90 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_journal+0x115/0x3a0 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_data_insert_keys+0x95/0x130 [bcache]
> > Jul 07 19:59:59 home kernel:  process_one_work+0x1e0/0x490
> > Jul 07 19:59:59 home kernel:  worker_thread+0x48/0x4e0
> > Jul 07 19:59:59 home kernel:  kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? process_one_work+0x490/0x490
> > Jul 07 19:59:59 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 19:59:59 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 19:59:59 home kernel: INFO: task kworker/2:2:87164 blocked for more
> > than 120 seconds.
> > Jul 07 19:59:59 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 19:59:59 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 19:59:59 home kernel: kworker/2:2     D    0 87164      2 0x00000000
> > Jul 07 19:59:59 home kernel: Workqueue: xfs-sync/bcache0 xfs_log_worker
> > [xfs]
> > Jul 07 19:59:59 home kernel: Call Trace:
> > Jul 07 19:59:59 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 19:59:59 home kernel:  ? find_next_bit+0xb/0x10
> > Jul 07 19:59:59 home kernel:  schedule+0x3d/0x90
> > Jul 07 19:59:59 home kernel:  schedule_timeout+0x224/0x3c0
> > Jul 07 19:59:59 home kernel:  wait_for_common+0xb9/0x180
> > Jul 07 19:59:59 home kernel:  ? wait_for_common+0xb9/0x180
> > Jul 07 19:59:59 home kernel:  ? wake_up_q+0x80/0x80
> > Jul 07 19:59:59 home kernel:  wait_for_completion+0x1d/0x20
> > Jul 07 19:59:59 home kernel:  flush_work+0x13b/0x1c0
> > Jul 07 19:59:59 home kernel:  ? flush_workqueue_prep_pwqs+0x190/0x190
> > Jul 07 19:59:59 home kernel:  xlog_cil_force_lsn+0x7c/0x200 [xfs]
> > Jul 07 19:59:59 home kernel:  ? find_next_bit+0xb/0x10
> > Jul 07 19:59:59 home kernel:  _xfs_log_force+0x85/0x290 [xfs]
> > Jul 07 19:59:59 home kernel:  ? __switch_to+0x270/0x490
> > Jul 07 19:59:59 home kernel:  ? xfs_log_worker+0x34/0x100 [xfs]
> > Jul 07 19:59:59 home kernel:  xfs_log_force+0x2c/0x90 [xfs]
> > Jul 07 19:59:59 home kernel:  xfs_log_worker+0x34/0x100 [xfs]
> > Jul 07 19:59:59 home kernel:  process_one_work+0x1e0/0x490
> > Jul 07 19:59:59 home kernel:  worker_thread+0x48/0x4e0
> > Jul 07 19:59:59 home kernel:  kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? process_one_work+0x490/0x490
> > Jul 07 19:59:59 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 19:59:59 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 19:59:59 home kernel: INFO: task kworker/1:28:89441 blocked for more
> > than 120 seconds.
> > Jul 07 19:59:59 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 19:59:59 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 19:59:59 home kernel: kworker/1:28    D    0 89441      2 0x00000000
> > Jul 07 19:59:59 home kernel: Workqueue: xfs-cil/bcache0 xlog_cil_push_work
> > [xfs]
> > Jul 07 19:59:59 home kernel: Call Trace:
> > Jul 07 19:59:59 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 19:59:59 home kernel:  schedule+0x3d/0x90
> > Jul 07 19:59:59 home kernel: xlog_state_get_iclog_space+0xf8/0x2d0 [xfs]
> > Jul 07 19:59:59 home kernel:  ? wake_up_q+0x80/0x80
> > Jul 07 19:59:59 home kernel:  xlog_write+0x166/0x640 [xfs]
> > Jul 07 19:59:59 home kernel:  xlog_cil_push+0x2a1/0x490 [xfs]
> > Jul 07 19:59:59 home kernel:  ? put_prev_entity+0x40/0xc10
> > Jul 07 19:59:59 home kernel:  ? __switch_to+0x270/0x490
> > Jul 07 19:59:59 home kernel:  xlog_cil_push_work+0x15/0x20 [xfs]
> > Jul 07 19:59:59 home kernel:  process_one_work+0x1e0/0x490
> > Jul 07 19:59:59 home kernel:  worker_thread+0x225/0x4e0
> > Jul 07 19:59:59 home kernel:  kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? process_one_work+0x490/0x490
> > Jul 07 19:59:59 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 19:59:59 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 19:59:59 home kernel: INFO: task kworker/0:0:92924 blocked for more
> > than 120 seconds.
> > Jul 07 19:59:59 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 19:59:59 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 19:59:59 home kernel: kworker/0:0     D    0 92924      2 0x00000000
> > Jul 07 19:59:59 home kernel: Workqueue: bcache bch_data_insert_keys [bcache]
> > Jul 07 19:59:59 home kernel: Call Trace:
> > Jul 07 19:59:59 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 19:59:59 home kernel:  schedule+0x3d/0x90
> > Jul 07 19:59:59 home kernel:  closure_sync+0x23/0x90 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_journal+0x115/0x3a0 [bcache]
> > Jul 07 19:59:59 home kernel:  bch_data_insert_keys+0x95/0x130 [bcache]
> > Jul 07 19:59:59 home kernel:  process_one_work+0x1e0/0x490
> > Jul 07 19:59:59 home kernel:  worker_thread+0x48/0x4e0
> > Jul 07 19:59:59 home kernel:  kthread+0x125/0x140
> > Jul 07 19:59:59 home kernel:  ? process_one_work+0x490/0x490
> > Jul 07 19:59:59 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 19:59:59 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 20:02:02 home kernel: INFO: task bcache:86 blocked for more than 120
> > seconds.
> > Jul 07 20:02:02 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 20:02:02 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 20:02:02 home kernel: bcache          D    0    86      2 0x00000000
> > Jul 07 20:02:02 home kernel: Workqueue: bcache bch_data_insert_keys [bcache]
> > Jul 07 20:02:02 home kernel: Call Trace:
> > Jul 07 20:02:02 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 20:02:02 home kernel:  schedule+0x3d/0x90
> > Jul 07 20:02:02 home kernel:  closure_sync+0x23/0x90 [bcache]
> > Jul 07 20:02:02 home kernel:  bch_journal+0x115/0x3a0 [bcache]
> > Jul 07 20:02:02 home kernel:  bch_data_insert_keys+0x95/0x130 [bcache]
> > Jul 07 20:02:02 home kernel:  process_one_work+0x1e0/0x490
> > Jul 07 20:02:02 home kernel:  rescuer_thread+0x20c/0x390
> > Jul 07 20:02:02 home kernel:  kthread+0x125/0x140
> > Jul 07 20:02:02 home kernel:  ? cancel_delayed_work_sync+0x20/0x20
> > Jul 07 20:02:02 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 20:02:02 home kernel:  ret_from_fork+0x2c/0x40
> > Jul 07 20:02:02 home kernel: INFO: task systemd-logind:412 blocked for more
> > than 120 seconds.
> > Jul 07 20:02:02 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 20:02:02 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 20:02:02 home kernel: systemd-logind  D    0   412      1 0x00000100
> > Jul 07 20:02:02 home kernel: Call Trace:
> > Jul 07 20:02:02 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 20:02:02 home kernel:  schedule+0x3d/0x90
> > Jul 07 20:02:02 home kernel:  rwsem_down_write_failed+0x175/0x250
> > Jul 07 20:02:02 home kernel:  ? ida_get_new_above+0x1a7/0x320
> > Jul 07 20:02:02 home kernel: call_rwsem_down_write_failed+0x17/0x30
> > Jul 07 20:02:02 home kernel:  ? call_rwsem_down_write_failed+0x17/0x30
> > Jul 07 20:02:02 home kernel:  down_write+0x24/0x40
> > Jul 07 20:02:02 home kernel:  register_shrinker+0x3e/0x90
> > Jul 07 20:02:02 home kernel:  sget_userns+0x409/0x470
> > Jul 07 20:02:02 home kernel:  ? get_anon_bdev+0x110/0x110
> > Jul 07 20:02:02 home kernel:  ? shmem_remount_fs+0x1c0/0x1c0
> > Jul 07 20:02:02 home kernel:  sget+0x5e/0x80
> > Jul 07 20:02:02 home kernel:  ? get_anon_bdev+0x110/0x110
> > Jul 07 20:02:02 home kernel:  mount_nodev+0x30/0xa0
> > Jul 07 20:02:02 home kernel:  shmem_mount+0x18/0x20
> > Jul 07 20:02:02 home kernel:  mount_fs+0x32/0x160
> > Jul 07 20:02:02 home kernel:  vfs_kern_mount.part.7+0x5d/0x110
> > Jul 07 20:02:02 home kernel:  do_mount+0x528/0xc60
> > Jul 07 20:02:02 home kernel:  ? _copy_from_user+0x4b/0x80
> > Jul 07 20:02:02 home kernel:  SyS_mount+0x5a/0xe0
> > Jul 07 20:02:02 home kernel:  do_syscall_64+0x54/0xc0
> > Jul 07 20:02:02 home kernel:  entry_SYSCALL64_slow_path+0x25/0x25
> > Jul 07 20:02:02 home kernel: RIP: 0033:0x7f35e30b98da
> > Jul 07 20:02:02 home kernel: RSP: 002b:00007ffc4ed06fb8 EFLAGS: 00000202
> > ORIG_RAX: 00000000000000a5
> > Jul 07 20:02:02 home kernel: RAX: ffffffffffffffda RBX: 0000557b6f476480
> > RCX: 00007f35e30b98da
> > Jul 07 20:02:02 home kernel: RDX: 0000557b6d4f1402 RSI: 0000557b6f478b80
> > RDI: 0000557b6d4f1402
> > Jul 07 20:02:02 home kernel: RBP: 0000000000000000 R08: 0000557b6f478d80
> > R09: 0000000000000040
> > Jul 07 20:02:02 home kernel: R10: 0000000000000006 R11: 0000000000000202
> > R12: 00007ffc4ed07060
> > Jul 07 20:02:02 home kernel: R13: 0000557b6d4f17ff R14: 0000000000000000
> > R15: 0000000000000000
> > Jul 07 20:02:02 home kernel: INFO: task xfsaild/bcache0:5174 blocked for
> > more than 120 seconds.
> > Jul 07 20:02:02 home kernel:       Tainted: G           O 4.11.7-1-ARCH #1
> > Jul 07 20:02:02 home kernel: "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul 07 20:02:02 home kernel: xfsaild/bcache0 D    0  5174      2 0x00000000
> > Jul 07 20:02:02 home kernel: Call Trace:
> > Jul 07 20:02:02 home kernel:  __schedule+0x22e/0x8e0
> > Jul 07 20:02:02 home kernel:  schedule+0x3d/0x90
> > Jul 07 20:02:02 home kernel:  schedule_timeout+0x224/0x3c0
> > Jul 07 20:02:02 home kernel:  ? check_preempt_curr+0x27/0x80
> > Jul 07 20:02:02 home kernel:  ? ttwu_do_wakeup.isra.16+0x1e/0x170
> > Jul 07 20:02:02 home kernel:  wait_for_common+0xb9/0x180
> > Jul 07 20:02:02 home kernel:  ? wait_for_common+0xb9/0x180
> > Jul 07 20:02:02 home kernel:  ? wake_up_q+0x80/0x80
> > Jul 07 20:02:02 home kernel:  wait_for_completion+0x1d/0x20
> > Jul 07 20:02:02 home kernel:  flush_work+0x13b/0x1c0
> > Jul 07 20:02:02 home kernel:  ? flush_workqueue_prep_pwqs+0x190/0x190
> > Jul 07 20:02:02 home kernel:  xlog_cil_force_lsn+0x7c/0x200 [xfs]
> > Jul 07 20:02:02 home kernel:  ? try_to_del_timer_sync+0x53/0x80
> > Jul 07 20:02:02 home kernel:  _xfs_log_force+0x85/0x290 [xfs]
> > Jul 07 20:02:02 home kernel:  ? del_timer_sync+0x50/0x50
> > Jul 07 20:02:02 home kernel:  ? xfsaild+0x16a/0x7c0 [xfs]
> > Jul 07 20:02:02 home kernel:  xfs_log_force+0x2c/0x90 [xfs]
> > Jul 07 20:02:02 home kernel:  xfsaild+0x16a/0x7c0 [xfs]
> > Jul 07 20:02:02 home kernel:  kthread+0x125/0x140
> > Jul 07 20:02:02 home kernel:  ? kthread+0x125/0x140
> > Jul 07 20:02:02 home kernel:  ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> > Jul 07 20:02:02 home kernel:  ? kthread_create_on_node+0x70/0x70
> > Jul 07 20:02:02 home kernel:  ret_from_fork+0x2c/0x40
> 
> This is bcache issue?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
--1641074820-1652761076-1499447763=:17052--
