From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: fix bch_hprint crash and improve output
Date: Tue, 5 Sep 2017 12:52:44 +0800
Message-ID: <bfbf71c0-1f0b-7da8-6558-b45410cb6f9a@suse.de>
References: <20170904215524.26672-1-mlyle@lyle.org>
 <21536f4c-69bb-ff33-dd3e-ed9ee3ec228a@suse.de>
 <20170905041934.ijchu2zz4wotnhhx@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750748AbdIEEww (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Sep 2017 00:52:52 -0400
In-Reply-To: <20170905041934.ijchu2zz4wotnhhx@kmo-pixel>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org

On 2017/9/5 下午12:19, Kent Overstreet wrote:
> On Tue, Sep 05, 2017 at 10:50:51AM +0800, Coly Li wrote:
>> On 2017/9/5 上午5:55, Michael Lyle wrote:
>>> Most importantly, solve a crash where %llu was used to format signed
>>> numbers.  This would cause a buffer overflow when reading sysfs
>>> writeback_rate_debug, as only 20 bytes were allocated for this and
>>> %llu writes 20 characters plus a null.
>>>
>>> Always use the units mechanism rather than having different output
>>> paths for simplicity.
>>>
>>> Also, correct problems with display output where 1.10 was a larger
>>> number than 1.09, by multiplying by 10 and then dividing by 1024 instead
>>> of dividing by 100.  (Remainders of >= 1000 would print as .10).
>>>
>>> Minor changes: Always display the decimal point instead of trying to
>>> omit it based on number of digits shown.  Decide what units to use
>>> based on 1000 as a threshold, not 1024 (in other words, always print
>>> at most 3 digits before the decimal point).
>>>
>>> Signed-off-by: Michael Lyle <mlyle@lyle.org>
>>> Reported-by: Dmitry Yu Okunev <dyokunev@ut.mephi.ru>
>>> ---
>>>  drivers/md/bcache/util.c | 50 +++++++++++++++++++++++++++++++++---------------
>>>  1 file changed, 35 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
>>> index 8c3a938f4bf0..176d3c2ef5f5 100644
>>> --- a/drivers/md/bcache/util.c
>>> +++ b/drivers/md/bcache/util.c
>>> @@ -74,24 +74,44 @@ STRTO_H(strtouint, unsigned int)
>>>  STRTO_H(strtoll, long long)
>>>  STRTO_H(strtoull, unsigned long long)
>>>  
>>> +/**
>>> + * bch_hprint() - formats @v to human readable string for sysfs.
>>> + *
>>> + * @v - signed 64 bit integer
>>> + * @buf - the (at least 8 byte) buffer to format the result into.
>>> + *
>>> + * Returns the number of bytes used by format.
>>> + */
>>>  ssize_t bch_hprint(char *buf, int64_t v)
>>>  {
>>>  	static const char units[] = "?kMGTPEZY";
>>> -	char dec[4] = "";
>>> -	int u, t = 0;
>>> -
>>> -	for (u = 0; v >= 1024 || v <= -1024; u++) {
>>> -		t = v & ~(~0 << 10);
>>> -		v >>= 10;
>>> -	}
>>> -
>>> -	if (!u)
>>> -		return sprintf(buf, "%llu", v);
>>> -
>>> -	if (v < 100 && v > -100)
>>> -		snprintf(dec, sizeof(dec), ".%i", t / 100);
>>> -
>>> -	return sprintf(buf, "%lli%s%c", v, dec, units[u]);
>>> +	int u = 0, t;
>>> +
>>> +	uint64_t q;
>>
>> It would be good to remove a blank line between the variables.
> 
> I'd prefer without the blank line, but this is pretty nitpicky.
> 
>>> +
>>> +	if (v < 0)
>>> +		q = -v;
>>> +	else
>>> +		q = v;
>>> +
>>> +	/* For as long as the number is more than 3 digits, but at least
>>> +	 * once, shift right / divide by 1024.  Keep the remainder for
>>> +	 * a digit after the decimal point.
>>> +	 */
>>> +	do {
>>> +		u++;
>>> +
>>> +		t = q & ~(~0 << 10);
>>> +		q >>= 10;
>>> +	} while (q >= 1000);
>>> +
>>
>> The original for-loop is correct, and the above do-while loop is
>> probably wrong. If q < 1024, a number without K/M/G/T/P/E/Z/Y should be
>> printed out, in this patch it is missing. And while (q>=1000) is not
>> correct, it should be (q>=1024), because >>10 means write shifting 10
>> bits, which is 1024 in decimal integer. How about just keep the
>> following original code,
> 
> It's just a style thing - printing out 100 vs 0.9k. I personally don't care one
> way or the other.
> 

Hi Kent,

Sure, I agree. You are the original author, once you are OK with current
patch, I don't have comment ^_^

> 
>> 	for (u = 0; v >= 1024 || v <= -1024; u++) {
>> 		t = v & ~(~0 << 10);
>> 		v >>= 10;
>> 	}
>>
>> 	if (!u)
>> 		return sprintf(buf, "%llu", v);
>> It is good enough IMHO.
>>
>>
>>
>>> +	if (v < 0)
>>> +		/* '-', up to 3 digits, '.', 1 digit, 1 character, null;
>>> +		 * yields 8 bytes.
>>> +		 */
>>> +		return sprintf(buf, "-%llu.%i%c", q, t * 10 / 1024, units[u]);
>>> +	else
>>> +		return sprintf(buf, "%llu.%i%c", q, t * 10 / 1024, units[u]);
>>>  }
>>
>> If you use char sign[2], that's two bytes temporary space on stack. Here
>> you use "-%llu.%i%c" and "%llu.%i%c" which occupy permanent space in
>> kernel readonly data section, which means 9 bytes more. That's not a big
>> memory consumption, but we can avoid it, why not.
>>
>> The logic in this patch is much clear, and thanks for your detailed
>> commit log and patch comments. Could you please compose another version ?
> 
> The patch is to fix a rather serious bug where with small negative numbers it
> blows through the output buffer. Let's get this in, please.
> 

OK, I give up the paranoid. This patch will be in my patch list and sent
out in this merge window. Thanks for your response.

Coly Li
