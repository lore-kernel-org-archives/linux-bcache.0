From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 10:53:39 -0700
Message-ID: <CAJ+L6qc=Ndi-6JD2Jt5QgDEm5NLmxRBbGnzxLrqDHzJzG7LbHA@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qcyq-E4MrWNfB9kGA8DMD_U1HMxJii-=-qPfv0LeRL45w@mail.gmail.com>
 <CAJ+L6qdc8YqO5B3Cv0h4QQ+4P06FbtsT10Jqt5=Fx8iRh1UGwQ@mail.gmail.com>
 <96f34768-2b02-7849-c034-e1bb83b0fa0d@coly.li> <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li> <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li> <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li> <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li> <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li> <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
 <8c7574ae-f520-bb7b-a974-ad747f9555cf@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <8c7574ae-f520-bb7b-a974-ad747f9555cf@coly.li>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Just one more note:

On Fri, Oct 6, 2017 at 5:20 AM, Coly Li <i@coly.li> wrote:
> [snip]
> And when we talked about patch 5/5, you mentioned 1MB writes:
> "- When writeback rate is medium, it does I/O more efficiently.  e.g.
> if the current writeback rate is 10MB/sec, and there are two
> contiguous 1MB segments, they would not presently be combined.  A 1MB
> write would occur, then we would increase the delay counter by 100ms,
> and then the next write would wait; this new code would issue 2 1MB
> writes one after the other, and then sleep 200ms.  On a disk that does
> 150MB/sec sequential, and has a 7ms seek time, this uses the disk for
> 13ms + 7ms, compared to the old code that does 13ms + 7ms * 2.  This
> is the difference between using 10% of the disk's I/O throughput and
> 13% of the disk's throughput to do the same work."
>
> Then I assume the bio reorder patches should work well for write size
> from 4KB to 1MB. Also I think "hmm, if the write size is smaller, there
> will be less chance for dirty blocks to be contiguous on cached device",
> then I choose 512KB.

Please note those two conversations were talking about different
controversial stuff in response to different questions from you.
There's the ordering change, which is expected to improve peak
writeback rate for small blocks.  The test scenarios we're running
right now are mostly trying to measure that.  There needs to be
relatively small I/O to see a difference-- that is, backing disk
access time needs to dominate to make a difference.

The other is the change in I/O aggregation behavior when writeback
rate is not maximum.  That's what I was discussing with the 1MB I/O
example.    Unfortunately it is difficult to craft a test scenario to
test this one, but the argument of why it is better is pretty simple:

-  It's much better to aggregate a few contiguous I/Os and issue them
together than to issue them some time apart because of rate limiting.
The new code will aggregate a limited number of contiguous writes even
if it doesn't have to, to meet rate.  That is, it's much better for
disk utilization to issue 5 256k writes that are sequential to each
other at the same time, and then delay 250ms instead of one at a time,
50ms apart.  In the first case, it might be a 7ms access + 13ms of
writing and then 230ms of sleeping (8% disk time used); in the second
case, if user I/O is seeking the disk away from where we're writing,
it'll be 5 groups of: 7ms access + 2.5ms writing and then 40.5ms of
sleeping (24% disk time used).

Mike
