From: Stefan Priebe <s.priebe@profihost.ag>
Subject: bcache_writeback task blocked for more ...
Date: Sat, 18 Jul 2015 07:27:30 +0200
Message-ID: <55A9E3C2.4040608@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:17104 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbGRF1P (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 18 Jul 2015 01:27:15 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: kent.overstreet@gmail.com, Eric Wheeler <bcache@lists.ewheeler.net>

Hi List,

while running bcache on 3.18.18 and having added the known patches from 
the list i still get blocked bcache_writeback tasks.

The kernel does now show any stack trace on his own.

The relevant tasks look like this:
[: ~]# cat /proc/769/stack
[<ffffffffa01e9685>] closure_sync+0x25/0x90 [bcache]
[<ffffffffa01feb9c>] read_dirty+0x31c/0x410 [bcache]
[<ffffffffa01fee94>] bch_writeback_thread+0x204/0x400 [bcache]
[<ffffffff81090af9>] kthread+0xc9/0xe0
[<ffffffff815f9008>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff
[: ~]# cat /proc/769/stack
[<ffffffffa01e9685>] closure_sync+0x25/0x90 [bcache]
[<ffffffffa01feb9c>] read_dirty+0x31c/0x410 [bcache]
[<ffffffffa01fee94>] bch_writeback_thread+0x204/0x400 [bcache]
[<ffffffff81090af9>] kthread+0xc9/0xe0
[<ffffffff815f9008>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff
[: ~]# cat /proc/773/stack
[<ffffffff810b7601>] down+0x41/0x50
[<ffffffffa01fea78>] read_dirty+0x1f8/0x410 [bcache]
[<ffffffffa01fee94>] bch_writeback_thread+0x204/0x400 [bcache]
[<ffffffff81090af9>] kthread+0xc9/0xe0
[<ffffffff815f9008>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff
[: ~]# cat /proc/783/stack
[<ffffffffa01e9685>] closure_sync+0x25/0x90 [bcache]
[<ffffffffa01feb9c>] read_dirty+0x31c/0x410 [bcache]
[<ffffffffa01fee94>] bch_writeback_thread+0x204/0x400 [bcache]
[<ffffffff81090af9>] kthread+0xc9/0xe0
[<ffffffff815f9008>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

Greets,
Stefan
