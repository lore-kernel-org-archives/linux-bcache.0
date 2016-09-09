From: Marcin <marcin@mejor.pl>
Subject: Re: [PATCH 4/4] Make output message more human friendly
Date: Fri, 09 Sep 2016 19:49:01 +0200
Message-ID: <1532ca29e51667feba70d67c30e63d87@mejor.pl>
References: <20160904043611.6nw2vjhs3j2cnnqm@kmo-pixel>
 <1473427720-1350-1-git-send-email-marcin@mejor.pl>
 <1473427720-1350-4-git-send-email-marcin@mejor.pl>
 <feac8c0b-e35a-e309-f30f-66e5cd1af6a6@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:39904 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbcIIRt5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 13:49:57 -0400
In-Reply-To: <feac8c0b-e35a-e309-f30f-66e5cd1af6a6@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org

W dniu 2016-09-09 17:56, Coly Li napisał(a):
> 在 16/9/9 下午9:28, Marcin Mirosław 写道:
>> ---
>>  libbcache.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/libbcache.c b/libbcache.c
>> index f17bd4a..3a915e9 100644
>> --- a/libbcache.c
>> +++ b/libbcache.c
>> @@ -200,16 +200,16 @@ void bcache_format(struct dev_opts *devs, size_t 
>> nr_devs,
>>  		       "Set UUID:		%s\n"
>>  		       "version:		%u\n"
>>  		       "nbuckets:		%llu\n"
>> -		       "block_size:		%u\n"
>> -		       "bucket_size:		%u\n"
>> +		       "block_size (bytes):	%u\n"
>> +		       "bucket_size (bytes):	%u\n"
>>  		       "nr_in_set:		%u\n"
>>  		       "nr_this_dev:		%u\n"
>>  		       "first_bucket:		%u\n",
>>  		       uuid_str, set_uuid_str,
>>  		       (unsigned) sb->version,
>>  		       __le64_to_cpu(m->nbuckets),
>> -		       __le16_to_cpu(sb->block_size),
>> -		       __le16_to_cpu(m->bucket_size),
>> +		       __le16_to_cpu(sb->block_size)*512,
>> +		       __le16_to_cpu(m->bucket_size)*512,
>>  		       sb->nr_in_set,
>>  		       sb->nr_this_dev,
>>  		       __le16_to_cpu(m->first_bucket));
>> 
> Hi Marcin,
> 
> NACK, the out put is content of data structure, it is helpful to debug
> and analyze. If block_size and bucket_size is changed into bytes, in
> many case people have to convert them back to sectors.
> 
> I agree this is an issue, I suggest to explain it in manual.

Hi!
You are right, I also hardcoded sector size. Would it be acceptable 
change in displayed description without changing values?
+		       "block_size  (sectors):	%u\n"
+		       "bucket_size (sectors):	%u\n"

I prefer to not write man, my english isn't good enough for it.
Thanks for review.
Marcin
