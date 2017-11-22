From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] [PATCH v2] bcache: segregate flash only volume write
 streams from cached devices
Date: Tue, 21 Nov 2017 20:53:38 -0800
Message-ID: <4a74de00-e2e8-41b2-7968-0bed6396847e@lyle.org>
References: <1511321129-20778-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1511321129-20778-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: tang.junhui@zte.com.cn, kent.overstreet@gmail.com, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

Tang Junhui---

On 11/21/2017 07:25 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> In such scenario that there are some flash only volumes
> , and some cached devices, when many tasks request these devices in
> writeback mode, the write IOs may fall to the same bucket as bellow:
> | cached data | flash data | cached data | cached data| flash data|
> then after writeback of these cached devices, the bucket would
> be like bellow bucket:
> | free | flash data | free | free | flash data |
> 
> So, there are many free space in this bucket, but since data of flash
> only volumes still exists, so this bucket cannot be reclaimable,
> which would cause waste of bucket space.
> 
> In this patch, we segregate flash only volume write streams from
> cached devices, so data from flash only volumes and cached devices
> can store in different buckets.
> 
> Compare to v1 patch, this patch do not add a additionally open bucket
> list, and it is try best to segregate flash only volume write streams
> from cached devices, sectors of flash only volumes may still be mixed
> with dirty sectors of cached device, but the number is very small.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

Thanks, this looks much better.  Can you please fix the whitespace
issues so it gets through checkpatch cleanly?

Mike
