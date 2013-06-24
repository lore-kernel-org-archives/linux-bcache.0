From: matthew patton <pattonme-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: Doubling (?) of writes
Date: Mon, 24 Jun 2013 08:08:06 -0700 (PDT)
Message-ID: <1372086486.64111.YahooMailBasic@web181506.mail.ne1.yahoo.com>
References: <51C8424C.8020709@modelnine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C8424C.8020709-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heiko Wundram <modelnine-EqIAFqbRPK3NLxjTenLetw@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

What are the parameters of the workload? What's the point of posting benchmark results if you don't provide even a shred of  context?

Do the numbers from hdparm --direct -t roughly match the "sda" number? That you're getting 50% of raw SSD performance would seem to imply that 22% of the time you're getting a cache hit. Oops sorry, that verbiage applies to READs.

280MB/s * X + 100MB/s * (1-X) = 140
X = 0.22


For writes, you're obviously writing more data than the will just fit in the cache. Once the cache is sufficiently full with pending writes it has to destage to disk and that write rate is (on streaming loads only) about 80-100MB/s and far less when having to do lots of seeks. If we go with the 24MB/s number as the destage performance of the HDs with your workload

280 * X + 24 * 1-X) = 140
X = 0.45

So 45% of the time the writes go to cache and are immediately acknowledged. The rest of the time, it has to destage the current or (some) previous writes to disk before it can ACK. What's your dirty block watermark set to in bCache? I don't recall if that is a tunable. It may be hard-coded.
