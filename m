From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Tue, 06 Jan 2015 23:18:10 +0100
Message-ID: <54AC5F22.6040200@rolffokkens.nl>
References: <20141228023534.GA25860@cuci.nl>	<CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>	<54A81B78.2070409@rolffokkens.nl>	<20150104004621.GA4460@kmo-pixel>	<54A94A1C.9050906@rolffokkens.nl> <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:56835 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbbAFWSN (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 6 Jan 2015 17:18:13 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so128722wes.30
        for <linux-bcache@vger.kernel.org>; Tue, 06 Jan 2015 14:18:12 -0800 (PST)
In-Reply-To: <CACHGV4KV-y3JD=i6jy_0jaapZYBKxOYr1+PL=0dsAe+M83Y_Ew@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: Kent Overstreet <kmo@daterainc.com>, "Stephen R. van den Berg" <srb@cuci.nl>, linux-bcache@vger.kernel.org

On 01/05/2015 08:47 AM, Slava Pestov wrote:
> The plan is to incrementally backport bug fixes and optimizations from 
> bcache-dev to upstream for the foreseeable future.
I assume (hope) this won't break bcache w.r.t. the current block device 
layout?
> The development branch is going through major changes to support 
> dynamically adding/removing cache devices
Sound nices, that creates great flexibility. Does this also introduce 
the option of storing mirrored writeback data, while storing single copy 
read (cached) data (when having multiple SSD's as a cache)?
> and storing data in the btree instead of using it as a cache, enabling 
> usage without any backing devices.
The needs some explanation. I assume you mean it operates as writeback 
bache that never flushes. If that's correct, I can only imagine it's 
useful when initially using it. And in that case seems a kind of a time 
bomb, because when it's "full" (and there's still no backing device)... 
what happens then?
> We're actively working on this code and doing a lot of stress testing 
> of both the new stuff and backing device support. However, it's its 
> too early to tell what the new features will look like by the time 
> they're ready to go upstream, or what a transition plan will look like 
> for existing installs. I wish we had more time for upstreaming stuff, 
> but I can assure you its not Kent's intent to just dump bcache-dev as 
> one huge pull request :-) 
As an ethousiastic bcache user myself I would be very happy if there's a 
transition plan! :-)

Out of curiosity, will the backing device layout in general change, or 
will specifically the superblock change? If it's 'only' the superblock 
(and not it's size) I can imagine a feasable migration.

Rolf
