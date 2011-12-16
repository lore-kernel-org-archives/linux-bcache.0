From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Quick bcache benchmark
Date: Thu, 15 Dec 2011 18:17:47 -0800
Message-ID: <CAH+dOx+r7L2o9RSCdXsa0Nn+k=Ab9QXc60gBb7Mhb+huhcOQ1g@mail.gmail.com>
References: <20111206082233.GA19390@moria>
	<CAEp_DRCHQo1JyPZk6dKYZjJvxtaR7yxpEDtGE+uYK9n2dNb2Pw@mail.gmail.com>
	<20111206115617.GA32759@moria>
	<CAEp_DRDEQLSkJ3arx81qM1M4iSJ5Wy0dwZhsrYD=94682qw8JQ@mail.gmail.com>
	<CALFpzo4s5ee23CMqNJbNUBW_wYBwc3gq0P8zzfAp8QSM+r_JLA@mail.gmail.com>
	<CALFpzo6ugO-5KHvrszp0bAYHY9eT8ADebbBqwgM3Y9FRS7PnGw@mail.gmail.com>
	<CAC7rs0vvJbN6iOvvKJ3Xgm5BAzBxBYL+e6_F_ZzfREEbnC9-CA@mail.gmail.com>
	<CALFpzo6kXrC+8kkqrtRuMcsqnRL-oPc+B3A-Vq3wkWhRLBbAJw@mail.gmail.com>
	<20111210063307.GA16262@moria>
	<CALFpzo71TRvx59U6n7xkd_DNejQrD9qj1tuOeir3w6NaT79bCA@mail.gmail.com>
	<CALFpzo542=jHj5OB3qCSKCAvmig6t85VDhnuc++toO0O=z7brQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALFpzo542=jHj5OB3qCSKCAvmig6t85VDhnuc++toO0O=z7brQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Sorry, I was thinking about that issue for awhile and then I got distra=
cted...

It's not user error, it's an irritating corner case. Basically, it's
the result of a workaround for a particularly obscure data corruption
bug.

If a write bypasses the cache, it has to invalidate that region of the
cache; the null key it leaves in the cache will block cache misses
from adding that data to the cache until the btree node fills up (and
possibly splits).

It hasn't been an issue for us in normal operation, but when you're
just testing - i.e. you don't have much load - that node split may not
happen for a long time, and so if for some reason a bunch of data
bypassed the cache... well, you see what happens.

Unfortunately a better solution to the original race is not going to
be simple, so it's probably not going to be done in the very near
future. It's a _very_ difficult race to hit, but in the meantime I'd
rather lose performance than corrupt data.

But the good news is if you put normal server-ish load on it the issue
should go away in steady state operation.

On Thu, Dec 15, 2011 at 3:40 PM, Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> Any ideas on this? Do you think it's a bug, or am I just holding it w=
rong? :-)
>
> On Sat, Dec 10, 2011 at 8:02 AM, Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>> That keeps the 'bypassed' value from increasing, but it doesn't chan=
ge
>> write performance.
>>
>> BEFORE:
>> [root@sansrv2-10 stats_day]# cat *
>> 27.6M
>> 83
>> 3500
>> 0
>> 166
>> 24380
>> 40660
>> 0
>>
>> ...benchmarking...
>>
>> AFTER:
>>
>> [root@sansrv2-10 stats_day]# =A0for i in `ls`; do echo -n "$i "; cat=
 $i;
>>> done 2>/dev/null
>> bypassed 27.6M
>> cache_bypass_hits 83
>> cache_bypass_misses 3500
>> cache_hit_ratio 0
>> cache_hits 410
>> cache_miss_collisions 48879
>> cache_misses 80545
>> cache_readaheads 0
>>
>> /sys/fs/bcache/60da061c-d646-4ebe-931a-d8580add411d
>>
>> average_key_size 0
>> block_size 2.0k
>> btree_cache_size 3.2M
>> bucket_size 1.0M
>> cache_available_percent 100
>> clear_stats congested 0
>> congested_threshold_us 0
>> dirty_data 0
>> io_error_halflife 0
>> io_error_limit 8
>> root_usage_percent 0
>> synchronous 1
>> tree_depth 1
>>
>>
>> On Fri, Dec 9, 2011 at 11:33 PM, Kent Overstreet
>> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Fri, Dec 09, 2011 at 10:09:55AM -0700, Marcus Sorensen wrote:
>>>> Here's some more info. I'm running kernel 3.1.4. When I do random
>>>> writes, the 'bypassed' number increases in stats. Now I'm random
>>>> writing direct to /dev/bcache0 and get the same result.
>>>
>>> Weird. From what you're describing it sounds like throttling is scr=
ewed
>>> up (and it was recently), but I can't reproduce it now.
>>>
>>> Can you try echoing 0 to congested_threshold_us in the cache set di=
r,
>>> and seeing if that fixes it?
>>>
>>>> There also seems to be some work needed with clean-up, since I'm
>>>> unfamiliar with how bcache works I attempted to make-bcache twice,
>>>> thinking I'd start over. That worked, but because my cache device =
was
>>>> already registered I was unable to re-register my newly formatted
>>>> cache dev, got "kobject_add_internal failed for bcache with -EEXIS=
T,
>>>> don't try to register things with the same name in the same
>>>> directory." I was still able to use my cache device via the old uu=
id,
>>>> but this will probably cause problems on reboot. Perhaps an unregi=
ster
>>>> file in /sys/fs/bcache would help, I also tried rmmod'ing bcache t=
o
>>>> see if I could clear /sys/fs/bcache, but no luck. make-bcache shou=
ld
>>>> perhaps check for an existing superblock, ask for confirmation, an=
d
>>>> give some sort instruction on how to unregister, or do it for you =
if
>>>> you reformat.
>>>
>>> Yeah, I think for some reason bcache isn't opening the devices
>>> exclusively on 3.1. I'll have a look...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
