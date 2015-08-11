From: Ming Lin <mlin@kernel.org>
Subject: Re: [bcachefs] Mounting the same device multiple times now works
Date: Tue, 11 Aug 2015 10:59:42 -0700
Message-ID: <1439315982.19144.7.camel@ssi>
References: <20150811083453.GA29708@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50920 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbbHKR7r (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Tue, 11 Aug 2015 13:59:47 -0400
In-Reply-To: <20150811083453.GA29708@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Tue, 2015-08-11 at 00:34 -0800, Kent Overstreet wrote:
> Like in other filesystems, you can now do
> 
> mount /dev/sda1 /foo
> mount /dev/sda1 /bar
> 
> What this really means is that if the udev hook has registered the bcache device
> via the old style sysfs interface for caching, you'll still be able to mount the
> device like normal.

Thanks!

BTW, could you share the bcachefs long term development plans and short
term high priority tasks?

I'd like to pick something to work on. Probably the debugfs tool you
mentioned or other things?

> 
> Keep the bug reports coming!
