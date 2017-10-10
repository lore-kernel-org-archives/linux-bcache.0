From: tang.junhui@zte.com.cn
Subject: Re: [PATCH] bcache: fix race in setting bdev state
Date: Tue, 10 Oct 2017 13:38:30 +0800
Message-ID: <1507613910-1156-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Mike:

> How did you find this?  Did the race trigger at detach or was it through 
> code inspection?
I find this through code inspection.

> I need to analyze this more.  It looks correct on its own, but there are 
> a lot of atomic variables and the way they are used is complicated.
> 
> I'm inclined to think that detach should traverse the writeback lock for 
> safety.  It would be a lot less complicated to analyze what would 
> happen.  What do you think?
As Far as now, except this issue, I can't see any more race during detach,
so I don't think we need to take a writeback lock. Could you please show me 
what problem you worried about?

Regards,
Tang
