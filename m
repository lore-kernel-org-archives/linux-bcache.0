From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Sat, 7 Oct 2017 02:09:05 +0800
Message-ID: <33e52793-251d-ed58-fb59-5432946efb56@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li>
 <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li>
 <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li>
 <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li>
 <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
 <b654ae09-b9f1-295f-b45a-6688c7fa4e0d@suse.de>
 <CAJ+L6qf7NtkqKFbKsEjr8noqG94nPQnj1z3doMh10DYH-vMniw@mail.gmail.com>
 <CAJ+L6qdQG27JpDTPxPrgYgeVC8qq-hYHq85U1zHQJDUneT8trA@mail.gmail.com>
 <dca3c016-bb3f-7d8c-1509-f042628d7fd6@coly.li>
 <CAJ+L6qcY=_vTaqZDLvif_3pqwujo24NUZhGG9ebp6z5+uWqwQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qcY=_vTaqZDLvif_3pqwujo24NUZhGG9ebp6z5+uWqwQQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Hannes Reinecke <hare@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Hi Mike,

On 2017/10/7 上午1:36, Michael Lyle wrote:
> It's 240GB (half of a Samsung 850) in front of a 1TB 5400RPM disk.
> 

Copied.

> The size isn't critical.  1/8 is chosen to exceed 10% (default
> writeback dirty data thresh), it might need to be 1/6 on really big
> environments.  It needs to be big enough that it takes more than 100
> seconds to write back, but less than 40% of the cache[1].
>

OK, I will do similar thing.

> I am also running this on "mountain", which is my virtualization
> server.  It has 2x Samsung 950 PRO 512GB NVMe disks (MD raid1) in
> front of 2x Seagate Ironwolf 6TB (MD raid1) drivers.  I can't run
> benchmarks on it, but it runs nightly builds and is otherwise lightly
> loaded in the middle of night.  It does writeback for about 75 minutes
> on average after a set of nightly builds of my repositories (last 5
> days 75, 79, 77, 72, 76); without this patch set it was more like 80
> (77, 80, 74, 85, 84, 76, 82, 84).  It has 128GB of RAM and doesn't do

Is it the time from writeback starts to dirty reaches dirty target, or
the time from writeback starts to dirty reaches 0 ?

> many reads-- most of its hottest working set hits the page cache--
> bcache serves to accelerate the random writes its workloads generate.
> This is the workload that I sought to improve with the writeback
> changes.
> 
> When you ran the tests, did you compare 1-5 to 1-3?  Because

Yes, we did same thing. I only add/remove the last 2 patches about bio
reorder, the first 3 patches are always applied in my testing kernels.

> otherwise, another uncontrolled factor is the writeback tuning is
> drastically different with patch 2.  (On most systems patch 2 makes
> writeback less aggressive overall by default).

I observe this behavior :-) I always use the new PI controller in my
testings, it works fine.

> [1]: If you don't think this is fair--- this would match how I've been
> suggesting enterprise users set up bcache for various workloads-- a
> writeback cache isn't going to be very effective at lowering write
> workload if the size of the most active write working set doesn't fit
> nicely in the cache.  so e.g. if you deploy under a SQL database the
> cache should be double the size of the indices to get a real write
> aggregation benefit; if you deploy under an environment doing builds
> the cache should be double the size of the amount written during
> builds; if you deploy under an environment doing rapid VM provisioning
> the cache should be double the size of the images blitted per
> provisioning cycle, etc.
> 

If I use a 1.8T hard disk as cached device, and 1TB SSD as cache device,
and set fio to write 500G dirty data in total. Is this configuration
close to the working set and cache size you suggested ?

[snip]

Thanks.


-- 
Coly Li
