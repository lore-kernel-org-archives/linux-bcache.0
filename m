From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Mon, 9 Oct 2017 17:00:15 -0700
Message-ID: <CAJ+L6qeAbWXUu5BA94NBew+FYGcKV9S2957=aT10xGrkD2F4iA@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li> <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li> <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li> <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
 <b654ae09-b9f1-295f-b45a-6688c7fa4e0d@suse.de> <CAJ+L6qf7NtkqKFbKsEjr8noqG94nPQnj1z3doMh10DYH-vMniw@mail.gmail.com>
 <CAJ+L6qdQG27JpDTPxPrgYgeVC8qq-hYHq85U1zHQJDUneT8trA@mail.gmail.com>
 <dca3c016-bb3f-7d8c-1509-f042628d7fd6@coly.li> <CAJ+L6qcY=_vTaqZDLvif_3pqwujo24NUZhGG9ebp6z5+uWqwQQ@mail.gmail.com>
 <33e52793-251d-ed58-fb59-5432946efb56@coly.li> <CAJ+L6qdnzocZRvcExwFBJPmVJnHWNJXY8j3NioUaekAp06QzXg@mail.gmail.com>
 <058dc73f-a36f-c3c2-8dc3-833545979693@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:55189 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755457AbdJJAAS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Oct 2017 20:00:18 -0400
Received: by mail-qt0-f179.google.com with SMTP id z19so1081274qtg.11
        for <linux-bcache@vger.kernel.org>; Mon, 09 Oct 2017 17:00:18 -0700 (PDT)
In-Reply-To: <058dc73f-a36f-c3c2-8dc3-833545979693@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Hannes Reinecke <hare@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

Hi Coly--

We talked a bunch on IRC, so I'd just like to answer a couple of the
things again here for the benefit of everyone else / further
discussion.

On Mon, Oct 9, 2017 at 11:58 AM, Coly Li <i@coly.li> wrote:
> I do observe the perfect side of your patches, when I/O blocksize
> <=256kB, I see great advantage of writeback performance when bio
> reordered. Especially when blocksiz is 8K, writeback performance is 3x
> at least (because without your patch the writeback is too slow and I
> gave up after hours).
>
> The performance regression happens when fio blocksize increased to 512K
> and dirty data increased to 900GB. And when fio blocksize increased to
> 1MB and dirty data on cache increased to 900, writeback performance
> regression becomes easily recognized.
>
> An interesting behavior I observed is, for large blocksize and dirty
> data, without bio reorder patches, writeback performance is much higher
> than the bio reorder one. An example is,
> http://blog.coly.li/wp-content/uploads/2017/10/writeback_throughput_on_linear_900_1800G_cache_half.png
>
> The first 15 minutes, bcache without bio reorder performs much higher
> than the reorder one. 15 minutes later, all the writeback rate decreased
> to a similar level. That's said, most of the performance regression
> happens at the beginning when writeback starts.

I have looked at this and I believe I understand why.  Patch 4 changes
the issuance of sequential I/O.  It limits how much writeback will be
issued at a time, as opposed to being willing to issue any amount in
the previous code:

+                       if (size >= MAX_WRITESIZE_IN_PASS)
+                               break;

MAX_WRITESIZE_IN_PASS corresponds to 2500 KBytes, or it'll hit the
limit with 2 1MB blocks issued and then go back to delay.

The reason I put these lines here is to prevent from issuing a set of
writebacks that are so large that they tie up the backing disk for a
very long time and hurt interactive performance.  We could make it
tunable, though I'm hesitant to have too many tunables as it'll make
testing and verifying all this difficult.

> All the tests are under ideal situations, no writeback happens when fio
> writes dirty data onto cache device. If in more generic situations when
> less LBA contiguous dirty blocks on cache, I guess the writeback
> regression might be more obvious.

I think it is because of this conditional which is confined to only
LBA contiguous things.  We could remove the conditional but it's there
to try and preserve interactive/frontend performance during writeback.

> When dirty blocks are not LBA contiguous on cache device, for small
> dirty block size, I don't worry. Because you explained in previous
> emails clearly, the worst case is the performance backing to the numbers
> which has no bio reorder patch. But for large blocksize and large dirty
> data, that's the common case when bcache is used for distributed
> computing/storage systems like Ceph or Hadoop (multiple hard drives
> attached to a large SSD cache, normally object file sizes are from 4MB
> to 128MB).

I don't think a SSD cache will help the big block portion of workloads
like this much, as they're not access-time constrained but instead
bandwidth constrained.  That's why, default configuration of bcache is
for >=4MB sequential stuff to bypass the cache and go directly to the
spinning disks.

Even if the SSD has twice the bandwidth of the spinning disk array,
everything written back needs to be written to the SSD and then later
read for writeback, so it's no quicker at steady state.

[snip]
> I raise a green flag to your bio reorder patches :-) I do hope I could
> have seen such performance data at first time :P
>
> *Last one question*: Could you please to consider an option to
> enable/disable the bio reorder code in sysfs? It can be enabled as
> default. When people cares about large dirty data size writeback, they
> can choose to disable the bio reorder policy.

I don't think it's the bio reorder code itself, but instead a change
in how we delay for writeback.  I wrote the new stuff to try and be a
better compromise between writeback rate and interactive performance.

My biggest concern is, that both the old code and the new code-- seems
to be writing back at about only 25-33% of the speed that your disks
should be capable of in this case.  I think that's a bigger issue than
the small difference in performance in this specific case.

Mike
