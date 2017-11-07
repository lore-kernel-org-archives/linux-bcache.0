From: Campbell Steven <casteven@gmail.com>
Subject: Testing 4.14 rc8 kernel with bcache - cache device numbering
Date: Tue, 7 Nov 2017 15:37:57 +1300
Message-ID: <CAPerZE8dmu60sksC+hkk4E+GOht1F5nExPTvv4WRS=kRGO+GZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:44017 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752526AbdKGCh6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Nov 2017 21:37:58 -0500
Received: by mail-yw0-f175.google.com with SMTP id y75so9695892ywg.0
        for <linux-bcache@vger.kernel.org>; Mon, 06 Nov 2017 18:37:58 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I've been doing some testing so that we can move from a 4.7 kernel up
to 4.14 at some point in the future.

One thing I've noticed is that the numbering of the bcache devices is
quite different, is there a reason it's going 0,16,32 etc.?

[Tue Nov  7 13:41:54 2017] bcache: bch_cached_dev_attach() Caching
sdb1 as bcache0 on set 030a5f1b-b314-482f-ba91-be1d712a4a33
[Tue Nov  7 14:32:45 2017] bcache: bch_cached_dev_attach() Caching
sda1 as bcache16 on set 07cd8359-1427-4446-9688-d67ceb4f4b4c
[Tue Nov  7 14:36:36 2017] bcache: bch_cached_dev_attach() Caching
sdc1 as bcache32 on set 030a5f1b-b314-482f-ba91-be1d712a4a33

Thanks

Campbell
