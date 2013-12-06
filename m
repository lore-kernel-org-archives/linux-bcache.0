From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: bcache refusing to come up again after a crash
Date: Fri, 6 Dec 2013 16:45:12 +0100
Message-ID: <20131206154512.GI1848@teapot>
References: <20131206144117.GA24123@samfundet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41279 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab3LFPpl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 6 Dec 2013 10:45:41 -0500
Content-Disposition: inline
In-Reply-To: <20131206144117.GA24123@samfundet.no>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-bcache@vger.kernel.org

On Fri, Dec 06, 2013 at 03:41:17PM +0100, Steinar H. Gunderson wrote:
> Hi,
> 
> Linux (3.12.0-rc5) hung, and on boot, I can't get the bcache up again:
> 
> (initramfs) echo 0 23440891904 cache /dev/cache/metadata /dev/cache/blocks /dev/md1 1024 1 writeback default 4 random_threshold 8 sequential_threshold 512 | dmsetup create cache -u CACHE-0a8bb56fc873c195bf7117af925c7f08
> device-mapper: reload ioctl on cache failed: Input/output error

sorry I can't provide help on that. BTW this looks like dm-cache, not
bcache.

Matthias
