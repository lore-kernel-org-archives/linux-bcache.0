From: Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick bcache benchmark
Date: Fri, 16 Dec 2011 11:49:48 -0700
Message-ID: <CALFpzo6r8YGXtUtTOua=nw0Nw_+FEdL71+JEwb65LeRkyuTGZA@mail.gmail.com>
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
	<CAH+dOx+r7L2o9RSCdXsa0Nn+k=Ab9QXc60gBb7Mhb+huhcOQ1g@mail.gmail.com>
	<CALFpzo6-cpEqxAy5p7rje_CR08PE94Cbju==yRktQ_8s7dN4QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALFpzo6-cpEqxAy5p7rje_CR08PE94Cbju==yRktQ_8s7dN4QQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Actually I think this IS user error. I ran a benchmark with FIO, and
the results were practically identical with and without bcache.  I
applied the 3.1.4 kernel patch on top of your 3.1 tree, even though it
applied cleanly I'm guessing that wiped something out. Here are my
stats after running the benchmark on bcache, and also included is the
fio config.

bypassed 32.1G
cache_bypass_hits 5482
cache_bypass_misses 194862
cache_hit_ratio 3
cache_hits 786
cache_miss_collisions 206
cache_misses 19447
cache_readaheads 0

[global]
ioengine=3Dlibaio
iodepth=3D4
invalidate=3D1 #make sure we're not cached locally
direct=3D1 #don't use buffers during test (test without local caches)
thread
ramp_time=3D20
time_based
runtime=3D180

[8RandomReadWriters]
rw=3Drandrw
numjobs=3D8
blocksize=3D4k
size=3D1G

[2SequentialReadWriters]
rw=3Drw
numjobs=3D2
size=3D4G
blocksize_range=3D64k-1M


On Thu, Dec 15, 2011 at 9:28 PM, Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> Thanks! I'll put it through some more tests. I kind of figured that
> something more real-world would help.
>
> On Thu, Dec 15, 2011 at 7:17 PM, Kent Overstreet <koverstreet@google.=
com> wrote:
>> Sorry, I was thinking about that issue for awhile and then I got dis=
tracted...
>>
>> It's not user error, it's an irritating corner case. Basically, it's
>> the result of a workaround for a particularly obscure data corruptio=
n
>> bug.
>>
>> If a write bypasses the cache, it has to invalidate that region of t=
he
>> cache; the null key it leaves in the cache will block cache misses
>> from adding that data to the cache until the btree node fills up (an=
d
>> possibly splits).
>>
>> It hasn't been an issue for us in normal operation, but when you're
>> just testing - i.e. you don't have much load - that node split may n=
ot
>> happen for a long time, and so if for some reason a bunch of data
>> bypassed the cache... well, you see what happens.
>>
>> Unfortunately a better solution to the original race is not going to
>> be simple, so it's probably not going to be done in the very near
>> future. It's a _very_ difficult race to hit, but in the meantime I'd
>> rather lose performance than corrupt data.
>>
>> But the good news is if you put normal server-ish load on it the iss=
ue
>> should go away in steady state operation.
>>
>> On Thu, Dec 15, 2011 at 3:40 PM, Marcus Sorensen <shadowsor-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>> Any ideas on this? Do you think it's a bug, or am I just holding it=
 wrong? :-)
>>>
>>> On Sat, Dec 10, 2011 at 8:02 AM, Marcus Sorensen <shadowsor@gmail.c=
om> wrote:
>>>> That keeps the 'bypassed' value from increasing, but it doesn't ch=
ange
>>>> write performance.
>>>>
>>>> BEFORE:
>>>> [root@sansrv2-10 stats_day]# cat *
>>>> 27.6M
>>>> 83
>>>> 3500
>>>> 0
>>>> 166
>>>> 24380
>>>> 40660
>>>> 0
>>>>
>>>> ...benchmarking...
>>>>
>>>> AFTER:
>>>>
>>>> [root@sansrv2-10 stats_day]# =A0for i in `ls`; do echo -n "$i "; c=
at $i;
>>>>> done 2>/dev/null
>>>> bypassed 27.6M
>>>> cache_bypass_hits 83
>>>> cache_bypass_misses 3500
>>>> cache_hit_ratio 0
>>>> cache_hits 410
>>>> cache_miss_collisions 48879
>>>> cache_misses 80545
>>>> cache_readaheads 0
>>>>
>>>> /sys/fs/bcache/60da061c-d646-4ebe-931a-d8580add411d
>>>>
>>>> average_key_size 0
>>>> block_size 2.0k
>>>> btree_cache_size 3.2M
>>>> bucket_size 1.0M
>>>> cache_available_percent 100
>>>> clear_stats congested 0
>>>> congested_threshold_us 0
>>>> dirty_data 0
>>>> io_error_halflife 0
>>>> io_error_limit 8
>>>> root_usage_percent 0
>>>> synchronous 1
>>>> tree_depth 1
>>>>
>>>>
>>>> On Fri, Dec 9, 2011 at 11:33 PM, Kent Overstreet
>>>> <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>> On Fri, Dec 09, 2011 at 10:09:55AM -0700, Marcus Sorensen wrote:
>>>>>> Here's some more info. I'm running kernel 3.1.4. When I do rando=
m
>>>>>> writes, the 'bypassed' number increases in stats. Now I'm random
>>>>>> writing direct to /dev/bcache0 and get the same result.
>>>>>
>>>>> Weird. From what you're describing it sounds like throttling is s=
crewed
>>>>> up (and it was recently), but I can't reproduce it now.
>>>>>
>>>>> Can you try echoing 0 to congested_threshold_us in the cache set =
dir,
>>>>> and seeing if that fixes it?
>>>>>
>>>>>> There also seems to be some work needed with clean-up, since I'm
>>>>>> unfamiliar with how bcache works I attempted to make-bcache twic=
e,
>>>>>> thinking I'd start over. That worked, but because my cache devic=
e was
>>>>>> already registered I was unable to re-register my newly formatte=
d
>>>>>> cache dev, got "kobject_add_internal failed for bcache with -EEX=
IST,
>>>>>> don't try to register things with the same name in the same
>>>>>> directory." I was still able to use my cache device via the old =
uuid,
>>>>>> but this will probably cause problems on reboot. Perhaps an unre=
gister
>>>>>> file in /sys/fs/bcache would help, I also tried rmmod'ing bcache=
 to
>>>>>> see if I could clear /sys/fs/bcache, but no luck. make-bcache sh=
ould
>>>>>> perhaps check for an existing superblock, ask for confirmation, =
and
>>>>>> give some sort instruction on how to unregister, or do it for yo=
u if
>>>>>> you reformat.
>>>>>
>>>>> Yeah, I think for some reason bcache isn't opening the devices
>>>>> exclusively on 3.1. I'll have a look...
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-bca=
che" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
