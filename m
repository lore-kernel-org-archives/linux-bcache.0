From: FERNANDO FREDIANI <fernando.frediani@upx.com>
Subject: SSD usage for bcache - Read and Writeback
Date: Mon, 11 Sep 2017 11:04:19 -0300
Message-ID: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:46451 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdIKOEc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 11 Sep 2017 10:04:32 -0400
Received: by mail-wm0-f41.google.com with SMTP id i189so40606576wmf.1
        for <linux-bcache@vger.kernel.org>; Mon, 11 Sep 2017 07:04:31 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi folks

In Bcache people normally use a single SSD for both Read and Write
cache. This seems to work pretty well, at least for the load we have
been using here.

However in other environments, specially on ZFS people tend to suggest
to use dedicated SSDs for Write (ZIL) and for Read (L2ARC). Some say
that performance will be much better in this way and mainly say they
have different wearing levels.
The issue now a days is that SSDs for Write Cache (or Writeback) don't
need to have much space available (8GB normally is more than enough),
just enough for the time until data is committed to the pool (or
slower disks) so it is hard to find a suitable SSD to dedicate to this
propose only without overprovisioning that part.
On the top of that newer SSDs have changed a lot in recent times using
different types of memory technologies which tend to be much durable.

Given that I personally see that using a single SSD for both Write and
Read cache, in any scenarios doesn't impose any significant loss to
the storage, given you use new technology SSDs and that you will
hardly saturate it most of the time. Does anyone agree or disagree
with that ?

Fernando Frediani
