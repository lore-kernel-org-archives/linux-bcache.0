From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Re: Re: Question about gc time
Date: Fri, 7 Jul 2017 01:01:43 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1707070059230.17052@mail.ewheeler.net>
References: <OF3C6614C4.E95909E3-ON4825814C.004157B0-4825814C.004253A0@zte.com.cn> <e9233b6e-a898-19ab-6502-ea735f85de6f@coly.li> <alpine.LRH.2.11.1706272355510.17052@mail.ewheeler.net> <OF88AF0700.94E41E34-ON48258152.001FB326-48258152.0020F635@zte.com.cn>
 <alpine.LRH.2.11.1707031912530.17052@mail.ewheeler.net> <OFCAB991B9.CC49F1AD-ON48258153.000235D7-48258154.000C1863@zte.com.cn>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1811819324-1499389304=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:35834 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752924AbdGGBBp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jul 2017 21:01:45 -0400
In-Reply-To: <OFCAB991B9.CC49F1AD-ON48258153.000235D7-48258154.000C1863@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: Coly Li <i@coly.li>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1811819324-1499389304=:17052
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Jul 2017, tang.junhui@zte.com.cn wrote:

> > Perhaps.  What is the total lock time that prevents IO?  Can you note
> > those below?
> 
> The total lock time that prevents IO is btree root node writer locker.
> We take too much time in  btree_gc_mark_node - about 98% in GC, since
> it is all memory operations, I think we can optimize it, do you have any
> suggestions?


I'm not familiar with that code.  Could you do it in 2 passes, the first 
to find candidates for GC and the second to lock, re-test the candidates, 
and GC them?  This would minimize lock time.

Of course it doesn't help in the case where an IO is blocked waiting for 
GC under contention, so that needs to be considered.  


Maybe Kent has some way of dealing with this in bcachefs?  Maybe compare 
his GC code in the bcachefs dev branch with the bcache block driver code.

--
Eric Wheeler



> 
> Tang Junhui
> 
> 
> 
> 
> 发件人:         Eric Wheeler <bcache@lists.ewheeler.net>
> 收件人:         tang.junhui@zte.com.cn,
> 抄送:        Coly Li <i@coly.li>, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
> linux-block@vger.kernel.org
> 日期:         2017/07/04 03:15
> 主题:        Re: Re: Question about gc time
> 
> _________________________________________________________________________________________________________________
> 
> 
> 
> On Mon, 3 Jul 2017, tang.junhui@zte.com.cn wrote:
> 
> > Hello Eric, Coly
> >
> > > So usually it takes 1.4s, as much as 7s on our systems.  Average frequency
> > > is almost an hour.   Can GC just be triggered more frequently?  Say, once
> > > every 5min?  Is that configurable?
> >
> > GC is triggered by writing c->sb.bucket_size * c->nbuckets / 16 cache
> > data, or triggered by invalidating when there is not enough free
> > buckets. So GC time is not configurable, and I also do not think it is
> > usable by triggering GC more frequently, because as debug the code, in
> > my test bcache version, I find most time used in btree_gc_mark_node()
> > (in the latest bcache version it maybe btree_gc_mark_node() and
> > btree_gc_count_keys()), They are all memory operations, can we optimize
> > it?
> 
> Perhaps.  What is the total lock time that prevents IO?  Can you note
> those below?
> 
> 
> --
> Eric Wheeler
> 
> 
> 
> >
> > test result：
> >
> > Jul  3 13:38:27 ceph192-9-9-153 kernel: [10541.541876] gc trigged by sectors_to_gc
> > Jul  3 13:38:27 ceph192-9-9-153 kernel: [10541.544372] bch_gc_thread works
> > Jul  3 13:38:27 ceph192-9-9-153 kernel: [10541.569479] gc begin btree_root
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.883089] add cl ffff880458627b18 to wait:ffff8804583237f0
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.884319] journal_write_root with journal_write_unlocked
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.885522] in journal_write_unlocked_root
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.886770] bch_btree_set_root_gc closure_sync wait cl:
> > ffff880458627b18
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.886852] journal_write_done_root wake up wait: ffff8804583237f0
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.889190] bch_btree_set_root_gc closure_sync wait cl:
> > ffff880458627b18 end
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.892783] gc btree_root over, begin bch_btree_gc_finish
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.895303] mark_node: 7203 times, 7074 ms; btree_alloc: 0 times, 0
> > ms; coalse: 7203 times, 0 ms; write1: 7202 times, 80 ms; write2: 1 times, 0 ms; sort_node: 1 times, 1 ms
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.926504] gc bch_btree_gc_finish over, wake_up_allocators
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.928720] bch_moving_gc over, aftre gc, available: 4399506,
> > nbuckets:6104768
> > Jul  3 13:38:34 ceph192-9-9-153 kernel: [10548.930144] bch_gc_thread works over
> > I am very anxious about this question, any comment would be valuable.
> >
> > Regards
> > Tang Junhui
> >
> >
> >
> >
> >
> > 发件人:         Eric Wheeler <bcache@lists.ewheeler.net>
> > 收件人:         Coly Li <i@coly.li>,
> > 抄送:        tang.junhui@zte.com.cn, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
> > 日期:         2017/06/28 08:00
> > 主题:        Re: Question about gc time
> >
> >________________________________________________________________________________________________________________
> _
> >
> >
> >
> > On Wed, 28 Jun 2017, Coly Li wrote:
> >
> > > On 2017/6/27 下午8:04, tang.junhui@zte.com.cn wrote:
> > > > Hello Eric, Coly,
> > > >
> > > > I use a 1400G SSD device a bcache cache device,
> > > > and attach with 10 back-end devices,
> > > > and run random small write IOs,
> > > > when gc works, It takes about 15 seconds,
> > > > and the up layer application IOs was suspended at this time,
> > > > How could we bear such a long time IO stopping?
> > > > Is there any way we can avoid this problem?
> > > >
> > > > I am very anxious about this question, any comment would be valuable.
> > >
> > > I encounter same situation too.
> > > Hmm, I assume there are some locking issue here, to prevent application
> > > to send request and insert keys in LSM tree, no matter in writeback or
> > > writethrough mode. This is a lazy and fast response, I need to check the
> > > code then provide an accurate reply :-)
> >
> > What controls the frequency?
> >
> > On our system I noticed this:
> >
> > ]# tail /sys/block/bcache0/bcache/cache/internal/*gc*
> >
> > ==> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms <==
> > 1455
> >
> > ==> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec <==
> > 3521
> >
> > ==> /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms <==
> > 7036
> >
> >
> > So usually it takes 1.4s, as much as 7s on our systems.  Average frequency
> > is almost an hour.   Can GC just be triggered more frequently?  Say, once
> > every 5min?  Is that configurable?
> >
> > -Eric
> >
> > >
> > >
> > > --
> > > Coly Li
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
> >
> 
> 
--1641074820-1811819324-1499389304=:17052--
