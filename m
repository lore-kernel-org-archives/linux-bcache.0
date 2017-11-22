From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v2] bcache: stop writeback thread after detaching
Date: Tue, 21 Nov 2017 23:13:01 -0800
Message-ID: <2f315b1c-1330-c9a0-0f3e-be4aa6221aba@lyle.org>
References: <1511331613-23140-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1511331613-23140-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Hi Tang Junhui--

Thank you.

On 11/21/2017 10:20 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> Currently, when a cached device detaching from cache, writeback thread is
> not stopped, and writeback_rate_update work is not canceled. For example,
> after bellow command:
> echo 1 >/sys/block/sdb/bcache/detach
> you can still see the writeback thread. Then you attach the device to the
> cache again, bcache will create another writeback thread, for example,
> after bellow command:
> echo  ba0fb5cd-658a-4533-9806-6ce166d883b9 > /sys/block/sdb/bcache/attach
> then you will see 2 writeback threads.
> This patch stops writeback thread and cancels writeback_rate_update work
> when cached device detaching from cache.
> 
> Compare with patch v1, this v2 patch moves code down into the register
> lock for safety in case of any future changes as Coly and mike suggested.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

Reviewed-by: Michael Lyle <mlyle@lyle.org>

I've added it to my staging tree.  Just one concern:
>  mode change 100644 => 100755 drivers/md/bcache/super.c

Your patches tend to have executable files in them, and I need to remove
these before they'll be accepted upstream.  I've fixed it this time, but
can you please be careful in the future?

Thanks,

Mike
