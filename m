From: =?utf-8?B?TWljaGVsZQ==?= <mik.linux@gmail.com>
Subject: =?utf-8?B?YmNhY2hlIG9uIHNoYXJlZCBzdG9yYWdl?=
Date: Sun, 25 Sep 2016 21:36:56 +0200
Message-ID: <ns990l$c9$1@blaine.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60387 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1759942AbcIYTkP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 25 Sep 2016 15:40:15 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glbd-linux-bcache@m.gmane.org>)
        id 1boFHS-00076O-TB
        for linux-bcache@vger.kernel.org; Sun, 25 Sep 2016 21:40:06 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello everybody,

I have a KVM virtualization cluster (3 nodes) which shares the same storage. It would be possible to attach a caching device on each node to that storage?

Let me explain better: I intend to create a raid-0 with two SSDs  on each node as WT caching devices, then initialize the shared storage as bcache backing device, and then attach the caching device on each node to it.

Is this going to work?

Thanks,
Michele


--
Newsy for iOS
Download on the App Store:
https://itunes.apple.com/app/newsy/id598711199
