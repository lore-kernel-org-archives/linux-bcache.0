From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: Use scnprintf() for avoiding potential buffer
 overflow
Date: Fri, 20 Mar 2020 00:27:47 +0800
Message-ID: <d5be999d-ac69-8b22-667a-8815d3f9934d@suse.de>
References: <20200311074558.8517-1-tiwai@suse.de>
 <s5h7dzguyix.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbgCSQ1w (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 19 Mar 2020 12:27:52 -0400
In-Reply-To: <s5h7dzguyix.wl-tiwai@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On 2020/3/19 11:58 下午, Takashi Iwai wrote:
> On Wed, 11 Mar 2020 08:45:58 +0100,
> Takashi Iwai wrote:
>>
>> Since snprintf() returns the would-be-output size instead of the
>> actual output size, the succeeding calls may go beyond the given
>> buffer limit.  Fix it by replacing with scnprintf().
>>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> A gentle reminder for this forgotten patch.
> Let me know if any further changes are needed.
> 

Hi Takashi,

This is in my for-next list already. Sorry for not reply you yet, just
busy on the testing with combined with md raid backend.

Thanks.

Coly Li

>> ---
>>  drivers/md/bcache/sysfs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>> index 3470fae4eabc..323276994aab 100644
>> --- a/drivers/md/bcache/sysfs.c
>> +++ b/drivers/md/bcache/sysfs.c
>> @@ -154,7 +154,7 @@ static ssize_t bch_snprint_string_list(char *buf,
>>  	size_t i;
>>  
>>  	for (i = 0; list[i]; i++)
>> -		out += snprintf(out, buf + size - out,
>> +		out += scnprintf(out, buf + size - out,
>>  				i == selected ? "[%s] " : "%s ", list[i]);
>>  
>>  	out[-1] = '\n';
>> -- 
>> 2.16.4
>>


-- 

Coly Li
