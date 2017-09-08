From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Fwd: [PATCH] bcache: PI controller for writeback rate V2
Date: Fri, 8 Sep 2017 11:49:28 -0700
Message-ID: <CAJ+L6qdF=ffE47tYfT-cYYvuVGT4_OAZZ6XXPmXPuuL9dBAbDQ@mail.gmail.com>
References: <20170908031719.23988-1-mlyle@lyle.org> <f72a99ef-4219-947c-c622-31cdafdaa079@suse.de>
 <CAJ+L6qe6RikRR9empP_SxveXdyk-sCsoOi11CmxZsDiT1xf4og@mail.gmail.com>
 <CAJ+L6qfZG7sR8Rb==V9jAP3JjOOzCuUq+mve_hzHszwPeoqL0w@mail.gmail.com> <2fa508c0-5d86-9f8b-4919-806009e5b29a@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33750 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756615AbdIHSt3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 Sep 2017 14:49:29 -0400
Received: by mail-qt0-f173.google.com with SMTP id i50so8625366qtf.0
        for <linux-bcache@vger.kernel.org>; Fri, 08 Sep 2017 11:49:29 -0700 (PDT)
In-Reply-To: <2fa508c0-5d86-9f8b-4919-806009e5b29a@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>

On Fri, Sep 8, 2017 at 10:17 AM, Coly Li <i@coly.li> wrote:
> On 2017/9/9 =E4=B8=8A=E5=8D=8812:42, Michael Lyle wrote:
>> [sorry for resend, I am apparently not good at reply-all in gmail :P ]
>>
>> On Thu, Sep 7, 2017 at 10:52 PM, Coly Li <colyli@suse.de> wrote:
>> [snip history]
>
> This assumption is not always correct. If heavy front end I/Os coming
> every "writeback_rate_update_seconds" seconds, the writeback rate just
> raises to a high number, this situation may have negative contribution
> to I/O latency of front end I/Os.

I'm confused by this.  We're not taking the derivative, but the
absolute number of dirty blocks.  It doesn't matter whether they
arrive every writeback_rate_update_seconds, every millisecond, every
15 seconds, or whatever.  The net result is almost identical.

