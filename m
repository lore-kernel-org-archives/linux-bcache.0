From: Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick bcache benchmark
Date: Fri, 9 Dec 2011 10:09:55 -0700
Message-ID: <CALFpzo6kXrC+8kkqrtRuMcsqnRL-oPc+B3A-Vq3wkWhRLBbAJw@mail.gmail.com>
References: <20111206082233.GA19390@moria>
	<CAEp_DRCHQo1JyPZk6dKYZjJvxtaR7yxpEDtGE+uYK9n2dNb2Pw@mail.gmail.com>
	<20111206115617.GA32759@moria>
	<CAEp_DRDEQLSkJ3arx81qM1M4iSJ5Wy0dwZhsrYD=94682qw8JQ@mail.gmail.com>
	<CALFpzo4s5ee23CMqNJbNUBW_wYBwc3gq0P8zzfAp8QSM+r_JLA@mail.gmail.com>
	<CALFpzo6ugO-5KHvrszp0bAYHY9eT8ADebbBqwgM3Y9FRS7PnGw@mail.gmail.com>
	<CAC7rs0vvJbN6iOvvKJ3Xgm5BAzBxBYL+e6_F_ZzfREEbnC9-CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC7rs0vvJbN6iOvvKJ3Xgm5BAzBxBYL+e6_F_ZzfREEbnC9-CA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Here's some more info. I'm running kernel 3.1.4. When I do random
writes, the 'bypassed' number increases in stats. Now I'm random
writing direct to /dev/bcache0 and get the same result.

The application I'm using to test does the following:

1. looks at size of test file
2. divides size of file by a cmd line specified io size (tried 512b
and 4k) and considers that the blockcount for file
3. randomly selects a block number between 0 and blockcount
4. writes a random string of characters of blocksize to specified block
5. repeat 3 and 4

I'll try a few other benchmark tools.

[root@sansrv2-10 bcache]# for i in `ls`; do echo -n "$i "; cat $i; done
label
readahead 0
running 1
sequential_cutoff 4.0M
sequential_merge 1
state dirty
verify 0
writeback 1
writeback_delay 30
writeback_metadata 1
writeback_percent 0
writeback_running 1

SSD benchmark:
[root@sansrv2-10 ~]# ./seekmark -t16 -q -w destroy-data -f /dev/sde

WRITE benchmarking against /dev/sde 218880 MB


total time: 5.39, time per WRITE request(ms): 0.067
14839.55 total seeks per sec, 927.47 WRITE seeks per sec per thread

bcache0 benchmark:

[root@sansrv2-10 ~]# ./seekmark -t16 -q -w destroy-data -f /dev/bcache0

WRITE benchmarking against /dev/bcache0 7628799 MB


total time: 510.75, time per WRITE request(ms): 6.384
156.63 total seeks per sec, 9.79 WRITE seeks per sec per thread


There also seems to be some work needed with clean-up, since I'm
unfamiliar with how bcache works I attempted to make-bcache twice,
thinking I'd start over. That worked, but because my cache device was
already registered I was unable to re-register my newly formatted
cache dev, got "kobject_add_internal failed for bcache with -EEXIST,
don't try to register things with the same name in the same
directory." I was still able to use my cache device via the old uuid,
but this will probably cause problems on reboot. Perhaps an unregister
file in /sys/fs/bcache would help, I also tried rmmod'ing bcache to
see if I could clear /sys/fs/bcache, but no luck. make-bcache should
perhaps check for an existing superblock, ask for confirmation, and
give some sort instruction on how to unregister, or do it for you if
you reformat.








On Fri, Dec 9, 2011 at 3:02 AM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Weird. That wouldn't be blocksize - a tiny bucket size could cause
> performance issues, but not consistent with what you describe.
>
> Might be some sort of interaction with xfs, I'll have to see if I can
> reproduce it.
>
> On Thu, Dec 8, 2011 at 6:32 PM, Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Got to try this out quickly this afternoon. Used 200GB hardware raid1
>> caching for 8 disk, 8T raid 10. Enabled writeback, put xfs on bcache0.
>> Mkfs.xfs took awhile, which was unusual. I mounted the filesystem, created
>> an 8GB file, which was fast. Then ran some 512b random reads against it(16
>> threads), almost sad speed. Switched same test to random writes, and it was
>> as slow as spindle. Some of the threads even threw "blocked for 120 seconds"
>> traces. I wonder if my blocksize is set wrong on the cache, sort of hard to
>> find the appropriate numbers.
>>
>> On Dec 6, 2011 10:02 AM, "Marcus Sorensen" <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>> I'm also curious as to how it decides what to keep in cache and whatto
>>> toss out, what to write direct to platter and what to buffer. I'vebeen
>>> testing LSI's cachecade 2.0 pro, and my intent is to post
>>> somebenchmarks between the two. From what I've seen you get at most
>>> 1/2performance of your SSD if everything could fit into cache, I'm
>>> notsure if that's due to their algorithm and how they decide what's
>>> SSDworthy and what's not.
