From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: finish incremental GC
Date: Mon, 29 Jan 2018 20:16:24 +0800
Message-ID: <ed937ba2-63b3-f4ee-b900-8fec8fcba412@suse.de>
References: <1517227093-25602-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517227093-25602-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 29/01/2018 7:58 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> In GC thread, we record the latest GC key in gc_done, which is expected
> to be used for incremental GC, but in currently code, we didn't realize
> it. When GC runs, front side IO would be blocked until the GC over, it
> would be a long time if there is a lot of btree nodes.
> 
> This patch realizes incremental GC, the main ideal is that, when there
> are front side I/Os, after GC some nodes (100), we stop GC, release locker
> of the btree node, and go to process the front side I/Os for some times
> (100 ms), then go back to GC again.
> 
> By this patch, when we doing GC, I/Os are not blocked all the time, and
> there is no obvious I/Os zero jump problem any more.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

Hi Junhui,

It sounds great :-) Currently I am not very familiar with gc code, I
need some time to understand how bcache GC works before providing my
feedback. Please give me some time, I hope I am able to provide my
comment after Chinese Spring Festival.

Hope other people may have a look before I am able to.

Thanks.

Coly Li



[code snip]
