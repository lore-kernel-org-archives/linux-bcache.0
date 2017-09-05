From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: fix bch_hprint crash and improve output
Date: Tue, 5 Sep 2017 12:54:29 +0800
Message-ID: <545dbd9e-76f1-5bd3-67ee-958ebb8edc7e@suse.de>
References: <20170904215524.26672-1-mlyle@lyle.org>
 <20170905041952.dnklu27naqbxxgia@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54565 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750705AbdIEEyg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Sep 2017 00:54:36 -0400
In-Reply-To: <20170905041952.dnklu27naqbxxgia@kmo-pixel>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On 2017/9/5 下午12:19, Kent Overstreet wrote:
> On Mon, Sep 04, 2017 at 02:55:24PM -0700, Michael Lyle wrote:
>> Most importantly, solve a crash where %llu was used to format signed
>> numbers.  This would cause a buffer overflow when reading sysfs
>> writeback_rate_debug, as only 20 bytes were allocated for this and
>> %llu writes 20 characters plus a null.
>>
>> Always use the units mechanism rather than having different output
>> paths for simplicity.
>>
>> Also, correct problems with display output where 1.10 was a larger
>> number than 1.09, by multiplying by 10 and then dividing by 1024 instead
>> of dividing by 100.  (Remainders of >= 1000 would print as .10).
>>
>> Minor changes: Always display the decimal point instead of trying to
>> omit it based on number of digits shown.  Decide what units to use
>> based on 1000 as a threshold, not 1024 (in other words, always print
>> at most 3 digits before the decimal point).
>>
>> Signed-off-by: Michael Lyle <mlyle@lyle.org>
>> Reported-by: Dmitry Yu Okunev <dyokunev@ut.mephi.ru>
> 
> Acked-by: Kent Overstreet <kent.overstreet@gmail.com>
> 

Reviewed-by: Coly Li <colyli@suse.de>

No paranoid comment any more, will be sent to block layer maintainer in
4.14 merge window.

Thanks to Michael Lyle, Michael Lyle, and Kent :-)

Coly Li

>> ---
>>  drivers/md/bcache/util.c | 50 +++++++++++++++++++++++++++++++++---------------
>>  1 file changed, 35 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
>> index 8c3a938f4bf0..176d3c2ef5f5 100644
>> --- a/drivers/md/bcache/util.c
>> +++ b/drivers/md/bcache/util.c
>> @@ -74,24 +74,44 @@ STRTO_H(strtouint, unsigned int)
>>  STRTO_H(strtoll, long long)
>>  STRTO_H(strtoull, unsigned long long)
>>  
>> +/**
>> + * bch_hprint() - formats @v to human readable string for sysfs.
>> + *
>> + * @v - signed 64 bit integer
>> + * @buf - the (at least 8 byte) buffer to format the result into.
>> + *
>> + * Returns the number of bytes used by format.
>> + */
>>  ssize_t bch_hprint(char *buf, int64_t v)
>>  {
>>  	static const char units[] = "?kMGTPEZY";
>> -	char dec[4] = "";
>> -	int u, t = 0;
>> -
>> -	for (u = 0; v >= 1024 || v <= -1024; u++) {
>> -		t = v & ~(~0 << 10);
>> -		v >>= 10;
>> -	}
>> -
>> -	if (!u)
>> -		return sprintf(buf, "%llu", v);
>> -
>> -	if (v < 100 && v > -100)
>> -		snprintf(dec, sizeof(dec), ".%i", t / 100);
>> -
>> -	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
>> +	int u = 0, t;
>> +
>> +	uint64_t q;
>> +
>> +	if (v < 0)
>> +		q = -v;
>> +	else
>> +		q = v;
>> +
>> +	/* For as long as the number is more than 3 digits, but at least
>> +	 * once, shift right / divide by 1024.  Keep the remainder for
>> +	 * a digit after the decimal point.
>> +	 */
>> +	do {
>> +		u++;
>> +
>> +		t = q & ~(~0 << 10);
>> +		q >>= 10;
>> +	} while (q >= 1000);
>> +
>> +	if (v < 0)
>> +		/* '-', up to 3 digits, '.', 1 digit, 1 character, null;
>> +		 * yields 8 bytes.
>> +		 */
>> +		return sprintf(buf, "-%llu.%i%c", q, t * 10 / 1024, units[u]);
>> +	else
>> +		return sprintf(buf, "%llu.%i%c", q, t * 10 / 1024, units[u]);
>>  }
>>  
>>  ssize_t bch_snprint_string_list(char *buf, size_t size, const char * const list[],
>> -- 
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
