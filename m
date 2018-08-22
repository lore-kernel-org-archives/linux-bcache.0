From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] bcache: release dc->writeback_lock properly in
 bch_writeback_thread()
Date: Wed, 22 Aug 2018 12:13:12 -0600
Message-ID: <4aead749-ba4a-d5a3-d592-bff36e38d1b5@kernel.dk>
References: <20180822180256.15600-1-colyli@suse.de>
 <e44eebe7-a42c-f4f9-0f2f-e7d9135f8bff@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <e44eebe7-a42c-f4f9-0f2f-e7d9135f8bff@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Shan Hai <shan.hai@oracle.com>, stable@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 8/22/18 12:07 PM, Coly Li wrote:
> On 2018/8/23 2:02 AM, Coly Li wrote:
>> From: Shan Hai <shan.hai@oracle.com>
>>
>> The writeback thread would exit with a lock held when the cache device is
>> detached via sysfs interface, fix it by releasing the held lock before exiting
>> the while-loop.
>>
>> Fixes: fadd94e05c02 (bcache: quit dc->writeback_thread when BCACHE_DEV_DETACHING is set)
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Tested-by: Shenghui Wang <shhuiw@foxmail.com>
>> Cc: stable@vger.kernel.org #4.17+
>> ---
>> Changelog:
>> v2: add Fixes tag by Coly Li.
>> v1: initial patch from Shan Hai.
> 
> Hi Jens,
> 
> Please pick this patch for your next pull request. The change from Shan
> Hai fixes a real issue which is reported and lately verified by Shenghui
> Wang.

Applied - but I fixed up the commit message. Please keep lines at
72 characters for git commits.

-- 
Jens Axboe
