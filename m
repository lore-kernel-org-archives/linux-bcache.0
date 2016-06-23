From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/3] bcache: documentation updates and corrections
Date: Thu, 23 Jun 2016 07:57:48 -0600
Message-ID: <20160623075748.3973d875@lwn.net>
References: <S1754502AbcFPR0j/20160616172639Z+54@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:43427 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbcFWN54 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 23 Jun 2016 09:57:56 -0400
In-Reply-To: <S1754502AbcFPR0j/20160616172639Z+54@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Fri, 11 Mar 2016 23:04:19 -0800
Marc MERLIN <marc@merlins.org> wrote:

> Bcache documentation updates:
> - Added new HOWTO/COOKBOOK section
> - fixed a few typos
> - /sys/block/bcache0/cache_mode is /sys/block/bcache0/bcache/cache_mode
> 
> Signed-off-by: Marc MERLIN <marc@merlins.org>
> Cc: stable@vger.kernel.org

Applied (finally!) to the docs tree.  I took out the stable tag, though;
I don't think it really meets the stable tree rules.

Thanks,

jon
