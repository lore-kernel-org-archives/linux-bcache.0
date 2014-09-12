From: Stefan Priebe <s.priebe@profihost.ag>
Subject: bcache_gc: BUG: soft lockup - CPU#4 stuck for 22s!
Date: Fri, 12 Sep 2014 06:02:08 +0200
Message-ID: <54127040.7090309@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:55194 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaILECJ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 12 Sep 2014 00:02:09 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi,

while trying to use bcache on 3.17-rc4 i got those messages and a load 
of 1000.

Is this a known problem?

14-09-12 02:32:22     BUG: soft lockup - CPU#4 stuck for 23s! 
[bcache_gc:1585]
2014-09-12 02:31:54     INFO: rcu_sched self-detected stall on CPU { 4} 
(t=150009 jiffies g=1762124 c=1762123 q=235323)
2014-09-12 02:31:42     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:31:14     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:30:46     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:30:18     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:29:50     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:29:22     BUG: soft lockup - CPU#4 stuck for 23s! 
[bcache_gc:1585]
2014-09-12 02:28:54     INFO: rcu_sched self-detected stall on CPU { 4} 
(t=105006 jiffies g=1762124 c=1762123 q=209365)
2014-09-12 02:28:42     BUG: soft lockup - CPU#4 stuck for 23s! 
[bcache_gc:1585]
2014-09-12 02:28:14     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:27:46     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:27:18     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:26:50     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:26:22     BUG: soft lockup - CPU#4 stuck for 22s! 
[bcache_gc:1585]
2014-09-12 02:25:54     INFO: rcu_sched self-detected stall on CPU { 4} 
(t=60003 jiffies g=1762124 c=1762123 q=136221)
2014-09-12 02:25:42     BUG: soft lockup - CPU#4 stuck for 23s! 
[bcache_gc:1585]
2014-09-12 02:25:14     BUG: soft lockup - CPU#4 stuck for 23s! 
[bcache_gc:1585]
2014-09-12 02:24:46     BUG: soft lockup - CPU#4 stuck for 23s! 
[bcache_gc:1585]


Stefan
