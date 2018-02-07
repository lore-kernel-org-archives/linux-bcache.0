From: Michael Lyle <mlyle@lyle.org>
Subject: Bcache patches for inclusion in 4.16
Date: Wed,  7 Feb 2018 11:41:38 -0800
Message-ID: <20180207194146.5095-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:32900 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbeBGTlx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Feb 2018 14:41:53 -0500
Received: by mail-pf0-f174.google.com with SMTP id u15so771826pfa.0
        for <linux-bcache@vger.kernel.org>; Wed, 07 Feb 2018 11:41:53 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@fb.com

Hi Jens---

Here are a few more changes for 4.16 from Coly Li and Tang Junhui.

Probably the most "functional" is 2/8, which makes a change to improve a
performance bug under sustained small writes.  Still, it's a small, safe
change that seems good to take.  The rest are small bugfixes.

All have seen some degree of test (which is, of course, always ongoing).

Note that there's one checkpatch error in this, but it was already present
and is just triggered by altering an adjacent line.

 9 files changed, 111 insertions(+), 36 deletions(-)

Coly Li (3):
      bcache: properly set task state in bch_writeback_thread()
      bcache: set error_limit correctly
      bcache: set writeback_rate_update_seconds in range [1, 60] seconds

Tang Junhui (5):
      bcache: add journal statistic
      bcache: fix high CPU occupancy during journal
      bcache: fix for allocator and register thread race
      bcache: return attach error when no cache set exist
      bcache: fix for data collapse after re-attaching an attached device

Thanks, as always,

Mike
