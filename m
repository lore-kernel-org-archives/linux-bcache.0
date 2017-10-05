From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Thu, 5 Oct 2017 15:59:26 -0700
Message-ID: <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li> <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li> <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li> <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li> <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li> <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li> <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:56888 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdJEW72 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Oct 2017 18:59:28 -0400
Received: by mail-qk0-f181.google.com with SMTP id l194so6322022qke.13
        for <linux-bcache@vger.kernel.org>; Thu, 05 Oct 2017 15:59:27 -0700 (PDT)
In-Reply-To: <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

I think one of the problems here is that there is no consistent
requirements or figure of merit for performance.

You've argued against changes because of A) perceived impact to
front-end I/O latency, B) writeback rate at idle, C) peak
instantaneous writeback rate, D) time to writeback the entire amount.
These are all, to some extent, contradictory.

I was trying to make changes in writeback to improve **efficiency**--
the amount of writeback that is done per the amount of time the
backing device is tied up.  We could have added tunables for A/B/C to
pick any operating along there.  In addition, the changes I was trying
to make were **on the path to further improvement**-- submitting
sequential I/O together with plugging is known to improve merge.

Users on #bcache IRC on oftc.net constantly talk about writeback
performance and writeback use cases-- it's probably the most common
topic of discussion about bcache.  These changes would have improved
that and laid the groundwork for further improvement.

I've retired, but a year ago I was running a bcache environment with
about 40 computers running development environments  and continuous
integration test rigs; we would provision and tear down hundreds of
VMs per day; machines had 256-512GB of RAM, 1TB SATA RAID1 cache
volumes and RAID10 sets 6-8 drives wide.  The use case was enterprise
DB-- so I think I know a thing or two about enterprise use cases ;)

Writeback did obviously bad things in that environment, which is why I
wanted to fix it.  I also see obviously bad behavior on my small home
test rig of RAID1 480GB NVMe + RAID1 6TB disks.

Mike
