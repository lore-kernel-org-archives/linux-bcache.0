From: Mariusz Paradowski <indianin@indianin.net>
Subject: Re: mostly stable kernel version for bcache
Date: Thu, 05 Jun 2014 13:01:30 +0200
Message-ID: <d817d72f9f4b76261b01b2efc6208519@indianin.eu.org>
References: <CACaajQv3h-J9ZobsdKXY-rO8NAz5TahtHv3GeDZOtHS1mwV=mw@mail.gmail.com>
 <CALJ65z=3R9D+0xKGnniA+ho9VpBU7u+tzePQACKUQEOaA2S9mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from byf58.internetdsl.tpnet.pl ([83.19.9.58]:39451 "EHLO
	mail.vaxvms.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaFELBi (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Jun 2014 07:01:38 -0400
Received: from mail.vaxvms.net (byf58.internetdsl.tpnet.pl [83.19.9.58])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(Client did not present a certificate)
	(Authenticated sender: indianin@indianin.eu.org)
	by mail.vaxvms.net (Postfix) with ESMTPSA id 3gkkZP1Qmnz13gwZb
	for <linux-bcache@vger.kernel.org>; Thu,  5 Jun 2014 13:01:33 +0200 (CEST)
In-Reply-To: <CALJ65z=3R9D+0xKGnniA+ho9VpBU7u+tzePQACKUQEOaA2S9mA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache <linux-bcache@vger.kernel.org>

On 2014-06-05 06:14, Kent Overstreet wrote:

> 3.14.

i'm not sure...
(writethrough mode)

INFO: rcu_sched self-detected stall on CPU { 2}  (t=2100 jiffies 
g=701003 c=701002 q=855)
sending NMI to all CPUs:
NMI backtrace for cpu 2
CPU: 2 PID: 140 Comm: bcache_gc Not tainted 3.14.3 #1
Hardware name:                  /DH87MC, BIOS 
MCH8710H.86A.0047.2013.0606.1508 06/06/2013
task: ffff88040d668d40 ti: ffff8800c56b4000 task.ti: ffff8800c56b4000
RIP: 0010:[<ffffffff811bb7e9>]  [<ffffffff811bb7e9>] 0xffffffff811bb7e9
RSP: 0018:ffff88041fb03e78  EFLAGS: 00000006
RAX: 0000000000000c00 RBX: 0000000000002710 RCX: 0000000000000006
RDX: 00000000020598ba RSI: 0000000000000002 RDI: 0000000000418958
RBP: ffffffff81621a00 R08: 0000000000000000 R09: 00000000000002cd
R10: 0000000000000050 R11: 0000000000000006 R12: 0000000000000002
R13: ffffffff8164d6d8 R14: 0000000000000357 R15: ffffffff81621a00
FS:  0000000000000000(0000) GS:ffff88041fb00000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1de0aa87e0 CR3: 00000000c53dd000 CR4: 00000000001407a0
Stack:
ffffffff8101f1c5 ffff88041fb0d020 ffffffff81087ac5 ffff88041fb10f40
0000000000000002 ffff88041fb03ea0 ffff88040d668d40 0000000000000000
0000000000000002 0000000000000000 7fffffffffffffff 00033217b4421ff1
Call Trace:
<IRQ>
[<ffffffff8101f1c5>] ? 0xffffffff8101f1c5
[<ffffffff81087ac5>] ? 0xffffffff81087ac5
[<ffffffff8105546b>] ? 0xffffffff8105546b
[<ffffffff8109000f>] ? 0xffffffff8109000f
[<ffffffff81066ddc>] ? 0xffffffff81066ddc
[<ffffffff81067295>] ? 0xffffffff81067295
[<ffffffff8101df96>] ? 0xffffffff8101df96
[<ffffffff81309107>] ? 0xffffffff81309107
<EOI>
[<ffffffffa00d9f45>] ? 0xffffffffa00d9f45
[<ffffffffa00d8b6d>] ? 0xffffffffa00d8b6d
[<ffffffffa00d530d>] ? 0xffffffffa00d530d
[<ffffffffa00d87fb>] ? 0xffffffffa00d87fb
[<ffffffffa00d7799>] ? 0xffffffffa00d7799
[<ffffffff81079110>] ? 0xffffffff81079110
[<ffffffffa00d7af8>] ? 0xffffffffa00d7af8
[<ffffffffa00d7ad0>] ? 0xffffffffa00d7ad0
[<ffffffffa00d7ad0>] ? 0xffffffffa00d7ad0
[<ffffffff81064621>] ? 0xffffffff81064621
[<ffffffff81064560>] ? 0xffffffff81064560
[<ffffffff8130853c>] ? 0xffffffff8130853c
[<ffffffff81064560>] ? 0xffffffff81064560
Code: 00 00 48 ff c8 75 fb 48 ff c8 c3 0f 1f 80 00 00 00 00 48 8b 05 69 
bb 47 00 ff e0 0f 1f 80 00 00 00 00 65 48 8b 14 25 60 07 01 00 <48> 8d 
14 92 48 8d 04 bd 00 00 00 00 48 8d 14 92 f7 e2 48 8d 7a
-- 
Mariusz Paradowski
System & Network Administrator
MP7509-RIPE
+48 504 653 586
