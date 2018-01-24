From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH v3 00/13] bcache: device failure handling improvement
Date: Wed, 24 Jan 2018 22:23:19 +0000
Message-ID: <87po5ykiaw.fsf@esperi.org.uk>
References: <20180114144236.28213-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:35572 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932902AbeAXXZC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Jan 2018 18:25:02 -0500
In-Reply-To: <20180114144236.28213-1-colyli@suse.de> (Coly Li's message of
        "Sun, 14 Jan 2018 22:42:23 +0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 14 Jan 2018, Coly Li said:

> Hi maintainers and folks,
>
> This patch set tries to improve bcache device failure handling, includes
> cache device and backing device failures.
>
> The basic idea to handle failed cache device is,
> - Unregister cache set
> - Detach all backing devices which are attached to this cache set
> - Stop all the detached bcache devices
> - Stop all flash only volume on the cache set
> The above process is named 'cache set retire' by me. The result of cache
> set retire is, cache set and bcache devices are all removed, following
> I/O requests will get failed immediately to notift upper layer or user
> space coce that the cache device is failed or disconnected.

This feels wrong to me. If a cache device is writethrough, the cache is
a pure optimization: having such a device fail should not lead to I/O
failures of any sort, but should only flip the cache device to 'none' so
that writes to the backing store simply don't get cached any more.

Anything else leads to a reliability reduction, since in the end cache
devices *will* fail.

-- 
NULL && (void)
