From: YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH -next] bcache: Fix potential NULL pointer dereference
Date: Fri, 1 Feb 2019 10:36:44 +0800
Message-ID: <853cf0ed-330e-8e09-394d-b6a4fc7c5528@huawei.com>
References: <20190130102112.11228-1-yuehaibing@huawei.com>
 <20190130105817.GA12598@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130105817.GA12598@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: colyli@suse.de, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>
List-Id: linux-bcache@vger.kernel.org

On 2019/1/30 18:58, Kent Overstreet wrote:
> On Wed, Jan 30, 2019 at 06:21:12PM +0800, YueHaibing wrote:
>> There is a potential NULL pointer dereference in case
>> kzalloc() fails and returns NULL.
>>
>> Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/md/bcache/request.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index 1507041..a50afa4 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -1094,6 +1094,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
>>  	 * which would call closure_get(&dc->disk.cl)
>>  	 */
>>  	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
>> +	if (!ddip)
>> +		return;
>>  	ddip->d = d;
>>  	ddip->start_time = jiffies;
>>  	ddip->bi_end_io = bio->bi_end_io;
> 
> This should be using a mempool/bioset... just returning from a make_request
> function is not correct, that's a serious bug - you're just dropping an IO on
> the floor, which is going to cause whatever submitted that IO to hang.


How about this:

         * which would call closure_get(&dc->disk.cl)
         */
        ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+       if (!ddip) {
+               bio->bi_status = BLK_STS_RESOURCE;
+               bio_endio(bio);
+               return;
+       }
        ddip->d = d;
        ddip->start_time = jiffies;
        ddip->bi_end_io = bio->bi_end_io;

> 
> 
