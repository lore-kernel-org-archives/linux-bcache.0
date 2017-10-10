From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] [PATCH v3] bcache: gc does not work when triggering by
 manual
Date: Mon, 9 Oct 2017 20:32:38 -0700
Message-ID: <88e9ac51-bae7-55c7-8c89-56107c8a01e9@lyle.org>
References: <1507603489-30999-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1507603489-30999-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 10/09/2017 07:44 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> I try to execute the following command to trigger gc thread:
> [root@localhost internal]# echo 1 > trigger_gc
> But it does not work, I debug the code in gc_should_run(), It works only
> if in invalidating or sectors_to_gc < 0. So set sectors_to_gc to -1 to
> meet the condition when we trigger gc by manual command.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

Reviewed-by: Michael Lyle <mlyle@lyle.org>

Thanks!   -mpl
