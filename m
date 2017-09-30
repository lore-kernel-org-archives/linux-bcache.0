From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sat, 30 Sep 2017 15:49:32 -0700
Message-ID: <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <477dc501-bbb3-f864-c637-1f19f787448a@coly.li> <CAJ+L6qczpYkLGzCZ+uxLDHXJdNi-jRCdGFvVuDHVdnXtjgo-Vg@mail.gmail.com>
 <96ab2f99-ab5a-6a86-1d14-1954622574f2@coly.li> <CAJ+L6qcXfNwqWX+mkqcPVNyqd+eRWG4_LrLJyAyTnop75wp3+w@mail.gmail.com>
 <3dfc3f12-b616-debd-8913-6049f215f2f3@coly.li> <CAJ+L6qf_zG37s4nGhxTbNvsdvDr5fwbmYocwP5m4rkjMLQKjtg@mail.gmail.com>
 <CAJ+L6qe9XjPOw=6NpWzZhw-PLC5EXhstOrPaapbqvDcD0+_7QA@mail.gmail.com>
 <CAJ+L6qcU+Db5TP1Q2J-V8angdzeW9DFGwc7KQqc4di9CSxusLg@mail.gmail.com>
 <CAJ+L6qdu4OSRh7Qdkk-5XBgd4W_N29Y6-wVLf-jFAMKEhQrTbQ@mail.gmail.com> <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:56800 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdI3Wte (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Sep 2017 18:49:34 -0400
Received: by mail-qt0-f182.google.com with SMTP id l25so3482737qtf.13
        for <linux-bcache@vger.kernel.org>; Sat, 30 Sep 2017 15:49:34 -0700 (PDT)
In-Reply-To: <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

One final attempt to resend, because gmail has been giving me trouble
sending plain text mail.

Two instances of this.  Tested as above, with a big set of random I/Os
that ultimately cover every block in a file (e.g. allowing sequential
writeback).

With the 5 patches, samsung 940 SSD cache + crummy 5400 RPM USB hard drive:

Typical seconds look like:

Reading 38232K from cache in 4809 IO.  38232/4809=7.95k per cache device IO.

Writing 38112k to cache in 400 I/O = 95.28k -- or we are combining
about 11.9 extents to a contiguous writeback.  Tracing, there are
still contiguous things that are not getting merged well, but it's OK.
(I'm hoping plugging makes this better).

sda            4809.00     38232.00       446.00      38232        446
sdb             400.00         0.00     38112.00          0      38112

Without the 5 patches, a typical second--

sda            2509.00     19968.00       316.00      19968        316
sdb             502.00         0.00     19648.00          0      38112

or we are combining about 4.9 extents to a contiguous writeback, and
writing back at about half the rate.  All of these numbers are +/- 10%
and obtained by eyeballing and grabbing representative seconds.

Mike

On Sat, Sep 30, 2017 at 2:02 AM, Michael Lyle <mlyle@lyle.org> wrote:
>
> Resent because I can't seem to get gmail to not send HTML mail.  And off to sleep.
>
>
> On Sat, Sep 30, 2017 at 1:57 AM, Michael Lyle <mlyle@lyle.org> wrote:
> > Two instances of this.
> >
> > With the 5 patches, samsung 940 SSD cache + crummy 5400 RPM USB hard drive:
> >
> > Typical seconds look like:
> >
> > Reading 38232K from cache in 4809 IO.  38232/4809=7.95k per cache device IO.
> >
> > Writing 38112k to cache in 400 I/O = 95.28k -- or we are combining about
> > 11.9 extents to a contiguous writeback.  Tracing, there are still contiguous
> > things that are not getting merged well, but it's OK.  (I'm hoping plugging
> > makes this better).
> >
> > sda            4809.00     38232.00       446.00      38232        446
> > sdb             400.00         0.00     38112.00          0      38112
> >
> > Without the 5 patches, a typical second--
> >
> > sda            2509.00     19968.00       316.00      19968        316
> > sdb             502.00         0.00     19648.00          0      38112
> >
> > or we are combining about 4.9 extents to a contiguous writeback, and writing
> > back at about half the rate.
> >
> > Anyways, cya, I'm unsubscribed.
> >
> > Mike
>
