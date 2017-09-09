From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: PI controller for writeback rate V2
Date: Sat, 9 Sep 2017 20:34:33 +0800
Message-ID: <65f1bb5f-76ef-4b75-5068-1350cb2e2d49@suse.de>
References: <20170908031719.23988-1-mlyle@lyle.org>
 <f72a99ef-4219-947c-c622-31cdafdaa079@suse.de>
 <CAJ+L6qe6RikRR9empP_SxveXdyk-sCsoOi11CmxZsDiT1xf4og@mail.gmail.com>
 <CAJ+L6qfZG7sR8Rb==V9jAP3JjOOzCuUq+mve_hzHszwPeoqL0w@mail.gmail.com>
 <2fa508c0-5d86-9f8b-4919-806009e5b29a@coly.li>
 <CAJ+L6qdF=ffE47tYfT-cYYvuVGT4_OAZZ6XXPmXPuuL9dBAbDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756989AbdIIMen (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 Sep 2017 08:34:43 -0400
In-Reply-To: <CAJ+L6qdF=ffE47tYfT-cYYvuVGT4_OAZZ6XXPmXPuuL9dBAbDQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/9/9 上午2:49, Michael Lyle wrote:
> On Fri, Sep 8, 2017 at 10:17 AM, Coly Li <i@coly.li> wrote:
>> On 2017/9/9 上午12:42, Michael Lyle wrote:
>>> On Thu, Sep 7, 2017 at 10:52 PM, Coly Li <colyli@suse.de> wrote:
>>> [snip history]
>>
>> This assumption is not always correct. If heavy front end I/Os coming
>> every "writeback_rate_update_seconds" seconds, the writeback rate just
>> raises to a high number, this situation may have negative contribution
>> to I/O latency of front end I/Os.
> 
> I'm confused by this.  We're not taking the derivative, but the
> absolute number of dirty blocks.  It doesn't matter whether they
> arrive every writeback_rate_update_seconds, every millisecond, every
> 15 seconds, or whatever.  The net result is almost identical.
> 

Hi Mike,

I run the code today. I see your PI controller has a nice behavior that,
when the dirty data decreased (by writeback) and closed to target,
writeback rate decreases step by step, and stable to be minimum value
when dirty data is very close and equal to target number. The above text
is what I observe from current PD controller, your PI controller does
not have such a behavior, so this question is invalid, please ignore it.


> e.g. compare http://jar.lyle.org/~mlyle/ctr/10000-per-second.png
> http://jar.lyle.org/~mlyle/ctr/20000-every-2-seconds.png
> http://jar.lyle.org/~mlyle/ctr/50000-every-5-seconds.png
> or for a particularly "bad" case
> http://jar.lyle.org/~mlyle/ctr/90000-every-9-seconds.png where it is
> still well behaved (I don't think we want a completely steady rate as
> chunks of IO slow down, too, but for the control system to start to
> respond...
> 



The real system can not work as perfect as the charts do. Bcache uses
the writeback rate to calculate a delay time, and controls writeback
speed by length of delay between each writeback I/O. Which means if
cached device is too slow, higher writeback rate does not help at all.

E.g. when writing dirty data from cache device back to cached device,
almost all the I/Os are random writes onto backing hard disk, the best
writing throughput on my SATA disk is no more then 10MB/s. Although from
writeback_rate_debug the rate number is 488MB.

Therefore I don't care too much about the chart in theory or emulation,
I can about performance number on real system.

>> It may not be exact "writeback_rate_update_seconds" seconds, this is
>> just an example for some king of "interesting" I/O pattern to show that
>> higher writeback_rate_minimum may not always be helpful.
> 
> writeback_rate_minimum is only used as an *absolute rate* of 5 sectors
> per second.  It is not affected by the rate of arrival of IO
> requests-- either the main control system comes up with a rate that is
> higher than it, or it is bounded to this exact rate (which is almost
> nothing).
> 
>>>>> +     if ((error < 0 && dc->writeback_rate_integral > 0) ||
>>>>> +         (error > 0 && time_before64(local_clock(),
>>>>> +                      dc->writeback_rate.next + NSEC_PER_MSEC))) {
>>>>> +             /* Only decrease the integral term if it's more than
>>>>> +              * zero.  Only increase the integral term if the device
>>>>> +              * is keeping up.  (Don't wind up the integral
>>>>> +              * ineffectively in either case).
>>>>> +              *
>>>>> +              * It's necessary to scale this by
>>>>> +              * writeback_rate_update_seconds to keep the integral
>>>>> +              * term dimensioned properly.
>>>>> +              */
>>>>> +             dc->writeback_rate_integral += error *
>>>>> +                     dc->writeback_rate_update_seconds;
>>>>
>>>> I am not sure whether it is correct to calculate a integral value here.
>>>> error here is not a per-second value, it is already a accumulated result
>>>> in past "writeback_rate_update_seconds" seconds, what does it mean for
>>>> "error * dc->writeback_rate_update_seconds" ?
>>>>
>>>> I know here you are calculating a integral value of error, but before I
>>>> understand why you use "error * dc->writeback_rate_update_seconds", I am
>>>> not able to say whether it is good or not.
>>>
>>> The calculation occurs every writeback_rate_update_seconds.  An
>>> integral is the area under a curve.
>>>
>>> If the error is currently 1, and has been 1 for the past 5 seconds,
>>> the integral increases by 1 * 5 seconds.  There are two approaches
>>> used in numerical integration, a "rectangular integration" (which this
>>> is, assuming the value has held for the last 5 seconds), and a
>>> "triangular integration", where the average of the old value and the
>>> new value are averaged and multiplied by the measurement interval.  It
>>> doesn't really make a difference-- the triangular integration tends to
>>> come up with a slightly more accurate value but adds some delay.  (In
>>> this case, the integral has a time constant of thousands of
>>> seconds...)
>>>
>>
>> Hmm, imagine we have a per-second sampling, and the data is:
>>
>>    time point       dirty data (MB)
>>         1               1
>>         1               1
>>         1               1
>>         1               1
>>         1               10
>>
>> Then a more accurate integral result should be: 1+1+1+1+10 = 14. But by
>> your "rectangular integration" the result will be 10*5 = 50.
>>
>> Correct me if I am wrong, IMHO 14:50 is a big difference.
> 
> It's irrelevant-- the long term results will be the same, and the
> short term results are fundamentally the same.  That is, the
> proportional controller with 10MB of excess data will seek to write
> 10MB/40 = 250,000 bytes per second more.  The integral term at 50MB
> will seek to write 5000 bytes more; at 14MB will seek to write out
> 1400 bytes more/second.  That is, it makes a 1.4% difference in write
> rate (1-255000/251400) in this contrived case in the short term, and
> these biases fundamentally only last one cycle long...
> 
> A triangular integration would result in (1+10) / 2 * 5 = 27.5, or
> would pick the rate 252750, or even less of a difference...
> 

Oh, I see. Indeed my initial question was, why not calculate
writeback_rate_integral just by:
	dc->writeback_rate_integral += error;
From your explaining, I know it is because the integral part is a really
small portion, the difference can be ignored.

> And as it stands now, the current controller just takes the rate error
> from the end of the interval, so it does a rectangular integration.
> That is, both integrals slightly underestimate dirty data's integral
> when it's rising and slightly overestimate falling.  Short of sampling
> a bunch more this is something that fundamentally can't be corrected
> and all real-world control systems live with.
> 
> Note: this isn't my first time implementing a control system-- I am
> maintainer of a drone autopilot that has controllers six layers deep
> with varying bandwidth for each (position, velocity, acceleration,
> attitude, angular rate, actuator effect) that gets optimal system
> performance from real-world aircraft...
> 
You are so nice. I just come to understand P/I/D controller by bing.com,
and you are the first and only people I communicate with whom has
experience on P/I/D controller. And you give me very informative
explanation how your PI controller is designed.

So I do a benchmark very early this morning, and get a result to share
with you.

I just run this patch on a Lenovo X3650 M5 server with a 3.8T NVMe SSD
(cache device) and a 1.8T SATA disk (backing device). Since only a small
portion of SSD is used, I can almost ignore the I/O latency due to SSD
internal garbage collection.

Then I use fio to write 300G dirty data onto the cache device, with 4K
block size. At this moment, out put of
/sys/block/bcache0/bcache/writeback_rate_debug is,
rate:		488M/sec
dirty:		111G
target:		35.7G
proportional:	1.9G
integral:	32.4M
change:		0/sec
next io:	-166ms
From iostate the real happens wrteback rate is 2~7MB/s

Now I write 1048576 blocks, read 32768 blocks back, block size is 4KB.
All reads hit cached device, the latency distribution is,
latency distribution:
lat_ms[0]: 32635
lat_ms[1]: 165
lat_us[0]: 2067
lat_us[1]: 4632
lat_us[2]: 303
lat_us[3]: 271
lat_us[4]: 148
lat_us[5]: 20
lat_us[6]: 5
lat_us[7]: 1
lat_us[15]: 6
lat_us[16]: 9
lat_us[17]: 4
lat_us[18]: 1
lat_us[19]: 1
lat_us[20]: 1
lat_us[39]: 10
lat_us[40]: 11
lat_us[41]: 1
lat_us[42]: 2
lat_us[75]: 49
lat_us[76]: 2127
lat_us[77]: 14721
lat_us[78]: 42311
lat_us[79]: 38608
lat_us[80]: 20751
lat_us[81]: 9299
lat_us[82]: 3697
lat_us[83]: 1759
lat_us[84]: 987
lat_us[85]: 792
lat_us[86]: 719
lat_us[87]: 648
lat_us[88]: 538
lat_us[89]: 962
lat_us[90]: 5962
lat_us[91]: 27448
lat_us[92]: 45023
lat_us[93]: 32612
lat_us[94]: 16439
lat_us[95]: 7440
lat_us[96]: 3248
lat_us[97]: 1527
lat_us[98]: 987
lat_us[99]: 834
lat_us[100]: 611
lat_us[101]: 519
lat_us[102]: 441
lat_us[103]: 398
lat_us[104]: 344
lat_us[105]: 266
lat_us[106]: 306
lat_us[107]: 329
lat_us[108]: 341
lat_us[109]: 330
lat_us[110]: 269
lat_us[111]: 192
lat_us[112]: 129
lat_us[113]: 62
lat_us[114]: 54
lat_us[115]: 41
lat_us[116]: 24
lat_us[117]: 17
lat_us[118]: 28
lat_us[119]: 15
lat_us[120]: 8
lat_us[121]: 13
lat_us[122]: 9
lat_us[123]: 7
lat_us[124]: 11
lat_us[125]: 12
lat_us[126]: 8
lat_us[127]: 11
lat_us[128]: 4
lat_us[129]: 7
lat_us[130]: 9
lat_us[131]: 6
lat_us[132]: 16
lat_us[133]: 12
lat_us[134]: 4
lat_us[135]: 2
lat_us[136]: 7
lat_us[137]: 8
lat_us[138]: 3
lat_us[139]: 6
lat_us[140]: 5
lat_us[141]: 6
lat_us[142]: 4
lat_us[143]: 7
lat_us[144]: 4
lat_us[145]: 5
lat_us[146]: 3
lat_us[148]: 5
lat_us[149]: 2
lat_us[150]: 3
lat_us[151]: 2
lat_us[152]: 5
lat_us[153]: 5
lat_us[154]: 3
lat_us[155]: 2
lat_us[156]: 1
lat_us[157]: 3
lat_us[158]: 1
lat_us[164]: 1
lat_us[165]: 1
lat_us[166]: 1
lat_us[167]: 1
lat_us[170]: 1
lat_us[171]: 2
lat_us[181]: 1
lat_us[207]: 1
lat_us[224]: 1
lat_us[704]: 2
lat_us[705]: 2
lat_us[706]: 5
lat_us[707]: 2
lat_us[708]: 2
lat_us[710]: 2
lat_us[711]: 3
lat_us[712]: 1
lat_us[714]: 2
lat_us[715]: 1
lat_us[717]: 5
lat_us[718]: 1
lat_us[719]: 4
lat_us[720]: 2
lat_us[721]: 1
lat_us[722]: 3
lat_us[723]: 2
lat_us[725]: 1
lat_us[726]: 1
lat_us[727]: 4
lat_us[728]: 2
lat_us[729]: 6
lat_us[730]: 1
lat_us[731]: 2
lat_us[732]: 3
lat_us[733]: 2
lat_us[734]: 6
lat_us[735]: 5
lat_us[736]: 5
lat_us[737]: 9
lat_us[738]: 6
lat_us[739]: 9
lat_us[740]: 3
lat_us[741]: 2
lat_us[742]: 5
lat_us[743]: 8
lat_us[744]: 3
lat_us[745]: 7
lat_us[746]: 10
lat_us[747]: 13
lat_us[748]: 13
lat_us[749]: 13
lat_us[750]: 10
lat_us[751]: 6
lat_us[752]: 14
lat_us[753]: 13
lat_us[754]: 9
lat_us[755]: 11
lat_us[756]: 12
lat_us[757]: 14
lat_us[758]: 13
lat_us[759]: 5
lat_us[760]: 14
lat_us[761]: 10
lat_us[762]: 12
lat_us[763]: 9
lat_us[764]: 15
lat_us[765]: 9
lat_us[766]: 18
lat_us[767]: 6
lat_us[768]: 10
lat_us[769]: 16
lat_us[770]: 12
lat_us[771]: 15
lat_us[772]: 20
lat_us[773]: 10
lat_us[774]: 19
lat_us[775]: 15
lat_us[776]: 20
lat_us[777]: 15
lat_us[778]: 18
lat_us[779]: 20
lat_us[780]: 14
lat_us[781]: 19
lat_us[782]: 23
lat_us[783]: 17
lat_us[784]: 16
lat_us[785]: 13
lat_us[786]: 17
lat_us[787]: 16
lat_us[788]: 16
lat_us[789]: 6
lat_us[790]: 13
lat_us[791]: 12
lat_us[792]: 6
lat_us[793]: 21
lat_us[794]: 9
lat_us[795]: 14
lat_us[796]: 8
lat_us[797]: 14
lat_us[798]: 12
lat_us[799]: 11
lat_us[800]: 12
lat_us[801]: 17
lat_us[802]: 19
lat_us[803]: 15
lat_us[804]: 19
lat_us[805]: 13
lat_us[806]: 22
lat_us[807]: 19
lat_us[808]: 14
lat_us[809]: 11
lat_us[810]: 15
lat_us[811]: 14
lat_us[812]: 27
lat_us[813]: 22
lat_us[814]: 14
lat_us[815]: 17
lat_us[816]: 16
lat_us[817]: 7
lat_us[818]: 9
lat_us[819]: 8
lat_us[820]: 14
lat_us[821]: 11
lat_us[822]: 18
lat_us[823]: 19
lat_us[824]: 8
lat_us[825]: 13
lat_us[826]: 9
lat_us[827]: 13
lat_us[828]: 16
lat_us[829]: 10
lat_us[830]: 6
lat_us[831]: 7
lat_us[832]: 12
lat_us[833]: 6
lat_us[834]: 11
lat_us[835]: 13
lat_us[836]: 16
lat_us[837]: 11
lat_us[838]: 12
lat_us[839]: 16
lat_us[840]: 15
lat_us[841]: 6
lat_us[842]: 8
lat_us[843]: 11
lat_us[844]: 17
lat_us[845]: 11
lat_us[846]: 13
lat_us[847]: 17
lat_us[848]: 16
lat_us[849]: 20
lat_us[850]: 18
lat_us[851]: 13
lat_us[852]: 15
lat_us[853]: 5
lat_us[854]: 7
lat_us[855]: 11
lat_us[856]: 15
lat_us[857]: 15
lat_us[858]: 20
lat_us[859]: 17
lat_us[860]: 9
lat_us[861]: 10
lat_us[862]: 12
lat_us[863]: 9
lat_us[864]: 7
lat_us[865]: 10
lat_us[866]: 17
lat_us[867]: 5
lat_us[868]: 7
lat_us[869]: 6
lat_us[870]: 6
lat_us[871]: 3
lat_us[872]: 5
lat_us[873]: 6
lat_us[874]: 8
lat_us[875]: 6
lat_us[876]: 7
lat_us[877]: 6
lat_us[878]: 13
lat_us[879]: 16
lat_us[880]: 7
lat_us[881]: 6
lat_us[882]: 6
lat_us[883]: 10
lat_us[884]: 12
lat_us[885]: 4
lat_us[886]: 8
lat_us[887]: 5
lat_us[888]: 8
lat_us[889]: 9
lat_us[890]: 8
lat_us[891]: 9
lat_us[892]: 8
lat_us[893]: 5
lat_us[894]: 5
lat_us[895]: 5
lat_us[896]: 9
lat_us[897]: 12
lat_us[898]: 5
lat_us[899]: 11
lat_us[900]: 10
lat_us[901]: 3
lat_us[902]: 9
lat_us[903]: 5
lat_us[904]: 5
lat_us[905]: 7
lat_us[906]: 9
lat_us[907]: 3
lat_us[908]: 5
lat_us[909]: 6
lat_us[910]: 5
lat_us[911]: 3
lat_us[912]: 5
lat_us[913]: 5
lat_us[914]: 11
lat_us[915]: 8
lat_us[916]: 9
lat_us[917]: 10
lat_us[918]: 9
lat_us[919]: 5
lat_us[920]: 12
lat_us[921]: 5
lat_us[922]: 2
lat_us[923]: 8
lat_us[924]: 7
lat_us[925]: 4
lat_us[926]: 9
lat_us[927]: 9
lat_us[928]: 6
lat_us[929]: 8
lat_us[930]: 9
lat_us[931]: 6
lat_us[932]: 6
lat_us[933]: 9
lat_us[934]: 4
lat_us[935]: 4
lat_us[936]: 2
lat_us[937]: 4
lat_us[938]: 3
lat_us[939]: 6
lat_us[940]: 2
lat_us[941]: 4
lat_us[942]: 6
lat_us[943]: 4
lat_us[944]: 8
lat_us[945]: 1
lat_us[946]: 8
lat_us[947]: 10
lat_us[948]: 4
lat_us[949]: 8
lat_us[950]: 7
lat_us[951]: 4
lat_us[952]: 2
lat_us[953]: 3
lat_us[954]: 7
lat_us[955]: 6
lat_us[956]: 5
lat_us[957]: 8
lat_us[958]: 5
lat_us[959]: 12
lat_us[960]: 4
lat_us[961]: 6
lat_us[962]: 6
lat_us[963]: 4
lat_us[964]: 6
lat_us[965]: 8
lat_us[966]: 5
lat_us[967]: 7
lat_us[968]: 9
lat_us[969]: 11
lat_us[970]: 9
lat_us[971]: 7
lat_us[972]: 9
lat_us[973]: 7
lat_us[974]: 9
lat_us[975]: 10
lat_us[976]: 14
lat_us[977]: 12
lat_us[978]: 23
lat_us[979]: 11
lat_us[980]: 18
lat_us[981]: 15
lat_us[982]: 25
lat_us[983]: 22
lat_us[984]: 23
lat_us[985]: 22
lat_us[986]: 17
lat_us[987]: 16
lat_us[988]: 21
lat_us[989]: 21
lat_us[990]: 22
lat_us[991]: 8
lat_us[992]: 21
lat_us[993]: 26
lat_us[994]: 24
lat_us[995]: 24
lat_us[996]: 23
lat_us[997]: 20
lat_us[998]: 14

Now I back to current PD controller, do same testing step.
out put of /sys/block/bcache0/bcache is,
rate:		131M/sec
dirty:		112G
target:		35.7G
proportional:	65.6M
derivative:	-1.0k
change:		0/sec
next io:	-2163ms
From iostate the real happens wrteback rate is 3~5MB/s

latency distribution:
latency distribution:
lat_ms[0]: 31688
lat_ms[1]: 112
lat_ms[2]: 6
lat_us[0]: 2889
lat_us[1]: 4904
lat_us[2]: 134
lat_us[3]: 357
lat_us[4]: 80
lat_us[5]: 4
lat_us[6]: 1
lat_us[14]: 5
lat_us[15]: 5
lat_us[16]: 14
lat_us[17]: 16
lat_us[18]: 7
lat_us[19]: 4
lat_us[20]: 2
lat_us[39]: 8
lat_us[40]: 5
lat_us[41]: 5
lat_us[48]: 1
lat_us[52]: 1
lat_us[75]: 54
lat_us[76]: 2488
lat_us[77]: 18113
lat_us[78]: 52104
lat_us[79]: 44205
lat_us[80]: 18509
lat_us[81]: 6211
lat_us[82]: 2778
lat_us[83]: 1458
lat_us[84]: 1008
lat_us[85]: 985
lat_us[86]: 995
lat_us[87]: 919
lat_us[88]: 869
lat_us[89]: 1528
lat_us[90]: 7391
lat_us[91]: 34096
lat_us[92]: 54822
lat_us[93]: 34892
lat_us[94]: 13717
lat_us[95]: 5581
lat_us[96]: 2876
lat_us[97]: 1611
lat_us[98]: 1123
lat_us[99]: 1043
lat_us[100]: 954
lat_us[101]: 848
lat_us[102]: 794
lat_us[103]: 724
lat_us[104]: 626
lat_us[105]: 591
lat_us[106]: 682
lat_us[107]: 796
lat_us[108]: 947
lat_us[109]: 845
lat_us[110]: 562
lat_us[111]: 306
lat_us[112]: 208
lat_us[113]: 122
lat_us[114]: 82
lat_us[115]: 56
lat_us[116]: 55
lat_us[117]: 42
lat_us[118]: 44
lat_us[119]: 38
lat_us[120]: 31
lat_us[121]: 29
lat_us[122]: 31
lat_us[123]: 19
lat_us[124]: 21
lat_us[125]: 27
lat_us[126]: 21
lat_us[127]: 15
lat_us[128]: 18
lat_us[129]: 6
lat_us[130]: 10
lat_us[131]: 15
lat_us[132]: 17
lat_us[133]: 10
lat_us[134]: 12
lat_us[135]: 5
lat_us[136]: 6
lat_us[137]: 13
lat_us[138]: 13
lat_us[139]: 7
lat_us[140]: 7
lat_us[141]: 5
lat_us[142]: 8
lat_us[143]: 15
lat_us[144]: 7
lat_us[145]: 5
lat_us[146]: 8
lat_us[147]: 1
lat_us[148]: 1
lat_us[149]: 3
lat_us[150]: 2
lat_us[151]: 3
lat_us[152]: 3
lat_us[153]: 4
lat_us[154]: 4
lat_us[155]: 6
lat_us[156]: 4
lat_us[157]: 2
lat_us[158]: 2
lat_us[160]: 1
lat_us[162]: 1
lat_us[163]: 1
lat_us[165]: 1
lat_us[167]: 1
lat_us[168]: 1
lat_us[169]: 1
lat_us[171]: 1
lat_us[172]: 2
lat_us[185]: 1
lat_us[188]: 1
lat_us[198]: 1
lat_us[203]: 1
lat_us[204]: 1
lat_us[210]: 1
lat_us[219]: 1
lat_us[236]: 1
lat_us[460]: 1
lat_us[583]: 1
lat_us[741]: 1
lat_us[746]: 1
lat_us[774]: 1
lat_us[790]: 1
lat_us[810]: 2
lat_us[812]: 1
lat_us[815]: 2
lat_us[819]: 1
lat_us[823]: 1
lat_us[824]: 1
lat_us[825]: 1
lat_us[826]: 1
lat_us[827]: 1
lat_us[828]: 1
lat_us[835]: 1
lat_us[836]: 2
lat_us[838]: 2
lat_us[841]: 1
lat_us[843]: 1
lat_us[844]: 1
lat_us[846]: 1
lat_us[847]: 2
lat_us[848]: 1
lat_us[850]: 1
lat_us[851]: 2
lat_us[852]: 1
lat_us[853]: 2
lat_us[854]: 1
lat_us[855]: 2
lat_us[856]: 3
lat_us[857]: 1
lat_us[859]: 1
lat_us[860]: 1
lat_us[861]: 2
lat_us[862]: 3
lat_us[863]: 1
lat_us[865]: 3
lat_us[866]: 2
lat_us[867]: 2
lat_us[868]: 2
lat_us[871]: 2
lat_us[872]: 1
lat_us[873]: 1
lat_us[877]: 3
lat_us[878]: 3
lat_us[879]: 1
lat_us[880]: 2
lat_us[882]: 5
lat_us[883]: 3
lat_us[884]: 1
lat_us[885]: 1
lat_us[886]: 3
lat_us[887]: 6
lat_us[889]: 4
lat_us[890]: 1
lat_us[891]: 1
lat_us[892]: 2
lat_us[893]: 2
lat_us[894]: 7
lat_us[895]: 3
lat_us[896]: 4
lat_us[897]: 3
lat_us[898]: 3
lat_us[899]: 4
lat_us[900]: 6
lat_us[901]: 5
lat_us[902]: 2
lat_us[903]: 7
lat_us[905]: 4
lat_us[906]: 2
lat_us[907]: 3
lat_us[908]: 1
lat_us[909]: 5
lat_us[910]: 3
lat_us[911]: 6
lat_us[912]: 7
lat_us[913]: 5
lat_us[914]: 6
lat_us[915]: 4
lat_us[916]: 4
lat_us[917]: 1
lat_us[918]: 7
lat_us[919]: 10
lat_us[920]: 11
lat_us[921]: 6
lat_us[922]: 5
lat_us[923]: 5
lat_us[924]: 9
lat_us[925]: 3
lat_us[926]: 6
lat_us[927]: 9
lat_us[928]: 10
lat_us[929]: 4
lat_us[930]: 6
lat_us[931]: 6
lat_us[932]: 6
lat_us[933]: 6
lat_us[934]: 8
lat_us[935]: 11
lat_us[936]: 5
lat_us[937]: 9
lat_us[938]: 8
lat_us[939]: 10
lat_us[940]: 8
lat_us[941]: 5
lat_us[942]: 7
lat_us[943]: 3
lat_us[944]: 9
lat_us[945]: 14
lat_us[946]: 10
lat_us[947]: 8
lat_us[948]: 10
lat_us[949]: 10
lat_us[950]: 10
lat_us[951]: 9
lat_us[952]: 14
lat_us[953]: 9
lat_us[954]: 14
lat_us[955]: 21
lat_us[956]: 10
lat_us[957]: 14
lat_us[958]: 11
lat_us[959]: 13
lat_us[960]: 11
lat_us[961]: 17
lat_us[962]: 15
lat_us[963]: 11
lat_us[964]: 14
lat_us[965]: 11
lat_us[966]: 24
lat_us[967]: 6
lat_us[968]: 10
lat_us[969]: 7
lat_us[970]: 11
lat_us[971]: 11
lat_us[972]: 16
lat_us[973]: 10
lat_us[974]: 8
lat_us[975]: 8
lat_us[976]: 6
lat_us[977]: 11
lat_us[978]: 6
lat_us[979]: 12
lat_us[980]: 13
lat_us[981]: 14
lat_us[982]: 22
lat_us[983]: 13
lat_us[984]: 17
lat_us[985]: 14
lat_us[986]: 17
lat_us[987]: 9
lat_us[988]: 14
lat_us[989]: 12
lat_us[990]: 13
lat_us[991]: 9
lat_us[992]: 8
lat_us[993]: 9
lat_us[994]: 11
lat_us[995]: 12
lat_us[996]: 8
lat_us[997]: 8
lat_us[998]: 10

The latency distributions have no significant diference.

In both cases, I run fio as front end write, the throughput is around
890MB/s, no big difference too.

From the above benchmark result, from latency and throughput, it seems
on a high performance real hardware, these two controller does not have
significant difference.

A good new is I observe the new PI controller works smoothly when dirty
number gets closing to target. After dirty number gets equal to target
number, writeback rate reaches the minimum number. If the minimum rate
changes to 1, the negative for up coming front end write should be
minimized, it is nice.

Also I agree the new PI controller is quite simple. It should be more
easier to predict behavior of this PI controller.

I add this patch into my test kernel, with other patches for 4.15. Let's
how it works.

Coly Li
