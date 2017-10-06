From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 11:23:53 -0700
Message-ID: <CAJ+L6qfm-LYY37YOSHWv-P0Tt++kpQ7cK30cD2VJMKnm09RAow@mail.gmail.com>
References: <1506497553-12552-1-git-send-email-tang.junhui@zte.com.cn>
 <CAJ+L6qfTDkgrLEUSRX2Pv2qvB7Ns=Hb3nBVz0SDoDn_m9RC8hg@mail.gmail.com>
 <2c39cd9c-34bd-5982-9fd7-ceb61305c13d@coly.li> <CAJ+L6qe7C=FyPFya8y0HV8SCc7VSEEuUApcqEUnouVDUByfZ5w@mail.gmail.com>
 <6a2052da-6b52-9c06-b85e-e3ea29e3f8e8@coly.li> <CAJ+L6qdqQn4tpFdkPZ-zhxss9O8axBEarMBJA5X6f9i+K8SLGg@mail.gmail.com>
 <CAJ+L6qe8rwbtO6tR-QNQBUApbeGQ9NGD=P9t5gtN9j0kzacJEQ@mail.gmail.com>
 <cb6db7c0-eaf7-f4a8-5584-8ce512575d74@coly.li> <CAJ+L6qdG70ExM7cnwYFLmCDBXY8SBErLhnMNeFVscXYemb_1SQ@mail.gmail.com>
 <18f2271b-87c2-530d-12da-dc2b4a5af1fd@coly.li> <CAJ+L6qcLc-=bbDJuaToDFPUWG=c4JKhKBQkivaw3tYWdjERmZw@mail.gmail.com>
 <b654ae09-b9f1-295f-b45a-6688c7fa4e0d@suse.de> <CAJ+L6qf7NtkqKFbKsEjr8noqG94nPQnj1z3doMh10DYH-vMniw@mail.gmail.com>
 <CAJ+L6qdQG27JpDTPxPrgYgeVC8qq-hYHq85U1zHQJDUneT8trA@mail.gmail.com>
 <dca3c016-bb3f-7d8c-1509-f042628d7fd6@coly.li> <CAJ+L6qcY=_vTaqZDLvif_3pqwujo24NUZhGG9ebp6z5+uWqwQQ@mail.gmail.com>
 <33e52793-251d-ed58-fb59-5432946efb56@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <33e52793-251d-ed58-fb59-5432946efb56@coly.li>
Sender: linux-block-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Hannes Reinecke <hare@suse.de>, Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

On Fri, Oct 6, 2017 at 11:09 AM, Coly Li <i@coly.li> wrote:
> If I use a 1.8T hard disk as cached device, and 1TB SSD as cache device,
> and set fio to write 500G dirty data in total. Is this configuration
> close to the working set and cache size you suggested ?

I think it's quicker and easier (and meaningful) to write 125-200G of
small blocks. (1/8 to 1/5)

Once you exceed 70% (CUTOFF_WRITEBACK_SYNC) you will get a **lot of
holes** because of write data skipping the cache.  And please note--
something I don't quite understand-- there is some kind of "write
amplification" happening somewhere.  When I write 30G, I get 38G of
dirty data; I wouldn't expect filesystem creation and metadata updates
to do this much.  At some point I need to trace and understand why
this is happening.

500G is probably still OK (1/2), but there starts to be a random
factor the more you write:

Basically, the more you write, the less-contiguous the data gets,
because writeback may have scanned through the volume once and written
out extents that are now "holes" in the middle of the data.  It'll
still be mostly contiguous but the effect is random.  (This is an
effect of the test scenario, not any of the code change).

Mike
