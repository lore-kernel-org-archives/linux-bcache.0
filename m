From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Question about gc time
Date: Tue, 27 Jun 2017 23:59:28 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706272355510.17052@mail.ewheeler.net>
References: <OF3C6614C4.E95909E3-ON4825814C.004157B0-4825814C.004253A0@zte.com.cn> <e9233b6e-a898-19ab-6502-ea735f85de6f@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-467794155-1498607969=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:37676 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753978AbdF0X7a (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 19:59:30 -0400
In-Reply-To: <e9233b6e-a898-19ab-6502-ea735f85de6f@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: tang.junhui@zte.com.cn, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-467794155-1498607969=:17052
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 28 Jun 2017, Coly Li wrote:

> On 2017/6/27 下午8:04, tang.junhui@zte.com.cn wrote:
> > Hello Eric, Coly,
> > 
> > I use a 1400G SSD device a bcache cache device,
> > and attach with 10 back-end devices,
> > and run random small write IOs,
> > when gc works, It takes about 15 seconds,
> > and the up layer application IOs was suspended at this time,
> > How could we bear such a long time IO stopping?
> > Is there any way we can avoid this problem?
> > 
> > I am very anxious about this question, any comment would be valuable.
> 
> I encounter same situation too.
> Hmm, I assume there are some locking issue here, to prevent application
> to send request and insert keys in LSM tree, no matter in writeback or
> writethrough mode. This is a lazy and fast response, I need to check the
> code then provide an accurate reply :-)

What controls the frequency?

On our system I noticed this:

]# tail /sys/block/bcache0/bcache/cache/internal/*gc*

==> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms <==
1455

==> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec <==
3521

==> /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms <==
7036


So usually it takes 1.4s, as much as 7s on our systems.  Average frequency 
is almost an hour.   Can GC just be triggered more frequently?  Say, once 
every 5min?  Is that configurable?

-Eric
 
> 
> 
> -- 
> Coly Li
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-467794155-1498607969=:17052--