e.g. compare http://jar.lyle.org/~mlyle/ctr/10000-per-second.png
http://jar.lyle.org/~mlyle/ctr/20000-every-2-seconds.png
http://jar.lyle.org/~mlyle/ctr/50000-every-5-seconds.png
or for a particularly "bad" case
http://jar.lyle.org/~mlyle/ctr/90000-every-9-seconds.png where it is
still well behaved (I don't think we want a completely steady rate as
chunks of IO slow down, too, but for the control system to start to
respond...

> It may not be exact "writeback_rate_update_seconds" seconds, this is
> just an example for some king of "interesting" I/O pattern to show that
> higher writeback_rate_minimum may not always be helpful.

writeback_rate_minimum is only used as an *absolute rate* of 5 sectors
per second.  It is not affected by the rate of arrival of IO
requests-- either the main control system comes up with a rate that is
higher than it, or it is bounded to this exact rate (which is almost
nothing).

>>>> +     if ((error < 0 && dc->writeback_rate_integral > 0) ||
>>>> +         (error > 0 && time_before64(local_clock(),
>>>> +                      dc->writeback_rate.next + NSEC_PER_MSEC))) {
>>>> +             /* Only decrease the integral term if it's more than
>>>> +              * zero.  Only increase the integral term if the device
>>>> +              * is keeping up.  (Don't wind up the integral
>>>> +              * ineffectively in either case).
>>>> +              *
>>>> +              * It's necessary to scale this by
>>>> +              * writeback_rate_update_seconds to keep the integral
>>>> +              * term dimensioned properly.
>>>> +              */
>>>> +             dc->writeback_rate_integral +=3D error *
>>>> +                     dc->writeback_rate_update_seconds;
>>>
>>> I am not sure whether it is correct to calculate a integral value here.
>>> error here is not a per-second value, it is already a accumulated resul=
t
>>> in past "writeback_rate_update_seconds" seconds, what does it mean for
>>> "error * dc->writeback_rate_update_seconds" ?
>>>
>>> I know here you are calculating a integral value of error, but before I
>>> understand why you use "error * dc->writeback_rate_update_seconds", I a=
m
>>> not able to say whether it is good or not.
>>
>> The calculation occurs every writeback_rate_update_seconds.  An
>> integral is the area under a curve.
>>
>> If the error is currently 1, and has been 1 for the past 5 seconds,
>> the integral increases by 1 * 5 seconds.  There are two approaches
>> used in numerical integration, a "rectangular integration" (which this
>> is, assuming the value has held for the last 5 seconds), and a
>> "triangular integration", where the average of the old value and the
>> new value are averaged and multiplied by the measurement interval.  It
>> doesn't really make a difference-- the triangular integration tends to
>> come up with a slightly more accurate value but adds some delay.  (In
>> this case, the integral has a time constant of thousands of
>> seconds...)
>>
>
> Hmm, imagine we have a per-second sampling, and the data is:
>
>    time point       dirty data (MB)
>         1               1
>         1               1
>         1               1
>         1               1
>         1               10
>
> Then a more accurate integral result should be: 1+1+1+1+10 =3D 14. But by
> your "rectangular integration" the result will be 10*5 =3D 50.
>
> Correct me if I am wrong, IMHO 14:50 is a big difference.

It's irrelevant-- the long term results will be the same, and the
short term results are fundamentally the same.  That is, the
proportional controller with 10MB of excess data will seek to write
10MB/40 =3D 250,000 bytes per second more.  The integral term at 50MB
will seek to write 5000 bytes more; at 14MB will seek to write out
1400 bytes more/second.  That is, it makes a 1.4% difference in write
rate (1-255000/251400) in this contrived case in the short term, and
these biases fundamentally only last one cycle long...

A triangular integration would result in (1+10) / 2 * 5 =3D 27.5, or
would pick the rate 252750, or even less of a difference...

And as it stands now, the current controller just takes the rate error
from the end of the interval, so it does a rectangular integration.
That is, both integrals slightly underestimate dirty data's integral
when it's rising and slightly overestimate falling.  Short of sampling
a bunch more this is something that fundamentally can't be corrected
and all real-world control systems live with.

Note: this isn't my first time implementing a control system-- I am
maintainer of a drone autopilot that has controllers six layers deep
with varying bandwidth for each (position, velocity, acceleration,
attitude, angular rate, actuator effect) that gets optimal system
performance from real-world aircraft...

>>> In my current understanding, the effect of the above calculation is to
>>> make a derivative value being writeback_rate_update_seconds times big.
>>> So it is expected to be faster than current PD controller.
>>
>> The purpose of the proportional term is to respond immediately to how
>> full the buffer is (this isn't a derivative value).
>>
>> If we consider just the proportional term alone, with its default
>> value of 40, and the user starts writing 1000 sectors/second...
>> eventually error will reach 40,000, which will cause us to write 1000
>> blocks per second and be in equilibrium-- but the amount filled with
>> dirty data will be off by 40,000 blocks from the user's calibrated
>> value.  The integral term works to take a long term average of the
>> error and adjust the write rate, to bring the value back precisely to
>> its setpoint-- and to allow a good writeback rate to be chosen for
>> intermittent loads faster than its time constant.
>>
>>> I see 5 sectors/second is faster than 1 sectors/second, is there any
>>> other benefit to change 1 to 5 ?
>>
>> We can set this back to 1 if you want.  It is still almost nothing,
>> and in practice more will be written in most cases (the scheduling
>> targeting writing 1/second usually has to write more).
>>
>
> 1 is the minimum writeback rate, even there is heavy front end I/O,
> bcache still tries to writeback at 1 sectors/second. Let's keep it in 1,
> so give the maximum bandwidth to frond end I/Os for better latency and
> throughput.

OK, I can set it to 1, though I believe even at '1' the underlying
code writes 8 sectors/second (4096 real block size).

> [snip]
>>
>> To take a numerical example with the case above, where the P term
>> would end up off by 40,000 blocks, each 5 second update the I
>> controller would be increasing the rate by 20 blocks/second initially
>> to bring that 40,000 block offset under control
>
> Oh, I see.
>
> It seems what we need is just benchmark numbers for latency
> distribution. Once there is no existed data, I will get a data set by
> myself. I can arrange to start the test by end of this month, now I
> don't have continuous access to a powerful hardware.
>
> Thanks for the above information :-)
>
> --
> Coly Li

Mike
