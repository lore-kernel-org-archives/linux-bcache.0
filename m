From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Can usb pen drives be used as read-cache for a HDD?
Date: Sun, 13 Jul 2014 14:42:13 +0200
Message-ID: <CAFvQSYRaL63-kZQMnx5oyZFcxH0HwWS7+PrB5QJnfb0DbzkWhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47304 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaGMMmN (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 13 Jul 2014 08:42:13 -0400
Received: by mail-vc0-f177.google.com with SMTP id ij19so5234685vcb.8
        for <linux-bcache@vger.kernel.org>; Sun, 13 Jul 2014 05:42:13 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

A friend of mine uses an old P4 based laptop for email and web browsing.
Thanks to zram, I was able to reduce swapping to disk - however with
just 512mb ram there is not a lot space for the page cache so the disk
is frequently active re-reading data which would stay in pagecache
otherwise.

Would it make sence to use an old usb pen drive - or even two of them
- as read-cache in writearound mode?
Those pen drives usually suffer from very low random write throughput,
but usually offer arround ~1000IOps for 4k random reads and ~20mb/s
sequentially.
Even if they would die within a few months, I have dozens of them and
data integrity shouldn't be compromized with writearound mode.

Does bcache wait for the caching device (stall the read-in-progres)
when filling the cache by writing to the caching device?
In case the caching device isn't respondig in time (writes to cheap
pen block the device for ~500ms), is bcache able to read from the hdd
instead?

Thank you in advance, Clemens
