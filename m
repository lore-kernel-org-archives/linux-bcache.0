From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: use kmemdup_nul for CACHED_LABEL buffer
Date: Tue, 26 Feb 2019 19:03:41 +0800
Message-ID: <44f39202-6dca-eb25-f8ca-60ca000503f1@suse.de>
References: <04ff7c6d5cdd8b389d471989704c2f9dc3def554.1548840161.git.geliangtang@gmail.com>
 <04ebd070-3c9c-0cd4-f2d8-d7b078ea2582@suse.de>
 <20190226100102.GA10363@OptiPlex>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190226100102.GA10363@OptiPlex>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2019/2/26 6:01 下午, Geliang Tang wrote:
> On Wed, Feb 06, 2019 at 04:37:36PM +0800, Coly Li wrote:
>> On 2019/1/30 5:29 下午, Geliang Tang wrote:
>>> This patch uses kmemdup_nul to create a NUL-terminated string from
>>> dc->sb.label. This is better than open coding it.
>>>
>>> With this, we can move env[2] initialization into env[] array to make
>>> code more elegant.
>>>
>>> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
>>
>> Hi Geliang,
>>
>> In general I am OK with your idea. But I feel there might be some
>> regression with your change. I comment your patch in line, correct me if
>> I am wrong.
>>
>>
>>> ---
>>>  drivers/md/bcache/super.c | 10 ++++------
>>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>> index 4dee119c3664..84ab241c8516 100644
>>> --- a/drivers/md/bcache/super.c
>>> +++ b/drivers/md/bcache/super.c
>>> @@ -906,21 +906,18 @@ static int cached_dev_status_update(void *arg)
>>>  void bch_cached_dev_run(struct cached_dev *dc)
>>>  {
>>>  	struct bcache_device *d = &dc->disk;
>>> -	char buf[SB_LABEL_SIZE + 1];
>>> +	char *buf = kmemdup_nul(dc->sb.label, SB_LABEL_SIZE, GFP_KERNEL);
>>
>> If kdumdup_null() is failed, buf will be NULL.
>>
>>>  	char *env[] = {
>>>  		"DRIVER=bcache",
>>>  		kasprintf(GFP_KERNEL, "CACHED_UUID=%pU", dc->sb.uuid),
>>> -		NULL,
>>> +		kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf ? : ""),
>>
>> If buf is NULL, env[2] here is pointed to "" which is allocated in
>> read-only data segment, and not a dynamic memory.
> 
> Hi Coly,
> 
> Sorry for my late reply.
> 
> If buf is NULL, env[2] is kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", "");

Oh, I overlooked the location of last bracket.


> In this case, env[2] is also a dynamic memory, a string like this, "CACHED_LABEL=".
> So we can use kfree() to free it. There is no problem.
> 

Sure, it is OK to me. I will add it into my for-test directory.

Thanks.

Coly Li

> And here is a test case:
> 
> $ cat test.c 
> #include <linux/init.h>
> #include <linux/module.h>
> #include <linux/slab.h>
> 
> static int __init test_init(void)
> {
> 	char *env = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", "");
> 	pr_info("env = [%s]\n", env);
> 	kfree(env);
> 	return 0;
> }
> 
> static void __exit test_exit(void)
> {
> }
> 
> module_init(test_init);
> module_exit(test_exit);
> 
> MODULE_LICENSE("GPL");
> 
> $ sudo insmod test.ko
> $ dmesg
> [ 3026.072298] env = [CACHED_LABEL=]
> $ sudo rmmod test
> 
> Thanks.
> 
> -Geliang
> 
>>
>>>  		NULL,
>>>  	};
>>>  
>>> -	memcpy(buf, dc->sb.label, SB_LABEL_SIZE);
>>> -	buf[SB_LABEL_SIZE] = '\0';
>>> -	env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);
>>> -
>>>  	if (atomic_xchg(&dc->running, 1)) {
>>>  		kfree(env[1]);
>>>  		kfree(env[2]);
>>
>> Then kfree() here will try to release a read-only memory segment. I
>> guess this is problematic.
>>
>>> +		kfree(buf);
>>>  		return;
>>>  	}
>>>  
>>> @@ -944,6 +941,7 @@ void bch_cached_dev_run(struct cached_dev *dc)
>>>  	kobject_uevent_env(&disk_to_dev(d->disk)->kobj, KOBJ_CHANGE, env);
>>>  	kfree(env[1]);
>>>  	kfree(env[2]);
>>
>> Same problem might happen here for env[2].
>>
>>> +	kfree(buf);
>>>  
>>>  	if (sysfs_create_link(&d->kobj, &disk_to_dev(d->disk)->kobj, "dev") ||
>>>  	    sysfs_create_link(&disk_to_dev(d->disk)->kobj, &d->kobj, "bcache"))
>>>
>>
>>
>> -- 
>>
>> Coly Li
> 


-- 

Coly Li
