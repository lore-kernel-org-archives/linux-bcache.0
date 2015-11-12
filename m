From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] bcache: register_bdev can fail, make it failable
Date: Thu, 12 Nov 2015 10:03:32 +0100
Message-ID: <1447319012.2616.9.camel@suse.de>
References: <1446650544-24411-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbbKLJDd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 12 Nov 2015 04:03:33 -0500
In-Reply-To: <1446650544-24411-1-git-send-email-jthumshirn@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, 2015-11-04 at 16:22 +0100, Johannes Thumshirn wrote:
> Registering a bcache can actually fail for some reasons, but
> register_bdev()
> assumes it to go all well. Make register_bdev() return errors to it's
> caller
> register_bcache().

Please retract that patch, I found a regression with it.
