From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PULL] Re: bcache stability patches
Date: Wed, 30 Dec 2015 18:15:00 -0900
Message-ID: <20151231031500.GA8265@kmo-pixel>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
 <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
 <56841B8B.6070306@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35849 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbbLaDPF (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 30 Dec 2015 22:15:05 -0500
Content-Disposition: inline
In-Reply-To: <56841B8B.6070306@kernel.dk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Al Viro <viro@zeniv.linux.org.uk>, Denis Bychkov <manover@gmail.com>, g2p.code@gmail.com, Jiri Kosina <jkosina@suse.com>, Joshua Schmid <jschmid@suse.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, Takashi Iwai <tiwai@suse.de>, Vojtech Pavlik <vojtech@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

On Wed, Dec 30, 2015 at 10:59:39AM -0700, Jens Axboe wrote:
> Looking over these, most are really simple one-liners, and nothing sticks
> out as being overly complicated. Kent, do you have any plans to maintain the
> in-kernel bcache?

Yeah - these patches are all fine, go ahead and pull.

I may start doing maintainence again at some point (but if there's someone
willing to step up and take over and do a good job of it, I'd gladly hand things
off)
