From: Coly Li <i@coly.li>
Subject: Re: [UPDATE][PATCH 3/3] bcache: Remove redundant block_size
 assignment
Date: Sun, 15 May 2016 15:23:43 +0800
Message-ID: <8b18badd-fbce-67d4-31e1-9ffd642840a3@coly.li>
References: <1462946524-11639-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:54727 "EHLO server.coly.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbcEOHXu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 May 2016 03:23:50 -0400
In-Reply-To: <1462946524-11639-1-git-send-email-wangyijing@huawei.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

=D4=DA 16/5/11 =CF=C2=CE=E72:02, Yijing Wang =D0=B4=B5=C0:
> We have assigned sb->block_size before the switch,
> so remove the redundant one.
>=20
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Reviewed-by: Coly Li <colyli@suse.de>

> ---
>  drivers/md/bcache/super.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1ccb9be..64d0be6 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -134,7 +134,6 @@ static const char *read_super(struct cache_sb *sb=
, struct block_device *bdev,
>  	case BCACHE_SB_VERSION_CDEV:
>  	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
>  		sb->nbuckets	=3D le64_to_cpu(s->nbuckets);
> -		sb->block_size	=3D le16_to_cpu(s->block_size);
>  		sb->bucket_size	=3D le16_to_cpu(s->bucket_size);
> =20
>  		sb->nr_in_set	=3D le16_to_cpu(s->nr_in_set);
>=20


--=20
Coly Li
