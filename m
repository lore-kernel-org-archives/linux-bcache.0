From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/7] bcache: Use scnprintf() for avoiding potential buffer
 overflow
Date: Mon, 23 Mar 2020 08:04:39 +0100
Message-ID: <023b3e3b-8dcf-0ea4-204d-b3b4162b511f@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-6-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200322060305.70637-6-colyli@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
List-Id: linux-bcache@vger.kernel.org

On 3/22/20 7:03 AM, Coly Li wrote:
> From: Takashi Iwai <tiwai@suse.de>
> 
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/sysfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 3470fae4eabc..323276994aab 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -154,7 +154,7 @@ static ssize_t bch_snprint_string_list(char *buf,
>   	size_t i;
>   
>   	for (i = 0; list[i]; i++)
> -		out += snprintf(out, buf + size - out,
> +		out += scnprintf(out, buf + size - out,
>   				i == selected ? "[%s] " : "%s ", list[i]);
>   
>   	out[-1] = '\n';
> 
Well, if you already consider a possible overflow here, why don't you 
abort the loop once 'out == buf + size' ?

Cheers,

Hannes

-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
