From: tang.junhui@zte.com.cn
Subject: Re: Re: [PATCH 12/19] bcache: update bucket_in_use periodically
Date: Sat, 28 Oct 2017 09:37:38 +0800
Message-ID: <1509154658-31042-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:53532 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbdJ1BiD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 21:38:03 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: bcache@lists.ewheeler.net, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Eric

> > 
> > From my personal opinion, updating bucket_in_use is for acting garbage
> > collection. If number of bucket in use is not updated in time, garbage
> > collection won't start due to old bucket_in_use still beyond
> > CUTOFF_WRITEBACK_SYNC.
> > 
> > We may maintain an atomic counter per-cache set for dirty buckets, and
> > update it at some locations when allocating or reclaiming bucket. This
> > counter is unnecessary to be very accurate, just accurate enough for
> > should_writeback() working correctly.
> > 
> > I am also looking at it for a better solution as well.
> 
> Hi Coli & Tang,
> 
> Have either of you had a chance to come up with a solution to this?

This patch is updated by 
[PATCH] [PATCH V2] bcache: update bucket_in_use in real time
and it has been applied to Mike's tree. 

Regards,

Tang
