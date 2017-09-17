From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH] bcache: option for recovery from staled data
Date: Sun, 17 Sep 2017 10:43:41 +0100
Message-ID: <87r2v5mzhu.fsf@esperi.org.uk>
References: <20170909175621.9705-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:45206 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdIQKZD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 Sep 2017 06:25:03 -0400
In-Reply-To: <20170909175621.9705-1-colyli@suse.de> (Coly Li's message of
        "Sun, 10 Sep 2017 01:56:21 +0800")
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kai Krakow <hurikhan77@gmail.com>, Eric Wheeler <bcache@lists.ewheeler.net>, Junhui Tang <tang.junhui@zte.com.cn>, stable@vger.kernel.org

On 9 Sep 2017, Coly Li spake thusly:

> When bcache does read I/Os, for example in writeback or writethrough mode,
> if a read request on cache device is failed, bcache will try to recovery
> the request by reading from cached device. If the data on cached device is
> not synced with cache device, then requester will get a staled data.
>
> For critical storage system like database, recovery from staled data may
> result an application level data corruption, which is unacceptible. But
> for some other situation like multi-media stream cache, continuous service
> may be more important and it is acceptible to fetch a staled chunk of data.
>
> This patch tries to solve the above conflict by adding a sysfs option
> 	/sys/block/bcache<idx>/bcache/recovery_from_staled_data
> which is defaultly cleared (to 0) as disabled. Now people can make choices
> for different situations.

'Staled' is not a word, though perhaps it should be. You probably want
to call it recovery_from_stale_data. But given the description below...

> With this patch, for a failed read request in writeback or writethrough
> mode, recovery a recoverable read request only happens in one of the
> following conditions,
>  - dc->has_dirty is zero. It means all data on cache device is synced to
>    cached device, the recoveried data is up-to-date. 
>  - dc->has_dirty is non-zero, and dc->recovery_from_staled_data is set
>    to 1. It means there is dirty data not synced to cached device yet, but
>    option recovery_from_staled_data is set, receiving staled data is
>    explicitly acceptible for requester.

... this name is also unclear. It sounded to me like it was an option
that recovers *from* stale data (as if the stale data was a problem to
recover from), not an option that uses stale data to *allow* recovery.

Perhaps, instead, something like stale_data_permitted or
allow_stale_data_on_failure would be better?

-- 
NULL && (void)
