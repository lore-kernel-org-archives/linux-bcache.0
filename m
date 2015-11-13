From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Fri, 13 Nov 2015 13:37:25 +0100
Message-ID: <1447418245.2616.15.camel@suse.de>
References: <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbbKMMh1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 Nov 2015 07:37:27 -0500
In-Reply-To: <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yannis Aribaud <bugs@d6bell.net>, linux-bcache@vger.kernel.org

Hi Yannis,
On Fri, 2015-11-13 at 12:09 +0000, Yannis Aribaud wrote:
> Hi,
> 
> I recently tried bcache on a vanilla 4.1.12 kernel and got those
> strange soft lockup issues.
> This happens at the system shutdown only but not every time, thus I
> suppose that it's related to bcache devices stopping.
> 
> My setup use 3 bcache devices each using dedicated hardware devices
> (1 HDD and 1 SSD), cache_mode is writeback and bucket/block sizes are
> the default ones.
> 
> I saw that a similar problem was solved in 3.17 so maybe it's a
> regression.

do you have a stacktrace, so we can see where it's locking up?

Thanks,
Johannes
