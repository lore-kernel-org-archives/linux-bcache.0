From: tang.junhui@zte.com.cn
Subject: Re: Re: [PATCH] bcache: add a separate open bucket list for flash devices
Date: Tue, 21 Nov 2017 19:12:15 +0800
Message-ID: <1511262735-9169-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mxhk.zte.com.cn ([63.217.80.70]:46652 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751772AbdKULMb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Nov 2017 06:12:31 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: kent.overstreet@gmail.com, colyli@suse.de, mlyle@lyle.org
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

On Tue, Nov 21, 2017 at 06:50:32PM +0800, tang.junhui@zte.com.cn wrote:
> > From: Tang Junhui <tang.junhui@zte.com.cn>
> > 
> > Currently in pick_data_bucket(), though we keep multiple buckets open
> > for writes, and try to segregate different write streams for better
> > cache utilization: first we look for a bucket where the last write to
> > it was sequential with the current write, and failing that we look
> > for a bucket that was last usedby the same task.
> > 
> > But actually, in such scenario that there are some flash devices
> > , and some backend bcache devices, when many tasks request these
> > flash devices and backend bcache devices, the write IOs may still
> > fall to the same bucket as bellow bucket:
> > | bcache data | flash data | bcache data | bcache data| flash data|
> > then after writeback of these backend bcache devices, the bucket would
> > be like bellow bucket:
> > | free | flash data | free | free | flash data |

> This patch doesn't make any sense - open_buckets are only for allocations and
> writes to the SSD.

Thank you for your quick respond, It's true that open_buckets are only for 
allocations and writes to the SSD, but in writeback mode, data from flash 
devices and backend bcache devices are all write to bucket(SSD). This patch add 
a separate open bucket list for flash devices, so data from flash devices 
and backend bcache devices can store in different buckets. 

Thanks,
Tang
