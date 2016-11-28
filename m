From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 1/2] bcache: Remove redundant set_capacity
Date: Mon, 28 Nov 2016 08:51:41 +0800
Message-ID: <583B7F9D.3050208@huawei.com>
References: <1480037969-45042-1-git-send-email-wangyijing@huawei.com>
 <749db728-10d0-ab33-4587-9b6b0e98725e@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <749db728-10d0-ab33-4587-9b6b0e98725e@coly.li>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <i@coly.li>, axboe@fb.com, kent.overstreet@gmail.com
Cc: git@linux.ewheeler.net, colyli@suse.de, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org



在 2016/11/27 15:57, Coly Li 写道:
> On 2016/11/25 上午9:39, Yijing Wang wrote:
>> set_capacity() has been called in bcache_device_init(),
>> remove the redundant one.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/md/bcache/super.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 849ad44..b638a16 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1126,9 +1126,6 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
>>  	if (ret)
>>  		return ret;
>>  
>> -	set_capacity(dc->disk.disk,
>> -		     dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
>> -
>>  	dc->disk.disk->queue->backing_dev_info.ra_pages =
>>  		max(dc->disk.disk->queue->backing_dev_info.ra_pages,
>>  		    q->backing_dev_info.ra_pages);
>>
> 
> Hi Yijing,
> 
> Nice catch, it looks good to me.
> 
> Acked-by: Coly Li <colyli@suse.de>

Thanks!

> 
