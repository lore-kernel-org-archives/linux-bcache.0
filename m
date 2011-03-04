From: John McCabe-Dansted <gmatht-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Utility to detect erase blocksize.
Date: Fri, 4 Mar 2011 16:33:57 +0800
Message-ID: <AANLkTimd3BQCWMYXVc5DBe+cA_RcsusftK4eBK6d1usi@mail.gmail.com>
References: <AANLkTi=4Zf1gwFMo519FK0se6xdZuRjtBvsPV12Z1O_K@mail.gmail.com>
 <4CBFD879.4000907@gmail.com> <AANLkTikEi45Rm5RhpJp0oBLH-wQt0pKzc0_RztFGOjao@mail.gmail.com>
 <4CBFE5B7.5090401@gmail.com> <AANLkTimjeP13AATbv6DGsXZa9k3HQcZqQRfkjdgQy4g=@mail.gmail.com>
 <AANLkTin47nP6bSgqhQF7B23jGLLtMr-35-udLuWH4bW4@mail.gmail.com> <4CC009B8.1020203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC009B8.1020203-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

I notice that this thread hasn't been archived; the archive didn't
seem to start till December. Should I copy it somewhere?

On Thu, Oct 21, 2010 at 5:36 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 10/21/2010 02:29 AM, John McCabe-Dansted wrote:
>>
>> I imagine most USB stuff wouldn't support it. Apparently even the
>> high-performance USB 3.0 devices don't support trim:
>> http://techgage.com/article/ocz_enyo_128gb_usb_30_portable_ssd/
>>
>> However, a moderately smart controller shouldn't have problems with
>> simple writes (e.g. sequential), even without TRIM. For example, it
>> could keep a spare block, and when doing writes to a old block it
>> instead writes to the spare block. When finished writing it could make
>> the old block the new spare block. When reading a sector, it could
>> read the sector from the spare block first, and if it reads only
>> zeros, instead read from the old block.
>
> What you're describing is basically garbage collection + an index of some
> kind. That's basically what bcache and SSD firmwares are, and to make it
> work at all it gets pretty complex. To make it fast... like bcache, or the
> better firmwares, it gets scary complicated.

Apparently this is what drives with "Linear-access optimized garbage
collection" do; see
http://lwn.net/Articles/428584

This also appears to be what my 8GB stick does judging from it's
sequential performance.

> And yeah, a good SSD shouldn't need TRIM for good performance with bcache...
> Unfortunately all I've tested on myself is a Corsair Nova, and on it the
> performance degradation over time without TRIM is extreme. Like, maybe 75%.

I think that the cheap "linear optimized drives" shouldn't degrade if
we write in 4MB blocks, since the always have a fixed number of spare
blocks (typically 3 according to the article).

FYI, A Kingston SDHC SD4/4GB (Class 4) card gave the follwing results:

john@ToshibaA300:~/Downloads$ sudo ./a.out /dev/sdb
[sudo] password for john:
Offset 16777216, mode: rand
Device size: 4007624704 = 122303 * 32768
Block size:     4096  Skip:     4096 Write/sec:    2.395 (   0.009MB)
Block size:     8192  Skip:     4096 Write/sec:    1.895 (   0.015MB)
Block size:    16384  Skip:     4096 Write/sec:    1.850 (   0.029MB)
Block size:    32768  Skip:     4096 Write/sec:    1.817 (   0.057MB)
Block size:    65536  Skip:     4096 Write/sec:    1.926 (   0.120MB)
Block size:   131072  Skip:     4096 Write/sec:    1.546 (   0.193MB)
Block size:   262144  Skip:     4096 Write/sec:    1.662 (   0.415MB)
Block size:   524288  Skip:     4096 Write/sec:    1.183 (   0.591MB)
Block size:  1048576  Skip:     4096 Write/sec:    0.823 (   0.823MB)
Block size:  2097152  Skip:     4096 Write/sec:    0.586 (   1.173MB)
Block size:  4194304  Skip:     4096 Write/sec:    0.527 (   2.106MB)
Block size:  8388608  Skip:     4096 Write/sec:    0.410 (   3.282MB)
Block size: 16777216  Skip:     4096 Write/sec:    0.279 (   4.467MB)
john@ToshibaA300:~/Downloads$ sudo ./a.out /dev/sdb skip
Offset 16777216, mode: skip
Device size: 4007624704 = 122303 * 32768
Block size:     4096  Skip:     4096 Write/sec:  156.916 (   0.613MB)
Block size:     4096  Skip:     8192 Write/sec:  117.048 (   0.457MB)
Block size:     4096  Skip:    16384 Write/sec:  106.923 (   0.418MB)
Block size:     4096  Skip:    32768 Write/sec:   83.032 (   0.324MB)
Block size:     4096  Skip:    65536 Write/sec:   53.177 (   0.208MB)
Block size:     4096  Skip:   131072 Write/sec:   38.167 (   0.149MB)
Block size:     4096  Skip:   262144 Write/sec:   23.343 (   0.091MB)
Block size:     4096  Skip:   524288 Write/sec:   18.631 (   0.073MB)
Block size:     4096  Skip:  1048576 Write/sec:    5.488 (   0.021MB)
Block size:     4096  Skip:  2097152 Write/sec:    2.983 (   0.012MB)
Block size:     4096  Skip:  4194304 Write/sec:    1.932 (   0.008MB)
Block size:     4096  Skip:  8388608 Write/sec:    1.932 (   0.008MB)
Block size:     4096  Skip: 16777216 Write/sec:    1.933 (   0.008MB)

-- 
John C. McCabe-Dansted
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
