From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: how to re-align data offset
Date: Tue, 28 Feb 2017 17:00:56 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1702281655340.21435@mail.ewheeler.net>
References: <7bc2c18a.302.15a62165fe0.Coremail.zhangbonian17@163.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1501929768-1488330056=:21435"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:33934 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751392AbdCABEm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Feb 2017 20:04:42 -0500
In-Reply-To: <7bc2c18a.302.15a62165fe0.Coremail.zhangbonian17@163.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?GB2312?B?1cWw2MTq?= <zhangbonian17@163.com>
Cc: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1501929768-1488330056=:21435
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 22 Feb 2017, 张柏年 wrote:

> The backing device /dev/md0 was a raid 0 array with 2 disks and 64k 
> stripe size. The bcache device was created like this:
> 
> sudo make-bcache -B /dev/md0
> 
> I have just learned from the bcache kernel document that data-offset 
> shoud be provided for data alignment, if the backing device is an array. 
> Is there any way to correct this? ps: /dev/bcache0 has already been 
> formated as btrfs

I think you might be stuck without a backup/format/restore.  Technically, 
you could do something like this but its dangerous unless you get it just 
perfect:

1. shrunk btrfs to minimum size
2. Detach any writeback bcache caches
3. Use some tool (not sure what) to move each Nth block to the (N-1)th 
   block location aligned to the offset you want (sounds like 64k-8k or 
   maybe 128k-8k) starting from the *END* of the disk.
4. Re make-bcache with the right block offset using your new start of data 
   offset from #3.
5. Register bcache, attach any caches you want
6. Resize btrfs to use the full disk again.

Try this at your own risk, and definitely test it on another environment 
first!  If you are able to make this work, then please write back and let 
us know what tool you used so we can have a procedure available for 
others!

-Eric


--
Eric Wheeler



> 
> Thanks,
> Bonian ZhangN嫥叉靣笡y???氊b瞂???千v豝???藓{.n???壏???{眒茰呰Ф洝塄}???财爖???j:+v墾???珣赙zZ+€???zf＂穐殘???啳嗃i???鄗???畐ア???櫒璀??????撷f
--1641074820-1501929768-1488330056=:21435--
