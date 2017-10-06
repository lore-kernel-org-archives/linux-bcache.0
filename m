From: Coly Li <i@coly.li>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 20:37:51 +0800
Message-ID: <dca3c016-bb3f-7d8c-1509-f042628d7fd6@coly.li>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qdTB6DyhD8UwHaVtN-THXwanBXrQK3EvmvLhuoXgYyzrA@mail.gmail.com>
 <05c1aa86-5fc8-f330-5cd1-46f9ba7cd3e0@coly.li>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJ+L6qdQG27JpDTPxPrgYgeVC8qq-hYHq85U1zHQJDUneT8trA@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Hannes Reinecke <hare@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On 2017/10/6 下午7:57, Michael Lyle wrote:
> OK, here's some data:  http://jar.lyle.org/~mlyle/writeback/
> 
> The complete test script is there to automate running writeback
> scenarios--- NOTE DONT RUN WITHOUT EDITING THE DEVICES FOR YOUR
> HARDWARE.
> 
> Only one run each way, but they take 8-9 minutes to run, we can easily
> get more ;)  I compared patches 1-3 (which are uncontroversial) to
> 1-5.
> 
> Concerns I've heard:
> 
> - The new patches will contend for I/O bandwidth with front-end writes:
> 
> No:
>  3 PATCHES: write: io=29703MB, bw=83191KB/s, iops=10398, runt=365618msec
> vs
>  5 PATCHES: write: io=29746MB, bw=86177KB/s, iops=10771, runt=353461msec
> 
> It may actually be slightly better-- 3% or so.
> 
> - The new patches will not improve writeback rate.
> 
> No:
> 
> 3 PATCHES: the active period of the test was 366+100=466 seconds, and
> at the end there was 33.4G dirty.
> 5 PATCHES: the active period of the test was 353+100=453 seconds, and
> at the end there was 32.7G dirty.
> 
> This is a moderate improvement.
> 
> - The IO scheduler can combine the writes anyways so this type of
> patch will not increase write queue merge.
> 
> No:
> 
> Average wrqm/s is 1525.4 in the 3 PATCHES dataset; average wrqm/s is
> 1643.7 in the 5 PATCHES dataset.
> 
> During the last 100 seconds, when ONLY WRITEBACK is occurring, wrqm is
> 1398.0 in 3 PATCHES, and 1811.6 with 5 PATCHES.
> 
> - Front-end latency will suffer:
> 
> No:
> 
> The datasets look the same to my eye.  By far the worst thing is the
> occasional 1000ms+ times the bcache goes to sleep in both scenarios,
> contending for the writeback lock (not affected by these patches, but
> an item for future work if I ever get to move on to a new topic).
> 
> Conclusion:
> 
> These patches provide a small but significant improvement in writeback
> rates, that can be seen with careful testing that produces actual
> sequential writeback.  They lay the groundwork for further
> improvements, through the use of plugging the block layer and to allow
> accelerated writeback when the device is idle.
> 
[snip]

Hi Mike,

Thank you for the detailed information!

In your test, dirty data occupies 1/8 space of CACHEDEVICE, can I know
exact sizes of the cache device and cached device, then I will set up a
similar configuration on my machine, and try to reproduce the test.

-- 
Coly Li
