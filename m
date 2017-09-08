From: Coly Li <i@coly.li>
Subject: Re: Fwd: [PATCH] bcache: PI controller for writeback rate V2
Date: Sat, 9 Sep 2017 01:17:33 +0800
Message-ID: <2fa508c0-5d86-9f8b-4919-806009e5b29a@coly.li>
References: <20170908031719.23988-1-mlyle@lyle.org>
 <f72a99ef-4219-947c-c622-31cdafdaa079@suse.de>
 <CAJ+L6qe6RikRR9empP_SxveXdyk-sCsoOi11CmxZsDiT1xf4og@mail.gmail.com>
 <CAJ+L6qfZG7sR8Rb==V9jAP3JjOOzCuUq+mve_hzHszwPeoqL0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:42386 "EHLO server.coly.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755563AbdIHRRi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 Sep 2017 13:17:38 -0400
In-Reply-To: <CAJ+L6qfZG7sR8Rb==V9jAP3JjOOzCuUq+mve_hzHszwPeoqL0w@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On 2017/9/9 上午12:42, Michael Lyle wrote:
> [sorry for resend, I am apparently not good at reply-all in gmail :P ]
> 
> On Thu, Sep 7, 2017 at 10:52 PM, Coly Li <colyli@suse.de> wrote:
> [snip history]
>> writeback_rate_mininum & writeback_rate are all readable/writable, and
>> writeback_rate_mininum should be less or equal to writeback_rate if I
>> understand correctly.
> 
> No, this is not true.  writeback_rate is writable, but the control
> system replaces it at 5 second intervals.  This is the same as current
> code.  If you want writeback_rate to do something as a tunable, you
> should set writeback_percent to 0, which disables the control system
> and lets you set your own value-- otherwise whatever change you make
> is replaced in 5 seconds.
> 
> writeback_rate_minimum is for use cases when you want to force
> writeback_rate to occur faster than the control system would choose on
> its own.  That is, imagine you have an intermittent, write-heavy
> workload, and when the system is idle you want to clear out the dirty
> blocks.  The default rate of 1 sector per second would do this very
> slowly-- instead you could pick a value that is a small percentage of
> disk bandwidth (preserving latency characteristics) but still fast
> enough to leave dirty space available.
> 
>> Here I feel a check should be added here to make sure
>> writeback_rate_minimum <= writeback_rate when setting them into sysfs entry.
> 
> You usually (not always) will actually want to set
> writeback_rate_minimum to faster than writeback_rate, to speed up the
> current writeback rate.

This assumption is not always correct. If heavy front end I/Os coming
every "writeback_rate_update_seconds" seconds, the writeback rate just
raises to a high number, this situation may have negative contribution
to I/O latency of front end I/Os.

It may not be exact "writeback_rate_update_seconds" seconds, this is
just an example for some king of "interesting" I/O pattern to show that
higher writeback_rate_minimum may not always be helpful.

