From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: fix bch_hprint crash and improve output
Date: Tue, 5 Sep 2017 00:56:31 +0800
Message-ID: <62b30a7d-0ef1-954a-27a6-47d8850a9e91@suse.de>
References: <20170901203722.29974-1-mlyle@lyle.org>
 <fe238d0c-05c4-0d58-06f6-3013e20c5679@suse.de>
 <CAJ+L6qef4ApkunEEkK55MFfFexLCXqtPz4Gg4EyPXc_0Uki4nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753847AbdIDQ4n (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Sep 2017 12:56:43 -0400
In-Reply-To: <CAJ+L6qef4ApkunEEkK55MFfFexLCXqtPz4Gg4EyPXc_0Uki4nw@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org

On 2017/9/5 上午12:31, Michael Lyle wrote:
> [I'm sorry for the resend-- seems I can't send plain text mode from
> inbox so sent HTML mail on accident]
> 
> OK, I don't like the formulation of the code either-- I will
> restructure a bit to be clearer in a bit bigger of a patch today or
> tomorrow.
> 

Yes, using "v = -v" for negative numbers, then you don't need to worry
how bits are ordered in memory. Handling complemented code with bit
operations is quite easy to introduce bug(s).

> The *critical* issue is this-- if v is between -1023 and -1, the line
> return sprintf(buf, "%llu", v); is run. In turn, this prints out a 20
> digit number plus terminating null. In turn, bch_hprint is called
> places where it is provided with a 20 character buffer, which overruns
> and causes a kernel panic. This doesn't require any privilege to
> trigger, so it's a user-space denial of service vulnerability.
> 

Oh, I see why you call it a stack overflow. Yes, this fix is critical,
and sounds important. Thanks for catching and fixing it.

> I discovered this when running watch cat writeback_rate_debug to
> troubleshoot the control system (which I am tempted to rewrite,
> because it has various issues) and I encountered multiple panics.
> 

Wow, I will review your next version patch once you send out. Do not
forget a more detailed patch comments, please :-)

Coly Li

> Mike
> 
> On Sun, Sep 3, 2017 at 11:07 PM Coly Li <colyli@suse.de> wrote:
> 
> On 2017/9/2 上午4:37, Michael Lyle wrote:
>> Solve a crash where the stack is overrun when reading sysfs and
>> small negative values are present. Also correct output, as before
>> it would output "1.10" for numbers bigger than "1.9", and negative
>> fractional output was incorrect.
>>
> 
> I suggest to provide more detailed comments here, to explain,
> - the purpose and expected output of bch_hprint()
> - when a small negative value comes, how bhc_hprint() goes wrong
> - how your patch fixes the root cause.
> 
> The reason for my suggestion is, the original code is ambiguous on
> positive and negative integer values. When you see the following
> for-loop in bch_hprint(),
> 83 for (u = 0; v >= 1024 || v <= -1024; u++) {
> 84 t = v & ~(~0 << 10);
> 85 v >>= 10;
> 86 }
> You may notice no matter v is positive or negative, variables 't' and
> 'v' are handled with the bit operations which taking for granted that
> 'v' is always positive integer values.
> 
> I don't have very deep insight of coding theory, my intuition of a first
> glance on the code gives me a warning: the code might be buggy.
> Example an integer N, most of time, -N and +N has different ordering in
> non most-significant bits. The original code neglects when v is negative
> value, v is in form of complement code, so value t here is not correct,
> then the following calculation in wrong,
> 91 if (v < 100 && v > -100)
> 92 snprintf(dec, sizeof(dec), ".%i", t / 100);
> 
> I see your patch fixes the above two lines, but your patch is not simply
> understandable for me, e.g. why you use 't > 103' (I guess it is because
> 103*10 > 1024).
> 
> A fix much simpler in logic maybe look like this, which is enlighten by
> your patch,
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 8c3a938f4bf0..bf1dbb9c3ea8 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -78,20 +78,26 @@ ssize_t bch_hprint(char *buf, int64_t v)
> {
> static const char units[] = "?kMGTPEZY";
> char dec[4] = "";
> + char sign[2] = "";
> int u, t = 0;
> 
> - for (u = 0; v >= 1024 || v <= -1024; u++) {
> + if (v < 0) {
> + sign[0] = '-';
> + v = -v;
> + }
> +
> + for (u = 0; v >= 1024; u++) {
> t = v & ~(~0 << 10);
> v >>= 10;
> }
> 
> if (!u)
> - return sprintf(buf, "%llu", v);
> + return sprintf(buf, "%s%lli", sign, v);
> 
> - if (v < 100 && v > -100)
> - snprintf(dec, sizeof(dec), ".%i", t / 100);
> + if (t > 0)
> + snprintf(dec, sizeof(dec), ".%i", (t*10)/1024);
> 
> - return sprintf(buf, "%lli%s%c", v, dec, units[u]);
> + return sprintf(buf, "%s%lli%s%c", sign, v, dec, units[u]);
> }
> 
> This is just an idea in my brain which is enlighten by your patch, not
> correct maybe, just for your reference. I do like the idea "t * 10 /
> 1024", I have to say I feel happiness when I understand it, very smart :-)
> 
> Finally please offer a more detailed comments as I suggested, thank you
> in advance.
> 
> Coly Li
> 
> 
>> Signed-off-by: Michael Lyle <mlyle@lyle.org>
>> Reported-by: Dmitry Yu Okunev <dyokunev@ut.mephi.ru>
>> ---
>> drivers/md/bcache/util.c | 10 +++++++---
>> 1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
>> index 8c3a938f4bf0..11957038c630 100644
>> --- a/drivers/md/bcache/util.c
>> +++ b/drivers/md/bcache/util.c
>> @@ -86,10 +86,14 @@ ssize_t bch_hprint(char *buf, int64_t v)
>> }
>>
>> if (!u)
>> - return sprintf(buf, "%llu", v);
>> + return sprintf(buf, "%lli", v);
>>
>> - if (v < 100 && v > -100)
>> - snprintf(dec, sizeof(dec), ".%i", t / 100);
>> + if (t > 103) {
>> + if (v > 0)
>> + snprintf(dec, sizeof(dec), ".%i", t * 10 / 1024);
>> + else
>> + snprintf(dec, sizeof(dec), ".%i", 10 - (t * 10 / 1024));
>> + }
>>
>> return sprintf(buf, "%lli%s%c", v, dec, units[u]);
>> }
>>
