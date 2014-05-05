From: Nikolay Amiantov <nikoamia@gmail.com>
Subject: Re: [PATCH] bcache: fix uninterruptible sleep in writeback thread
Date: Tue, 6 May 2014 02:30:34 +0400
Message-ID: <CA+waHKU1Kaz4Bf=AogB_bXHLZ03tOYp2N5LL=JYH--Y3Yq4qow@mail.gmail.com>
References: <1398981150-27765-1-git-send-email-sp@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:48625 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbaEEWa4 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 5 May 2014 18:30:56 -0400
Received: by mail-la0-f45.google.com with SMTP id c6so1010860lan.18
        for <linux-bcache@vger.kernel.org>; Mon, 05 May 2014 15:30:54 -0700 (PDT)
In-Reply-To: <1398981150-27765-1-git-send-email-sp@daterainc.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

2014-05-02 1:52 GMT+04:00 Slava Pestov <sp@datera.io>:
> There were two issues here:
>
> - writeback thread did not start until the device first became dirty
> - writeback thread used uninterruptible sleep once running
>
> Without this patch I see kernel warnings printed and a load average of
> 1.52 after booting my test VM. With this patch the warnings are gone and
> the load average is near 0.00 as expected.

I've tried this patch and it has indeed fixed [1]! Thanks!

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=69471
