From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 4/5] bcache: writeback: collapse contiguous IO better
Date: Fri, 6 Oct 2017 04:09:20 -0700
Message-ID: <CAJ+L6qf7NtkqKFbKsEjr8noqG94nPQnj1z3doMh10DYH-vMniw@mail.gmail.com>
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
 <b654ae09-b9f1-295f-b45a-6688c7fa4e0d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b654ae09-b9f1-295f-b45a-6688c7fa4e0d@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Coly Li <i@coly.li>, Junhui Tang <tang.junhui@zte.com.cn>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Hannes--

Thanks for your input.

Assuming there's contiguous data to writeback, the dataset size is
immaterial; writeback gathers 500 extents from a btree, and writes
back up to 64 of them at a time.  With 8k extents, the amount of data
the writeback code is juggling at a time is about 4 megabytes at
maximum.

Optimizing writeback only does something significant when the chunks
to write back are relatively small, and when there's actual extents
next to each other to write back.

If there's big chunks, the spinning disk takes a long time to write
each one; and that time allows both the drive itself with native
command queueing and the IO scheduler lots of time to combine the
write.  Not to mention that even if there is a small delay due to
non-sequential / short-seek the difference in performance is minimal,
because 512k extents tie up the disk for a long time.

Also, I think the test scenario doesn't really have any adjacent
extents to writeback, which doesn't help.

I will forward performance data and complete scripts to run a
reasonable scenario.

Mike

On Fri, Oct 6, 2017 at 4:00 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 10/06/2017 12:42 PM, Michael Lyle wrote:
>> Coly--
>>
>> Holy crap, I'm not surprised you don't see a difference if you're
>> writing with 512K size!  The potential benefit from merging is much
>> less, and the odds of missing a merge is much smaller.  512KB is 5ms
>> sequential by itself on a 100MB/sec disk--- lots more time to wait to
>> get the next chunks in order, and even if you fail to merge the
>> potential benefit is much less-- if the difference is mostly
>> rotational latency from failing to merge then we're talking 5ms vs
>> 5+2ms.
>>
>> Do you even understand what you are trying to test?
>>
>> Mike
>>
>> On Fri, Oct 6, 2017 at 3:36 AM, Coly Li <i@coly.li> wrote:
>>> On 2017/10/6 =E4=B8=8B=E5=8D=885:20, Michael Lyle wrote:
>>>> Coly--
>>>>
>>>> I did not say the result from the changes will be random.
>>>>
>>>> I said the result from your test will be random, because where the
>>>> writeback position is making non-contiguous holes in the data is
>>>> nondeterministic-- it depends where it is on the disk at the instant
>>>> that writeback begins.  There is a high degree of dispersion in the
>>>> test scenario you are running that is likely to exceed the differences
>>>> from my patch.
>>>
>>> Hi Mike,
>>>
>>> I did the test quite carefully. Here is how I ran the test,
>>> - disable writeback by echo 0 to writeback_runing.
>>> - write random data into cache to full or half size, then stop the I/O
>>> immediately.
>>> - echo 1 to writeback_runing to start writeback
>>> - and record performance data at once
>>>
>>> It might be random position where the writeback starts, but there shoul=
d
>>> not be too much difference of statistical number of the continuous
>>> blocks (on cached device). Because fio just send random 512KB blocks
>>> onto cache device, the statistical number of contiguous blocks depends
>>> on cache device vs. cached device size, and how full the cache device i=
s
>>> occupied.
>>>
>>> Indeed, I repeated some tests more than once (except the md raid5 and m=
d
>>> raid0 configurations), the results are quite sable when I see the data
>>> charts, no big difference.
>>>
>>> If you feel the performance result I provided is problematic, it would
>>> be better to let the data talk. You need to show your performance test
>>> number to prove that the bio reorder patches are helpful for general
>>> workloads, or at least helpful to many typical workloads.
>>>
>>> Let the data talk.
>>>
>
> I think it would be easier for everyone concerned if Coly could attach
> the fio script / cmdline and the bcache setup here.
> There still is a chance that both are correct, as different hardware
> setups are being used.
> We've seen this many times trying to establish workable performance
> regression metrics for I/O; depending on the hardware one set of
> optimisations fail to deliver the expected benefit on other platforms.
> Just look at the discussion we're having currently with Ming Lei on the
> SCSI mailing list trying to improve sequential I/O performance.
>
> But please try to calm down everyone. It's not that Coly is deliberately
> blocking your patches, it's just that he doesn't see the performance
> benefit on his side.
> Might be that he's using the wrong parameters, but than that should be
> clarified once the fio script is posted.
>
> At the same time I don't think that the size of the dataset is
> immaterial. Larger datasets take up more space, and inevitably add more
> overhead just for looking up the data in memory. Plus Coly has some
> quite high-powered NVMe for the caching device, which will affect
> writeback patterns, too.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
