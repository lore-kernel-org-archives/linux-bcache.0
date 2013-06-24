From: Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Subject: Re: Doubling (?) of writes
Date: Mon, 24 Jun 2013 17:20:22 +0200
Message-ID: <51C863B6.2000402@modelnine.org>
References: <1372086486.64111.YahooMailBasic@web181506.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372086486.64111.YahooMailBasic-XYahOdtEMNlRBbKmAC7my5OW+3bF1jUfVpNB7YpNyf8@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Am 24.06.2013 17:08, schrieb matthew patton:
> What are the parameters of the workload? What's the point of posting benchmark results if you don't provide even a shred of  context?

This was not supposed to be a benchmark or anything like it, but rather 
that I was intrigued that when configuring all writes to go through the 
SSD (see my bcache configuration tunables in the original mail), the 
throughput that the SSD showed for writes was double of that which the 
bcache device showed (see my title, i.e. as if all writes were being 
doubled when being passed down to the SSD).

And, guess what, they are (and I implicitly delivered the corresponding 
hint in my bcache-show-super output): it seems (counter-intuitively for 
me) that discard is counted as a write of the full block size to the 
SSD, so that when discard is enabled, for each block written to the SSD 
(i.e., for each block written to the bcache device), the Linux kernel 
counts the discard as a full block write, and additionally the actual 
output of the block to the SSD (which is the write I expected) as 
another write of the same size - the I/O bandwidth to the SSD device is 
thus double the bandwidth to the synthethized bcache1-device.

Disabling discard for the cache-set gives the numbers I expected: 
bcache1 has the same write throughput as the underlying SSD device (when 
all I/O is configured to go through the SSD). Should've tested this 
before posting - still, this seems counter-intuitive to me.

Anyway, enabling or disabling discards has an effect on the bandwidth to 
the SSD device, but not on the utilization (which is roughly similar in 
either case for equivalent workloads), so I guess it really is the 
discards that "double" the perceived bandwidth - it'd be good for 
someone to confirm this.

> So 45% of the time the writes go to cache and are immediately acknowledged. The rest of the time, it has to destage the current or (some) previous writes to disk before it can ACK. What's your dirty block watermark set to in bCache? I don't recall if that is a tunable. It may be hard-coded.

It's got nothing to do with this - I didn't ask about the actual 
numbers, but only their relations.

-- 
--- Heiko.
