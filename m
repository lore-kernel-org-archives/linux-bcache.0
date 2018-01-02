From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [for-416 PATCH] bcache: fix writeback target calc on large
 devices
Date: Tue, 2 Jan 2018 09:04:40 -0800
Message-ID: <e53d3218-d121-7bdb-005b-caa0732e1ea1@lyle.org>
References: <1514885112-12218-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1514885112-12218-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

I'm withdrawing this patch.  Reading the entire function more carefully,
I think the rate calculation is completely wrong both in the original
code and in this change.

That is, the top of __update_writeback_rate calculates a dirty data
target for one backing device.  However, the target for one backing
device is compared to the amount of dirty data in the entire cache.  If
there is more than one cache device, the writeback rate will be far too
high.

I will attempt to write a new version of this scaling functionality soon
that fixes both the overflow issue and ... corrects it to calculate the
correct thing.

Mike
