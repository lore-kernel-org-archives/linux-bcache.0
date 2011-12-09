From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick bcache benchmark
Date: Fri, 9 Dec 2011 02:02:55 -0800
Message-ID: <CAC7rs0vvJbN6iOvvKJ3Xgm5BAzBxBYL+e6_F_ZzfREEbnC9-CA@mail.gmail.com>
References: <20111206082233.GA19390@moria>
	<CAEp_DRCHQo1JyPZk6dKYZjJvxtaR7yxpEDtGE+uYK9n2dNb2Pw@mail.gmail.com>
	<20111206115617.GA32759@moria>
	<CAEp_DRDEQLSkJ3arx81qM1M4iSJ5Wy0dwZhsrYD=94682qw8JQ@mail.gmail.com>
	<CALFpzo4s5ee23CMqNJbNUBW_wYBwc3gq0P8zzfAp8QSM+r_JLA@mail.gmail.com>
	<CALFpzo6ugO-5KHvrszp0bAYHY9eT8ADebbBqwgM3Y9FRS7PnGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALFpzo6ugO-5KHvrszp0bAYHY9eT8ADebbBqwgM3Y9FRS7PnGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bostjan Skufca <bostjan-CKT3X4mPfYE@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Weird. That wouldn't be blocksize - a tiny bucket size could cause
performance issues, but not consistent with what you describe.

Might be some sort of interaction with xfs, I'll have to see if I can
reproduce it.

On Thu, Dec 8, 2011 at 6:32 PM, Marcus Sorensen <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Got to try this out quickly this afternoon. Used 200GB hardware raid1
> caching for 8 disk, 8T raid 10. Enabled writeback, put xfs on bcache0.
> Mkfs.xfs took awhile, which was unusual. I mounted the filesystem, created
> an 8GB file, which was fast. Then ran some 512b random reads against it(16
> threads), almost sad speed. Switched same test to random writes, and it was
> as slow as spindle. Some of the threads even threw "blocked for 120 seconds"
> traces. I wonder if my blocksize is set wrong on the cache, sort of hard to
> find the appropriate numbers.
>
> On Dec 6, 2011 10:02 AM, "Marcus Sorensen" <shadowsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> I'm also curious as to how it decides what to keep in cache and whatto
>> toss out, what to write direct to platter and what to buffer. I'vebeen
>> testing LSI's cachecade 2.0 pro, and my intent is to post
>> somebenchmarks between the two. From what I've seen you get at most
>> 1/2performance of your SSD if everything could fit into cache, I'm
>> notsure if that's due to their algorithm and how they decide what's
>> SSDworthy and what's not.
