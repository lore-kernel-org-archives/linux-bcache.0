From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Re: journal replay at each boot problematic?
Date: Wed, 29 Mar 2017 14:27:11 +0200
Message-ID: <CAFvQSYT4Jy9tPJx5CxkLew05AUMMuLFKc0Z2KnARXh4fJf95+w@mail.gmail.com>
References: <CAFvQSYSTFPu9yPj-i2E+G53V_Auet8WTQk9q1vAUFQZe=VUWjQ@mail.gmail.com>
 <20170327225133.4aa977dd@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34133 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932132AbdC2M1N (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Mar 2017 08:27:13 -0400
Received: by mail-pg0-f44.google.com with SMTP id 21so10157436pgg.1
        for <linux-bcache@vger.kernel.org>; Wed, 29 Mar 2017 05:27:13 -0700 (PDT)
In-Reply-To: <20170327225133.4aa977dd@jupiter.sol.kaishome.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi Kai,

> As far as the docs tell, bcache is designed to shut down unclean. So
> this is expected behavior in write-back mode.

Yes, I also read it - but since I got a few btrfs fs errors when
running btrfs check (mostly space-cache related) I became a bit
alarmed.
As all csums are ok, so I don't think the backing/caching devices are
corrupt in any way.

> To cleanly detach a bcache, you would need to first put it in
> write-through or write-around mode and wait for write-back to finish.
> In turn, this mode should also avoid these messages at boot.

This is exactly what I do now before each shutdown: switch to
writethrough and wait in a bash-loop until state="clean" - sorrounded
by two calls to sync.
However, I still get the journal replay messages at bootup:

[    2.590615] bcache: bch_journal_replay() journal replay done, 827
keys in 37 entries, seq 145717


Br, Clemens
