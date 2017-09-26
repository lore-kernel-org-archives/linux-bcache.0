From: Coly Li <colyli@suse.de>
Subject: [PATCH 0/1] bcache fix for 4.14-rc4
Date: Tue, 26 Sep 2017 17:54:11 +0800
Message-ID: <20170926095412.74028-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49370 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967843AbdIZJyV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 05:54:21 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Coly Li <colyli@suse.de>

Hi Jens,

Michael Lyle catches a race bug in bcache 4.14 patch set. Here is the fix
for this issue. Could you please to pick it for 4.14-rc4 ? Then we don't need
to stable@vger.kernel.org in next cycle. 

Thanks in advance.

Coly Li
