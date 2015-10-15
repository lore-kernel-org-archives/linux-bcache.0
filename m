From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: Btrfs on bcache device: mount options?
Date: Thu, 15 Oct 2015 16:29:45 +0200
Message-ID: <20151015142945.GA10162@suse.com>
References: <87mvvk4718.fsf@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:50134 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbJOOzA (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 15 Oct 2015 10:55:00 -0400
Content-Disposition: inline
In-Reply-To: <87mvvk4718.fsf@gmx.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Simon Herter <sim.herter@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Thu, Oct 15, 2015 at 03:04:35PM +0200, Simon Herter wrote:

> I'm using btrfs on a bcache device and I'm a bit confused about mount
> options. For example, bcache may (if I understood correctly) bypass the
> cache completely for sequential access. So should I use "ssd" mount
> option or not? Are there any general recommendations?

No, you should not. It modifies the data layout behavior to ignore seek
times. These may be present when reading from the backing media.

You likely want to enable compression and autodefragmentation, too.
-- 
Vojtech Pavlik
Director SUSE Labs
