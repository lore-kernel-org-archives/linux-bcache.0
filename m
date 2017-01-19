From: Jan Wiele <jan@wiele.org>
Subject: Re: Hang in bcache/qemu
Date: Thu, 19 Jan 2017 13:22:47 +0100
Message-ID: <4700072.elc5RSLsh5@j-t460p>
References: <2059985.veGUll5WnS@j-t460p> <20170118043556.08485efe@jupiter.sol.kaishome.de> <20170118084830.GA3690@tuebingen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from fabrik17.de ([78.47.224.236]:56493 "EHLO mail.fabrik17.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751970AbdASMYC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 19 Jan 2017 07:24:02 -0500
Received: from j-t460p.localnet (unknown [134.147.202.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.fabrik17.de (Postfix) with ESMTPSA id 5ED3564014
        for <linux-bcache@vger.kernel.org>; Thu, 19 Jan 2017 13:22:30 +0100 (CET)
In-Reply-To: <20170118084830.GA3690@tuebingen.mpg.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Am Mittwoch, 18. Januar 2017, 09:48:30 CET schrieb Andre Noll:
> On Wed, Jan 18, 04:35, Kai Krakow wrote
> 
> FWIW, I'm seeing this as well on different hardware, and with both
> deadline and CFQ, so it's not a scheduler issue. The problem seems to
> be the bcache writeback thread calling down_write(&dc->writeback_lock)
> while already holding this lock.
Yes, the bug doesn't get triggered when the caching mechanism is set to 
writethrough.

Regards,
Jan
