From: Tim Small <tim@buttersideup.com>
Subject: Re: [PATCH] bcache: Fix writeback_thread never writing back incomplete
 stripes.
Date: Thu, 01 Oct 2015 10:01:42 +0100
Message-ID: <560CF676.6020102@buttersideup.com>
References: <20150905111012.GA17180@suse.com> <20150916113206.GA16164@kmo-pixel> <CAO2mnozhTeuWwxsmQZor93xmyS5_r34YpGXy0ec=9vFCBGbO1w@mail.gmail.com> <CAO2mnowurDEfqaZZk6MLmCtTFJ4MkgGEG9DKYytwkDSv1W4dnQ@mail.gmail.com> <20150917164054.GA28032@kmo-pixel> <20150917183154.GB28032@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.251.4]:36556 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383AbbJAJil (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 1 Oct 2015 05:38:41 -0400
In-Reply-To: <20150917183154.GB28032@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On 17/09/15 19:31, Kent Overstreet wrote:
> Here's an updated patch that has a fix for _that_ theory, and also a new
> BUG_ON(). Any chance you could test it?

I've applied your patch (to the Ubuntu 4.2.1 tree - since I need some of
their non-mainline apparmour changes on this box) , and it's stopped the
excessive CPU usage by the bcache_writebac thread.

I'd first experienced this CPU spinning when I tried to disable cache
usage (I'd had some lockups on the machine and I was trying to get to
debug, so I tried switching bcache cache_mode to none whilst I debugged
as part of my process of elimination).  I assume the bug was hit whilst
trying to flush the dirty cache data.

I now have:

root@magic:~# cat /sys/block/bcache0/bcache/state
clean
root@magic:~# cat /sys/block/bcache0/bcache/dirty_data
1.5M
root@magic:~# cat /sys/block/bcache0/bcache/cache_mode
writethrough writeback writearound [none]
root@magic:~# uname -a
Linux magic 4.2.1 #2 SMP Sat Sep 26 10:00:40 UTC 2015 x86_64 x86_64
x86_64 GNU/Linux

i.e. state and cache_mode are inconsistent with dirty_data.  Is this of
any concern and/or likely to cause problems if I re-enable the cache?

Cheers,

Tim.
