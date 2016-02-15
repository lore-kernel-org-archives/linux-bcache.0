From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: echo dev > /sys/fs/bcache/register gives page allocation
 failure: order:4, mode:0x2040d0
Date: Mon, 15 Feb 2016 03:11:04 -0900
Message-ID: <20160215121104.GA30514@kmo-pixel>
References: <20160215060410.GA30802@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35512 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbcBOMLI (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 15 Feb 2016 07:11:08 -0500
Received: by mail-pa0-f42.google.com with SMTP id ho8so86222995pac.2
        for <linux-bcache@vger.kernel.org>; Mon, 15 Feb 2016 04:11:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160215060410.GA30802@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Sun, Feb 14, 2016 at 10:04:10PM -0800, Marc MERLIN wrote:
> I was able to make one bcache ok, but when trying to make a 2nd one
> where I only have a backing device, I'm getting repeated page allocation
> failures.
> 
> Just to be clear, this is what I want to do: every new HD backed device
> will have bcache on top even if I don't have a cache device for it, so
> that I can add bcache later.
> Is it something reasonable to do? Setup partitions as bcache backing
> devices without a cache device for them?
> 
> So right now, I'm trying to do
> md5 - bcache - dmcrypt - btrfs
> 
> So I did
> make-bcache -B /dev/md5
> echo /dev/md5 > /sys/fs/bcache/register
> 
> and it fails:
> bash: page allocation failure: order:4, mode:0x2040d0

You want CONFIG_COMPACTION=y
