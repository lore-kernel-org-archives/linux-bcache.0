From: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Subject: [BUG] bcache_writebac blocked, IO on bcache device hung
Date: Sun, 10 Apr 2016 20:21:45 +0200
Message-ID: <570A99B9.1040504@roesner-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from euler.f0o.de ([85.88.6.196]:54230 "EHLO mail.f0o.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbcDJSVt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 10 Apr 2016 14:21:49 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I had an issue with bcache and kernel 4.5.0. I'm not sure that it was=20
purely bcache related, but IO on the bcache device didn't work anymore=20
whereas other volumes still worked fine.

After bcache blocked, it showed up the same message for dmcrypt_write.=20
On top of the bcache device I run LVM and encrypt its LVs.


=E2=94=94=E2=94=80sda2                                              8:3=
4    part
   =E2=94=94=E2=94=80md1                                             9:=
1     raid1
     =E2=94=94=E2=94=80bcache0                                     252:=
0     disk
       =E2=94=9C=E2=94=80storage-XXXXXXXXXXXXX_crypt               253:=
0     lvm
       =E2=94=82 =E2=94=94=E2=94=80XXXXXXXXXXXX                        =
    253:137   crypt
       =E2=94=9C=E2=94=80storage-XXXXXXXXXXXX_crypt                253:=
1     lvm
       =E2=94=82 =E2=94=94=E2=94=80XXXXXXXXXXXX                        =
    253:122   crypt
[..]

Bcache was patched with the patches from

https://bitbucket.org/ewheelerinc/linux v4.5-rc6-bcache-fixes
https://bitbucket.org/ewheelerinc/linux v4.5-rc7-bcache-fixes

Trace:

INFO: task bcache_writebac:10061 blocked for more than 120 seconds.
       Not tainted 4.5.0-kvmhost #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
bcache_writebac D ffff88081fc94440     0 10061      2 0x00000000
  ffff8807f83d2400 ffff8807fc2ae180 000000020000a07c ffffffff810036a4
  ffff8800cb444000 ffffffff00000052 ffff8807f83d2400 ffff8807f7df0bc0
  0000000000000000 ffff8807f7df0000 ffffffff81410370 ffff8807f7df0ad8
Call Trace:
  [<ffffffff810036a4>] ? __switch_to+0x1c8/0x36e
  [<ffffffff81410370>] ? schedule+0x7a/0x87
  [<ffffffff81411c6c>] ? rwsem_down_write_failed+0x241/0x2b0
  [<ffffffff81218763>] ? call_rwsem_down_write_failed+0x13/0x20
  [<ffffffff81411539>] ? down_write+0x24/0x33
  [<ffffffffa044ccac>] ? bch_writeback_thread+0x48/0x6bc [bcache]
  [<ffffffffa044cc64>] ? write_dirty_finish+0x1d4/0x1d4 [bcache]
  [<ffffffff8105efa2>] ? kthread+0x99/0xa1
  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
  [<ffffffff814129df>] ? ret_from_fork+0x3f/0x70
  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
INFO: task dmcrypt_write:11119 blocked for more than 120 seconds.
       Not tainted 4.5.0-kvmhost #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
dmcrypt_write   D ffff88081fc54440     0 11119      2 0x00000000
  ffff8807ebe0ce00 ffff8807fc2aee80 ffff8807f929eac0 0000000002011200
  ffff8800ce50c000 ffff8807ebe0ce00 0000000000000000 ffff8807bcd33020
  0000000000000001 0000000000000001 ffffffff81410370 ffff8807f7df0ad8
Call Trace:
  [<ffffffff81410370>] ? schedule+0x7a/0x87
  [<ffffffff81411a15>] ? rwsem_down_read_failed+0xc6/0xdc
  [<ffffffff810e71c8>] ? mempool_alloc+0x61/0x12d
  [<ffffffff81218734>] ? call_rwsem_down_read_failed+0x14/0x30
  [<ffffffff81411513>] ? down_read+0x17/0x19
  [<ffffffffa04441d9>] ? cached_dev_make_request+0x411/0x738 [bcache]
  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
  [<ffffffffa0314917>] ? dmcrypt_write+0x131/0x160 [dm_crypt]
  [<ffffffff8106674c>] ? try_to_wake_up+0x1b5/0x1b5
  [<ffffffffa03147e6>] ? crypt_iv_benbi_gen+0x37/0x37 [dm_crypt]
  [<ffffffff8105efa2>] ? kthread+0x99/0xa1
  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
  [<ffffffff814129df>] ? ret_from_fork+0x3f/0x70
  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
INFO: task dmcrypt_write:11609 blocked for more than 120 seconds.
       Not tainted 4.5.0-kvmhost #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
dmcrypt_write   D ffff88081fc54440     0 11609      2 0x00000000
  ffff8807f04e4e80 ffff8807fc2aee80 ffff8807f929eac0 0000000002011200
  ffff8807eb2b4000 ffff8807f04e4e80 0000000000000000 ffff8807bab51020
  0000000000000001 0000000000000001 ffffffff81410370 ffff8807f7df0ad8
Call Trace:
  [<ffffffff81410370>] ? schedule+0x7a/0x87
  [<ffffffff81411a15>] ? rwsem_down_read_failed+0xc6/0xdc
  [<ffffffff810e71c8>] ? mempool_alloc+0x61/0x12d
  [<ffffffff81218734>] ? call_rwsem_down_read_failed+0x14/0x30
  [<ffffffff81411513>] ? down_read+0x17/0x19
  [<ffffffffa04441d9>] ? cached_dev_make_request+0x411/0x738 [bcache]
  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
  [<ffffffffa0314917>] ? dmcrypt_write+0x131/0x160 [dm_crypt]
  [<ffffffff8106674c>] ? try_to_wake_up+0x1b5/0x1b5
  [<ffffffffa03147e6>] ? crypt_iv_benbi_gen+0x37/0x37 [dm_crypt]
  [<ffffffff8105efa2>] ? kthread+0x99/0xa1
  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16
  [<ffffffff814129df>] ? ret_from_fork+0x3f/0x70
  [<ffffffff8105ef09>] ? kthread_parkme+0x16/0x16

Sebastian
