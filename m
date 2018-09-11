From: zhong jiang <zhongjiang@huawei.com>
Subject: Re: [PATCH] bcache: remove unnecessary null poiner check in cache_set_free
Date: Tue, 11 Sep 2018 09:36:59 +0800
Message-ID: <5B971C3B.4070605@huawei.com>
References: <1536406766-27021-1-git-send-email-zhongjiang@huawei.com> <CA+NNRhEo-qryWzGoVbUtQVSbOhbTTwVuzAA7DYmTOcVN8oYehQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+NNRhEo-qryWzGoVbUtQVSbOhbTTwVuzAA7DYmTOcVN8oYehQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Junhui Tang <tang.junhui.linux@gmail.com>
Cc: colyli@suse.de, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org

On 2018/9/11 8:59, Junhui Tang wrote:
> This patch is NOT OK to me，maybe many cache in a  cache_set, and some
> cache are not registered yet, so ca is possible NULL.
 Yep,  It's my fault. please ingnore the patch.

 Thanks,
 zhong jiang
> zhong jiang <zhongjiang@huawei.com> 于2018年9月8日周六 下午7:52写道：
>> The iterator in for_each_cache is never null, therefore, remove
>> the redundant null pointer check.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/md/bcache/super.c | 11 +++++------
>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 94c756c..2d26f9e 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1513,12 +1513,11 @@ static void cache_set_free(struct closure *cl)
>>         bch_btree_cache_free(c);
>>         bch_journal_free(c);
>>
>> -       for_each_cache(ca, c, i)
>> -               if (ca) {
>> -                       ca->set = NULL;
>> -                       c->cache[ca->sb.nr_this_dev] = NULL;
>> -                       kobject_put(&ca->kobj);
>> -               }
>> +       for_each_cache(ca, c, i) {
>> +               ca->set = NULL;
>> +               c->cache[ca->sb.nr_this_dev] = NULL;
>> +               kobject_put(&ca->kobj);
>> +       }
>>
>>         bch_bset_sort_state_free(&c->sort);
>>         free_pages((unsigned long) c->uuids, ilog2(bucket_pages(c)));
>> --
>> 1.7.12.4
>>
>
