From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 3/3] bcache: Remove redundant block_size assignment
Date: Wed, 11 May 2016 09:48:42 +0800
Message-ID: <57328F7A.9000508@huawei.com>
References: <1462869529-11293-1-git-send-email-wangyijing@huawei.com>
 <1462869529-11293-3-git-send-email-wangyijing@huawei.com>
 <alpine.LRH.2.11.1605101839350.22680@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([58.251.152.52]:27929 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076AbcEKBtf (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 10 May 2016 21:49:35 -0400
In-Reply-To: <alpine.LRH.2.11.1605101839350.22680@mx.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org



=E5=9C=A8 2016/5/11 9:41, Eric Wheeler =E5=86=99=E9=81=93:
> On Tue, 10 May 2016, Yijing Wang wrote:
>=20
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
>=20
>=20
> Are you sure we want to do that? =20
>=20
> The bcache superblock allows us to assign the block size presented by=
=20
> bcache and we wouldn't want 4k users to suddenly revert to 512b. =20

Hi, I have nothing functional to change here, we have assigned block_si=
ze already before here.

	sb->block_size	=3D le16_to_cpu(s->block_size);    //first assignment

	err =3D "Superblock block size smaller than device block size";
	if (sb->block_size << 9 < bdev_logical_block_size(bdev))
		goto err;

	switch (sb->version) {
	case BCACHE_SB_VERSION_BDEV:
		sb->data_offset	=3D BDEV_DATA_START_DEFAULT;
		break;
	case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
		sb->data_offset	=3D le64_to_cpu(s->data_offset);

		err =3D "Bad data offset";
		if (sb->data_offset < BDEV_DATA_START_DEFAULT)
			goto err;

		break;
	case BCACHE_SB_VERSION_CDEV:
	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
		sb->nbuckets	=3D le64_to_cpu(s->nbuckets);
		sb->block_size	=3D le16_to_cpu(s->block_size);       //redundant one

Thanks!
Yijing.


>=20
>=20
> --
> Eric Wheeler
>=20
>=20
>=20
>> =20
>>  		sb->nr_in_set	=3D le16_to_cpu(s->nr_in_set);
>> --=20
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> .
>=20