> 
>>> +     if ((error < 0 && dc->writeback_rate_integral > 0) ||
>>> +         (error > 0 && time_before64(local_clock(),
>>> +                      dc->writeback_rate.next + NSEC_PER_MSEC))) {
>>> +             /* Only decrease the integral term if it's more than
>>> +              * zero.  Only increase the integral term if the device
>>> +              * is keeping up.  (Don't wind up the integral
>>> +              * ineffectively in either case).
>>> +              *
>>> +              * It's necessary to scale this by
>>> +              * writeback_rate_update_seconds to keep the integral
>>> +              * term dimensioned properly.
>>> +              */
>>> +             dc->writeback_rate_integral += error *
>>> +                     dc->writeback_rate_update_seconds;
>>
>> I am not sure whether it is correct to calculate a integral value here.
>> error here is not a per-second value, it is already a accumulated result
>> in past "writeback_rate_update_seconds" seconds, what does it mean for
>> "error * dc->writeback_rate_update_seconds" ?
>>
>> I know here you are calculating a integral value of error, but before I
>> understand why you use "error * dc->writeback_rate_update_seconds", I am
>> not able to say whether it is good or not.
> 
> The calculation occurs every writeback_rate_update_seconds.  An
> integral is the area under a curve.
> 
> If the error is currently 1, and has been 1 for the past 5 seconds,
> the integral increases by 1 * 5 seconds.  There are two approaches
> used in numerical integration, a "rectangular integration" (which this
> is, assuming the value has held for the last 5 seconds), and a
> "triangular integration", where the average of the old value and the
> new value are averaged and multiplied by the measurement interval.  It
> doesn't really make a difference-- the triangular integration tends to
> come up with a slightly more accurate value but adds some delay.  (In
> this case, the integral has a time constant of thousands of
> seconds...)
> 

Hmm, imagine we have a per-second sampling, and the data is:

   time point       dirty data (MB)
	1		1
	1		1
	1		1
	1		1
	1		10

Then a more accurate integral result should be: 1+1+1+1+10 = 14. But by
your "rectangular integration" the result will be 10*5 = 50.

Correct me if I am wrong, IMHO 14:50 is a big difference.


>> In my current understanding, the effect of the above calculation is to
>> make a derivative value being writeback_rate_update_seconds times big.
>> So it is expected to be faster than current PD controller.
> 
> The purpose of the proportional term is to respond immediately to how
> full the buffer is (this isn't a derivative value).
> 
> If we consider just the proportional term alone, with its default
> value of 40, and the user starts writing 1000 sectors/second...
> eventually error will reach 40,000, which will cause us to write 1000
> blocks per second and be in equilibrium-- but the amount filled with
> dirty data will be off by 40,000 blocks from the user's calibrated
> value.  The integral term works to take a long term average of the
> error and adjust the write rate, to bring the value back precisely to
> its setpoint-- and to allow a good writeback rate to be chosen for
> intermittent loads faster than its time constant.
> 
>> I see 5 sectors/second is faster than 1 sectors/second, is there any
>> other benefit to change 1 to 5 ?
> 
> We can set this back to 1 if you want.  It is still almost nothing,
> and in practice more will be written in most cases (the scheduling
> targeting writing 1/second usually has to write more).
> 

1 is the minimum writeback rate, even there is heavy front end I/O,
bcache still tries to writeback at 1 sectors/second. Let's keep it in 1,
so give the maximum bandwidth to frond end I/Os for better latency and
throughput.

>>> +     dc->writeback_rate_p_term_inverse = 40;
>>> +     dc->writeback_rate_i_term_inverse = 10000;
>>
>> How the above values are selected ? Could you explain the calculation
>> behind the values ?
> 
> Sure.  40 is to try and write at a rate to retire the current blocks
> at 40 seconds.  It's the "fast" part of the control system, and needs
> to not be too fast to not overreact to single writes.  (e.g. if the
> system is quiet, and at the setpoint, and the user writes 4000 blocks
> once, the P controller will try and write at an initial rate of 100
> blocks/second).  The i term is more complicated-- I made it very slow.
> It should usually be more than the p term squared * the calculation
> interval for stability, but there may be some circumstances when you
> want its control to be more effective than this.  The lower the i term
> is, the quicker the system will come back to the setpoint, but the
> more potential there is for overshoot (moving past the setpoint) and
> oscillation.
> 
> To take a numerical example with the case above, where the P term
> would end up off by 40,000 blocks, each 5 second update the I
> controller would be increasing the rate by 20 blocks/second initially
> to bring that 40,000 block offset under control

Oh, I see.

It seems what we need is just benchmark numbers for latency
distribution. Once there is no existed data, I will get a data set by
myself. I can arrange to start the test by end of this month, now I
don't have continuous access to a powerful hardware.

Thanks for the above information :-)

-- 
Coly Li
