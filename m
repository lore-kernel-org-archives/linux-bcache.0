From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: 3.18.3 + latest bcache-dev
Date: Wed, 21 Jan 2015 00:00:17 -0800
Message-ID: <CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
References: <20150121012424.GB5533@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59051 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbbAUIAS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 21 Jan 2015 03:00:18 -0500
Received: by mail-wi0-f171.google.com with SMTP id l15so22996363wiw.4
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jan 2015 00:00:17 -0800 (PST)
In-Reply-To: <20150121012424.GB5533@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Try increasing btree_scan_ratelimit?

On Tue, Jan 20, 2015 at 5:24 PM, Stephen R. van den Berg <srb@cuci.nl> wrote:
> I have:
> 16GB RAM
> 16GB SSD swap
> 5 x 6TB HDD bcache backing storage
> 2 x 490GB SSD bcache cache (Crucial M550, 4KB block, 2M bucket size)
> writeback and trim enabled on bcache.
> I used the latestbcache tools from git.
>
> On the backing storage, I created a BTRFS using nossd and notrim.
>
> Now, whenever I boot, I end up with exactly 4 bcache_writebac
> processes pegged at  99 or 100% CPU.  This is on an octocore cpu.
> top shows it as 50% system time.  The four processes are marked as R,
> but I cannot trace them.
>
> Even after waiting for several minutes, the cpu load does not come down.
> The mounted volume simply seems to work, though.
>
> Any ideas?
> --
> Stephen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
