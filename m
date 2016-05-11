From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 3/3] bcache: Remove redundant block_size assignment
Date: Wed, 11 May 2016 09:12:22 +0800
Message-ID: <573286F6.6070705@huawei.com>
References: <1462869529-11293-1-git-send-email-wangyijing@huawei.com>
 <1462869529-11293-3-git-send-email-wangyijing@huawei.com>
 <4a8a2115-c122-321b-e02d-ce21a15c1b5e@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([58.251.152.179]:32639 "EHLO
	szxga05-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751614AbcEKBOA (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 May 2016 21:14:00 -0400
In-Reply-To: <4a8a2115-c122-321b-e02d-ce21a15c1b5e@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org



=D4=DA 2016/5/10 22:51, Coly Li =D0=B4=B5=C0:
> =D4=DA 16/5/10 =CF=C2=CE=E74:38, Yijing Wang =D0=B4=B5=C0:
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/md/bcache/super.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 1ccb9be..64d0be6 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -134,7 +134,6 @@ static const char *read_super(struct cache_sb *s=
b, struct block_device *bdev,
>>  	case BCACHE_SB_VERSION_CDEV:
>>  	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
>>  		sb->nbuckets	=3D le64_to_cpu(s->nbuckets);
>> -		sb->block_size	=3D le16_to_cpu(s->block_size);
>>  		sb->bucket_size	=3D le16_to_cpu(s->bucket_size);
>> =20
>>  		sb->nr_in_set	=3D le16_to_cpu(s->nr_in_set);
>>
>=20
> Yes, this assignment is redundant. Could you please to add some comme=
nts
> to describe this patch before your Signed-off-by ? This will be
> informative and helpful for others who may back port the patches.

OK.

Thanks!
Yijing.

>=20
> Thanks.
>=20
