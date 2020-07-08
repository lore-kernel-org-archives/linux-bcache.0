From: Stefan K <shadow_7@gmx.net>
Subject: how does the caching works in bcachefs
Date: Wed, 08 Jul 2020 23:46:00 +0200
Message-ID: <2308642.L3yuttUQlX@t460-skr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58307 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgGHVqB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Jul 2020 17:46:01 -0400
Received: from t460-skr.localnet ([88.78.23.144]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MjjCF-1kdIp92h4N-00lDBg for
 <linux-bcache@vger.kernel.org>; Wed, 08 Jul 2020 23:46:00 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

short question: how does the caching works with bcachefs? Is it like  "first in first out" or is it more complex like the ARC system in zfs? The same with the write-cache,  will be everything written to the SSD/NVMe (Cache) and then to the HDD? When will will the filesystem say "its written to disk"? And what happens with the data on the write cache if we have a powerfail?

And can I say have this file/folder always in the cache, while it works "normal" ?

Thanks in advance!
best regards
Stefan
