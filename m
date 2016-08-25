From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs][tier] kernel BUG at drivers/md/bcache/super.c:1561!
 after double changing state of device
Date: Thu, 25 Aug 2016 13:44:22 +0200
Message-ID: <a38921be-e827-d227-6e86-3713f42db09c@mejor.pl>
References: <d29af387-c549-345d-974a-ee21047978ad@mejor.pl>
 <ca2d4c8e-37bc-bc63-3153-3a089c54ccc4@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:42641 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933297AbcHYLq4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 07:46:56 -0400
In-Reply-To: <ca2d4c8e-37bc-bc63-3153-3a089c54ccc4@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

W dniu 25.08.2016 o 13:04, Marcin Mirosław pisze:
> And now I've got data corruption:
> # md5sum *
> md5sum: gentoo: Jest katalogiem
> md5sum: proxmox-ve_3.1-93bf03d4-8.iso: Błąd wejścia/wyjścia  /* in
> english: IO error */
> 
> dmesg:
> [ 1857.151644] bcache (181708b5-8f1d-4533-bad9-c3ebfea4db0c): IO error
> on dm-10 for checksum error
> [ 1857.349356] bcache (181708b5-8f1d-4533-bad9-c3ebfea4db0c): IO error
> on dm-10 for checksum error

# umount /mnt/test
hangs forever.
I issued
# echo t >/proc/sysrq-trigger

[...]
Aug 25 13:42:11 localhost kernel: [ 4321.952551] umount          D
ffff8800cf5cbce8     0  2620  20218 0x00000000
Aug 25 13:42:11 localhost kernel: [ 4321.952555]  ffff8800cf5cbce8
ffff8800cf5cbcf8 ffff88014a1a0000 ffff8800a0899b40
Aug 25 13:42:11 localhost kernel: [ 4321.952558]  ffff880149868000
ffff8800cf5cc000 ffff8800cf5cbe20 ffff8800cf5cbe18
Aug 25 13:42:11 localhost kernel: [ 4321.952562]  ffff8800a0899b40
ffff8800a089a238 ffff8800cf5cbd00 ffffffff8156fcea
Aug 25 13:42:11 localhost kernel: [ 4321.952566] Call Trace:
Aug 25 13:42:11 localhost kernel: [ 4321.952568]  [<ffffffff8156fcea>]
schedule+0x3a/0x90
Aug 25 13:42:11 localhost kernel: [ 4321.952571]  [<ffffffff81572f93>]
schedule_timeout+0x1b3/0x280
Aug 25 13:42:11 localhost kernel: [ 4321.952573]  [<ffffffff8157001f>] ?
preempt_schedule+0x1f/0x30
Aug 25 13:42:11 localhost kernel: [ 4321.952576]  [<ffffffff81002016>] ?
___preempt_schedule+0x16/0x18
Aug 25 13:42:11 localhost kernel: [ 4321.952579]  [<ffffffff815711f5>]
wait_for_completion+0xd5/0x110
Aug 25 13:42:11 localhost kernel: [ 4321.952581]  [<ffffffff81082760>] ?
wake_up_q+0x70/0x70
Aug 25 13:42:11 localhost kernel: [ 4321.952597]  [<ffffffffc0938c40>]
bch_kill_sb+0x90/0xa0 [bcache]
Aug 25 13:42:11 localhost kernel: [ 4321.952600]  [<ffffffff811921ae>]
deactivate_locked_super+0x3e/0x70
Aug 25 13:42:11 localhost kernel: [ 4321.952602]  [<ffffffff81192647>]
deactivate_super+0x57/0x60
Aug 25 13:42:11 localhost kernel: [ 4321.952605]  [<ffffffff811af9ea>]
cleanup_mnt+0x3a/0x80
Aug 25 13:42:11 localhost kernel: [ 4321.952607]  [<ffffffff811afa6d>]
__cleanup_mnt+0xd/0x10
Aug 25 13:42:11 localhost kernel: [ 4321.952609]  [<ffffffff8107609c>]
task_work_run+0x7c/0xa0
Aug 25 13:42:11 localhost kernel: [ 4321.952612]  [<ffffffff810022ef>]
exit_to_usermode_loop+0x9f/0xb0
Aug 25 13:42:11 localhost kernel: [ 4321.952615]  [<ffffffff81002b78>]
syscall_return_slowpath+0x48/0x60
Aug 25 13:42:11 localhost kernel: [ 4321.952618]  [<ffffffff81574399>]
entry_SYSCALL_64_fastpath+0x91/0x93
