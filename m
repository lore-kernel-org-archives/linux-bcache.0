From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/4] Make output message more human friendly
Date: Fri, 9 Sep 2016 23:56:31 +0800
Message-ID: <feac8c0b-e35a-e309-f30f-66e5cd1af6a6@coly.li>
References: <20160904043611.6nw2vjhs3j2cnnqm@kmo-pixel>
 <1473427720-1350-1-git-send-email-marcin@mejor.pl>
 <1473427720-1350-4-git-send-email-marcin@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:46574 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753324AbcIIQsy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 12:48:54 -0400
In-Reply-To: <1473427720-1350-4-git-send-email-marcin@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>, linux-bcache@vger.kernel.org

在 16/9/9 下午9:28, Marcin Mirosław 写道:
> ---
>  libbcache.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libbcache.c b/libbcache.c
> index f17bd4a..3a915e9 100644
> --- a/libbcache.c
> +++ b/libbcache.c
> @@ -200,16 +200,16 @@ void bcache_format(struct dev_opts *devs, size_t nr_devs,
>  		       "Set UUID:		%s\n"
>  		       "version:		%u\n"
>  		       "nbuckets:		%llu\n"
> -		       "block_size:		%u\n"
> -		       "bucket_size:		%u\n"
> +		       "block_size (bytes):	%u\n"
> +		       "bucket_size (bytes):	%u\n"
>  		       "nr_in_set:		%u\n"
>  		       "nr_this_dev:		%u\n"
>  		       "first_bucket:		%u\n",
>  		       uuid_str, set_uuid_str,
>  		       (unsigned) sb->version,
>  		       __le64_to_cpu(m->nbuckets),
> -		       __le16_to_cpu(sb->block_size),
> -		       __le16_to_cpu(m->bucket_size),
> +		       __le16_to_cpu(sb->block_size)*512,
> +		       __le16_to_cpu(m->bucket_size)*512,
>  		       sb->nr_in_set,
>  		       sb->nr_this_dev,
>  		       __le16_to_cpu(m->first_bucket));
> 
Hi Marcin,

NACK, the out put is content of data structure, it is helpful to debug
and analyze. If block_size and bucket_size is changed into bytes, in
many case people have to convert them back to sectors.

I agree this is an issue, I suggest to explain it in manual.

Thanks.

-- 
Coly Li
