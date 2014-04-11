From: Thorkild Stray <thorkild.stray@cxense.com>
Subject: Re: Stale bcache (writethrough) leading to cache being disabled.
Date: Fri, 11 Apr 2014 03:10:30 +0200
Message-ID: <CAJ0Z65y1fcszQXChAjbH72VCOYxsQzAhP6U=_X428mMZHsNBVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56709 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbaDKBKa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 10 Apr 2014 21:10:30 -0400
Received: by mail-vc0-f179.google.com with SMTP id ij19so4105669vcb.38
        for <linux-bcache@vger.kernel.org>; Thu, 10 Apr 2014 18:10:30 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

On Wed, Apr 9, 2014 at 6:05 AM, Thorkild Stray
<thorkild.stray@cxense.com> wrote:
> The specific kernel message when it disables itself is:
> 2014-03-25T23:55:03.525100+00:00 machine1 kernel: [6822460.984018] bcache: error on 5acb2ff8-db07-4d13-a6ca-dbfdbf1d87eb:
> key too stale: 97, need_gc 97, disabling caching

Upgrading to the newly released 3.14 kernel (no extra patches) and
resetting the caching device solved this (first reset, then upgrade).

To reset the cache in a cleanly unmounted setup without having to
reformat the backing device (requirement that you have no data left
to write back - in my case we use write-through so no issue there), do:

1) De-attach and unregister the device. Take note of the identifier.
(I also unmounted it to avoid any problems)
2) Stop bcache (echoing 1 into /sys/block/bcache0/../stop )
3) Run make-bcache --cset-uuid <same uuid as before> -C <device> to
re-init it. Do not touch the backing device.

At this point you should get "run_cache_set() invalidating existing
data" in the dmesg-output. It'll auto-register the new caching-device,
but you still need to re-add the backing device and re-attach the bcache-set.

In my case, bcache had already politely disabled itself due to the
error, so I could skip many of the initial steps.

-- 
Thorkild
