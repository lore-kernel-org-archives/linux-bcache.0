From: Coly Li <colyli@suse.de>
Subject: set max writeback rate when bcache device is idle
Date: Wed, 19 Jul 2017 13:36:13 +0800
Message-ID: <20170719053615.99305-1-colyli@suse.de>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46299 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751998AbdGSFgV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Jul 2017 01:36:21 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: bcache@lists.ewheeler.net, tang.junhui@zte.com.cn, kubuxu@ipfs.io

This patch set is an effort to make bcache writes back dirty data when
it is idle. Junhui Tang posted a fix days before, which IMHO has unstable
interfere to writeback rate PD controller. This is another approach for
same problem.

The first patch with subject "bcache: do not perform writeback if dirty
data is no more than writeback_percent" makes writeback_percent works as
designed. This patch is depended by the seconded patch.

The second patch with subject "bcache: implement
max_writeback_rate_when_idle option for writeback mode" implements an
option to set a maximum writeback rate when bcache device is idle. Then
dirty data can be wrote back to cached device and cleaned on cache device.
After cache set is cleaned, the following write requests on bcache device
won't trigger writeback unless dirty data exceeds writeback_percent.

Please review the patch set, any comment is welcome :-)

Thanks in advance.

Coly Li
