From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: INFO: task bcache_writebac:1582 blocked for more than 120 seconds
Date: Thu, 12 Jun 2014 02:35:11 +0700
Message-ID: <19010378287.20140612023511@pvgoran.name>
References: <CADUHXCchuOVOY7vKzo8OnFmJhQWz6=RyJvhrwJm3y_N300mC8w@mail.gmail.com>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from pvgoran2.xen.prgmr.com ([71.19.149.48]:35352 "EHLO
	v2.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKTkr (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 11 Jun 2014 15:40:47 -0400
In-Reply-To: <CADUHXCchuOVOY7vKzo8OnFmJhQWz6=RyJvhrwJm3y_N300mC8w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello Nik,

Wednesday, June 11, 2014, 9:48:20 PM, you wrote:

> I have been running bcache in writeback mode for a while, and had an
> unclean shutdown due to a power outage.  Machine rebooted, did an
> fsck, everything seemed ok, I had a few corrupt files that were open
> when the shutdown happened, but no major deal.  Then, I started
> getting hung tasks:

> INFO: task bcache_writebac:1582 blocked for more than 120 seconds.

This   looks   like   a   well-known   bug  that  manifests  itself  with  the
"bcache_writeback   locked"  messages.  It's  possible  that  your  cache  was
corrupted  and disabled because of this, and now the bcache_writeback task has
no  work to do and because of this the "locked" messages appear. (Personally I
get these messages when using a bcache device without cache.)

Bottom  line:  these  messages  probably  appear  because  bcache is *already*
disabled.

> How can I disable bcache for now?  The instructions to install it a
> pretty clear, but disabling it isn't.

Check whether cache is currently active:

cat /sys/block/bcache0/bcache/state

If it says "no cache", then there is no active cache on the bcache0 device. If
it says "clean", then the cache is there.

To  disable  bcache  for  the  device  bcache0 you need to issue the following
command:

echo "4faa930e-1983-45d3-ac40-e7dd0941d63c" | tee /sys/block/bcache0/bcache/detach

Substitute  "4faa930e-1983-45d3-ac40-e7dd0941d63c"  with  the ID of your cache
(you can find cache IDs by looking at the /sys/fs/bcache directory).

Pavel Goran
  
