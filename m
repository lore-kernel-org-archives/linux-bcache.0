From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Tiering in bcachefs
Date: Mon, 12 Sep 2016 18:17:11 -0800
Message-ID: <20160913021711.oxowdbp2sim5xwaq@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34230 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbcIMCRP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Sep 2016 22:17:15 -0400
Received: by mail-pf0-f177.google.com with SMTP id p64so58473788pfb.1
        for <linux-bcache@vger.kernel.org>; Mon, 12 Sep 2016 19:17:15 -0700 (PDT)
Received: from kmo-pixel (213-168-42-72.gci.net. [72.42.168.213])
        by smtp.gmail.com with ESMTPSA id p74sm27199464pfk.68.2016.09.12.19.17.12
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Sep 2016 19:17:13 -0700 (PDT)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Just wrote a long post explaining all about tiering in bcachefs:

https://www.patreon.com/posts/all-about-6751413

Also, tiering should now be working! I'd appreciate help testing it.

Notes:

Chris Halse Rogers (RAOF in the #bcache IRC channel) has been testing it. He has
been seeing an intermittent deadlock while copying large amounts of data, which
may or may not be tiering related: if anyone else hits it, I'd really appreciate
if you could grab backtraces. Do a "echo t > /proc/sysrq-trigger" and then grab
the full dmesg log - that should be enough to figure out what the deadlock is.

I haven't gotten to device add/remove yet, don't try it - you'll need to create
a new filesystem:

bcache format --tier 0 <SSD> --tier 1 <HDD>

Also, if you've already been playing with tiering, I highly recommend you create
a new filesystem. One of the bugs was an issue with which pointers are
considered dirty - in an extent with a tier 0 pointer and a tier 1 pointer, the
tier 0 pointer was being considered dirty instead of the tier 1 pointer (with
predictably bad consequences; tier 0 would fill up because the tiering thread
wasn't actually making anything on tier 0 clean). On a fixed kernel, as extents
are migrated it'll end up fixing which pointers are considered dirty which may
or may not trigger assertions as which pointers are considered dirty changes.
