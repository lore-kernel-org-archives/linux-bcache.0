From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Question about gc time
Date: Tue, 27 Jun 2017 23:45:52 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706272344530.17052@mail.ewheeler.net>
References: <OF3C6614C4.E95909E3-ON4825814C.004157B0-4825814C.004253A0@zte.com.cn> <e9233b6e-a898-19ab-6502-ea735f85de6f@coly.li>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-437174839-1498607152=:17052"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:37422 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753975AbdF0Xpx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Jun 2017 19:45:53 -0400
In-Reply-To: <e9233b6e-a898-19ab-6502-ea735f85de6f@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: tang.junhui@zte.com.cn, kent.overstreet@gmail.com, linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-437174839-1498607152=:17052
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT




--
Eric Wheeler

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

Should it bypass the cache during GC if GC takes longer than X amount 
of time?  That might still need to wait if writing to invalidate since the 
btree needs updated to invalidate, so that may not be an option...

-Eric
--1641074820-437174839-1498607152=:17052--
