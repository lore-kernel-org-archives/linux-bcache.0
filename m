From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re[2]: 3.17: bcache_gc: BUG: soft lockup - CPU#2 stuck for 22s!
Date: Fri, 31 Oct 2014 16:35:13 +0600
Message-ID: <94854461.20141031163513@pvgoran.name>
References: <alpine.DEB.2.00.1409281651340.15834@ware.dreamhost.com> <alpine.DEB.2.02.1410261940500.5742@ware.dreamhost.com> <CAC8teKWQLjE8HgGg5mBG14oSHyCeK_vosnt+wXoiGEG8-svUCg@mail.gmail.com>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:46903 "EHLO
	v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbaJaKfR (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 31 Oct 2014 06:35:17 -0400
In-Reply-To: <CAC8teKWQLjE8HgGg5mBG14oSHyCeK_vosnt+wXoiGEG8-svUCg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello Zhu,

Friday, October 31, 2014, 3:20:32 PM, you wrote:

> Theoretically this livelock does exist all the way, however we can't
> reproduce it on 3.17 kernel, or maybe it's just because the stress is
> not big enough. Anyway it can be reproduced easily on RHEL6 kernel (we
> have ported bcache back to the RHEL6 kernel). Dunno if it's caused by
> the differences between the schedulers.

My  experience  shows that scheduler can be a factor here. I regularly had the
lockup  issue  while  running  a kernel with BFS scheduler (pf-kernel). Then I
switched  to  CFS  and lockups disappeared. (Now I'm running 3.17 with BFS and
with the October 18 patch from the mailing list, no issues as of yet.)

Pavel Goran
  
