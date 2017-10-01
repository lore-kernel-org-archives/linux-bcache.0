From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sun, 1 Oct 2017 10:34:17 -0700
Message-ID: <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li> <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li> <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li> <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li> <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:49730 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdJAReT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 1 Oct 2017 13:34:19 -0400
Received: by mail-qt0-f177.google.com with SMTP id o3so4887067qte.6
        for <linux-bcache@vger.kernel.org>; Sun, 01 Oct 2017 10:34:19 -0700 (PDT)
In-Reply-To: <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On Sun, Oct 1, 2017 at 10:23 AM, Coly Li <i@coly.li> wrote:
> Hi Mike,
>
> Your data set is too small. Normally bcache users I talk with, they use
> bcache for distributed storage cluster or commercial data base, their
> catch device is large and fast. It is possible we see different I/O
> behaviors because we use different configurations.

A small dataset is sufficient to tell whether the I/O subsystem is
successfully aggregating sequential writes or not.  :P  It doesn't
matter whether the test is 10 minutes or 10 hours...  The writeback
stuff walks the data in order.  :P

***We are measuring whether the cache and I/O scheduler can correctly
order up-to-64-outstanding writebacks from a chunk of 500 dirty
extents-- we do not need to do 12 hours of writes first to measure
this.***

It's important that there be actual contiguous data, though, or the
difference will be less significant.  If you write too much, there
will be a lot more holes in the data from writeback during the test
and from writes bypassing the cache.

Having all the data to writeback be sequential is an
artificial/synthetic condition that allows the difference to be
measured more easily.  It's about a 2x difference under these
conditions in my test environment.  I expect with real data that is
not purely sequential it's more like a few percent.

Mike
