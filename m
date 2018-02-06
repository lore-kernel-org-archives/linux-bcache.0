From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH v5 06/10] bcache: add stop_when_cache_set_failed option to backing device
Date: Tue, 06 Feb 2018 10:50:30 +0000
Message-ID: <87bmh25r49.fsf@esperi.org.uk>
References: <20180206042100.65021-1-colyli@suse.de>
        <20180206042100.65021-7-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180206042100.65021-7-colyli@suse.de> (Coly Li's message of
        "Tue, 6 Feb 2018 12:20:56 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Pavel Goran <via-bcache@pvgoran.name>, Michael Lyle <mlyle@lyle.org>, Junhui Tang <tang.junhui@zte.com.cn>, Hannes Reinecke <hare@suse.com>
List-Id: linux-bcache@vger.kernel.org

On 6 Feb 2018, Coly Li verbalised:
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 7917b3820dd5..263164490833 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -287,6 +287,12 @@ struct io {
>  	sector_t		last;
>  };
>  
> +enum stop_on_faliure {

failure?

> +	BCH_CACHED_DEV_STOP_ATUO = 0,

AUTO?

> +	enum stop_on_faliure	stop_when_cache_set_failed;

(... and all uses would need changing too.)

-- 
NULL && (void)
