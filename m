From: Daniel J Blueman <daniel@quora.org>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Tue, 20 May 2014 15:07:19 +0800
Message-ID: <CAMVG2sv7JSo4wfUa-rqJmf6xMM7-4M+Jou_iTi+eFvvBZXJR5w@mail.gmail.com>
References: <20140411002636.GB9176@birch.djwong.org>
	<20140411004649.GA4817@kmo>
	<20140411014135.GA18933@birch.djwong.org>
	<20140412023101.GC9176@birch.djwong.org>
	<CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
	<20140430172455.GA3029@birch.djwong.org>
	<CAHnuAexAx_QK3tycB_2o60JDYZAHUgbec=fu3i47ZSXrL4nARg@mail.gmail.com>
	<CACHGV4L76Env_vu+bVqNgbRwuKa8TEY05wvXC8GBQUjzMuPWjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46890 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaETHHU (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 20 May 2014 03:07:20 -0400
Received: by mail-ob0-f177.google.com with SMTP id wp4so55800obc.22
        for <linux-bcache@vger.kernel.org>; Tue, 20 May 2014 00:07:20 -0700 (PDT)
In-Reply-To: <CACHGV4L76Env_vu+bVqNgbRwuKa8TEY05wvXC8GBQUjzMuPWjQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: Daniel Smedegaard Buus <danielbuus@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Kent Overstreet <kmo@daterainc.com>, Sam Fulcomer <enotty@brown.edu>, Francis Moreau <francis.moro@gmail.com>, linux-bcache@vger.kernel.org

On 2 May 2014 05:54, Slava Pestov <sp@datera.io> wrote:
> On Thu, May 1, 2014 at 2:38 AM, Daniel Smedegaard Buus
> <danielbuus@gmail.com> wrote:
>> On Wed, Apr 30, 2014 at 7:24 PM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>>>
>>> I haven't spent time on figuring out the other source of load average.  Kent
>>> didn't seem to like the patch to convert the bcache_writeback thread to
>>> interruptible sleep (I recall he said it was 'wrong', but didn't elaborate).
>>
>> Sorry to hear that... Would be really nice to be able to go back to
>> normal load. And I cannot revert to an older kernel, as I need
>> 3.15-rc2 or greater to fix a different problem concerning Oracle Java

> Hi Daniel and Darrick,
>
> I mailed a patch that attempts to fix the uninterruptible issue while
> taking Kent's feedback regarding your earlier patch into account.
> Please test it out and let me know what you think.

Hi Slava,

Apologies for the delays. I rebuilt 3.14.4 with your bcache patch [1]
and the 'bcache_writeback blocked for more than 120 seconds' don't
occur, though when the bcache threads are torn down during reboot, we
crash [2] at:

static void cached_dev_free(struct closure *cl)
{
    struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);

    cancel_delayed_work_sync(&dc->writeback_rate_update);
    kthread_stop(dc->writeback_thread);

dc->writeback_thread is clearly zero, as likely the struct cached_dev
was freed already.

Many thanks,
  Daniel

[1] http://www.spinics.net/lists/linux-bcache/msg02464.html

-- [2]

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff8108bff6>] kthread_stop+0x16/0xe0
PGD 0
Oops: 0002 [#1] SMP
Modules linked in: microcode(F) nfsd(F) nfs_acl(F) auth_rpcgss(F)
nfs(F) fscache(F) lockd(F) sunrpc(F) joydev(F) ipmi_si(F)
ipmi_msghandler(F) psmouse(F) serio_raw(F) video(F) mac_hid(F)
lpc_ich(F) lp(F) parport(F) btrfs(F) raid6_pq(F) bcache(F) xor(F)
hid_generic(F) usbhid(F) hid(F) e1000e(F) ptp(F) pps_core(F) ahci(F)
CPU: 2 PID: 27 Comm: kworker/2:0 Tainted: GF      3.14.4-bcachefix+ #3
Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0a 06/08/2012
Workqueue: events cached_dev_free [bcache]
task: ffff8804097363c0 ti: ffff8804097d2000 task.ti: ffff8804097d2000
RIP: 0010:[<ffffffff8108bff6>] [<ffffffff8108bff6>] kthread_stop+0x16/0xe0
RSP: 0018:ffff8804097d3df0 EFLAGS: 00010292
RAX: 0000000fffffff00 RBX: ffff8804034e0010 RCX: 000000007fffffff
RDX: 0000000000000296 RSI: 000000007fffffff RDI: 0000000000000000
RBP: ffff8804097d3e08 R08: 20100d3800400000 R09: 0080000000000000
R10: dfef7acc030e0010 R11: 0000000000000400 R12: 0000000000000000
R13: ffff8804034e0010 R14: 0000000000000000 R15: 0000000000000080
FS: 0000000000000000(0000) GS:ffff88041fd00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 0000000001c0e000 CR4: 00000000000407e0
Stack:
 ffff8804034e0010 ffff88041fd13d80 ffff8804034e0010 ffff8804097d3e20
 ffffffffa00b2dd5 ffff880409503580 ffff8804097d3e68 ffffffff81084482
 000000001fd13d98 ffff88041fd17f00 ffff88041fd13d98 ffff8804095035b0
Call Trace:
 [<ffffffffa00b2dd5>] cached_dev_free+0x25/0x100 [bcache]
 [<ffffffff81084482>] process_one_work+0x182/0x450
 [<ffffffff81085241>] worker_thread+0x121/0x410
 [<ffffffff81085120>] ? rescuer_thread+0x3e0/0x3e0
 [<ffffffff8108bdc2>] kthread+0xd2/0xf0
 [<ffffffff8108bcf0>] ? kthread_create_on_node+0x190/0x190
 [<ffffffff8173c67c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8108bcf0>] ? kthread_create_on_node+0x190/0x190
Code: e8 20 ff ff ff 48 89 df be 00 02 00 00 e8 63 10 01 00 5b 5d c3
66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 fc 53 66 66 66 66 90 <f0>
41 ff 44 24 10 49 8b 9c 24 a0 04 00 00 48 85 db 74 21 f0 80
RIP [<ffffffff8108bff6>] kthread_stop+0x16/0xe0
 RSP <ffff8804097d3df0>
CR2: 0000000000000010
-- 
Daniel J Blueman
