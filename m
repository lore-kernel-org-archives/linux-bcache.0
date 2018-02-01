From: tang.junhui@zte.com.cn
Subject: Re: [PATCH 2/2] bcache: fix high CPU occupancy during journal
Date: Thu, 1 Feb 2018 11:25:35 +0800
Message-ID: <1517455535-17027-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: mlyle@lyle.org
Cc: colyli@suse.de, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn
List-Id: linux-bcache@vger.kernel.org

From: Tang Junhui <tang.junhui@zte.com.cn>


> Unfortunately, this doesn't build because of nonexistent call heap_empty
> (I assume some changes to util.h got left out).  I really need clean
> patches that build and are formatted properly.
> 
> Mike
Oh, I am so sorry for that. A new version patch on road.
I will be more careful for later patches.

Thanks.
Tang Junhui
