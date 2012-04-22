From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: code stability (production readiness) and kernel versions
Date: Sat, 21 Apr 2012 21:19:18 -0700
Message-ID: <CAH+dOxLUdecq4p1dbAFqHy2PKmqKh26jc0OuRkpQDeyiHNDv7A@mail.gmail.com>
References: <CAPwaGKZi1MTU03X+eam4Nm7K_RoTaQQVqzbLFLsN3xWvpMn-1g@mail.gmail.com>
	<CAH+dOxJMd_tObU8_y-o1irQFur=ooSt03=jVJoX7yDLSvzoOdw@mail.gmail.com>
	<CAPwaGKajTUEWHdu6+R+Rt=_PnCDZ2w0S26fw34dB3bSegXom3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPwaGKajTUEWHdu6+R+Rt=_PnCDZ2w0S26fw34dB3bSegXom3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexandru Ionica <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Thanks for publishing these, very much appreciated :)

If it's not too much to ask, do you think you could rerun with the
latest code? There've been some performance improvements since the
version you tested, and in particular I think fix to make inserting
cache misses reliable might make a big difference on the apache
benchmark - I suspect that was a pathalogical case for the old code.

Also if you'd be willing to do more benchmarking, I'll definitely be
looking at your data for performance bugs and things that could be
improved. I expect there's performance bugs still - just have to
identify the workloads that tickle them.

On Wed, Apr 18, 2012 at 7:15 AM, Alexandru Ionica
<alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello,
>
> My employer allowed me to publish the data, so here you go:
> http://www.accelcloud.com/2012/04/18/linux-flashcache-and-bcache-perf=
ormance-testing/
>
> :)
>
>
> On Tue, Apr 17, 2012 at 10:30 AM, Kent Overstreet <koverstreet@google=
=2Ecom>
> wrote:
>>
>> Hey, sorry for the delay. Was travelling and I've been slow to catch
>> up on email...
>>
>> On Fri, Apr 6, 2012 at 6:21 AM, Alexandru Ionica
>> <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Hello,
>> >
>> > I have been doing several benchmarks (Phoronix test suite, disk su=
ite)
>> > and
>> > I'm really impressed with the performance when doing writeback cac=
hing.
>> > For
>> > the benchmarks I did a git checkout and compiled the 3.1.0+ kernel=
=2E As
>> > the
>> > wiki is outdated I am wondering if the patches have also been appl=
ied on
>> > a
>> > kernel version which is used by server oriented distributions, mea=
ning
>> > kernel version 2.6.32 for example or if there is a way to apply th=
e
>> > patches
>> > (if they exist separately) to kernel version 2.6.32 .
>> > I am interested in this specific version of the kernel as other
>> > constrains
>> > impose it.
>>
>> Any chance you could share those benchmarks? I'll post them on the
>> wiki (or give you an account). I could really use some benchmarks th=
at
>> are suitable for sharing, all the benchmarking I've done has been ju=
st
>> focused on optimizing stuff.
>>
>> > Also ... do you think that your code is production ready when usin=
g
>> > bcache
>> > to do writeback caching ? Of course I will keep testing but I'd li=
ke to
>> > know if you think the code by now is production ready.
>>
>> Yeah, it is. Test it on your configuration, etc. etc. but writeback =
is
>> pretty mature and well tested at this point.
>>
>> > Basically I plan to run a setup like: bcache device assembled from
>> > software
>> > raid10 or raid0 (4 disk) + ssd ; on top of this a volume group ; o=
n top
>> > of
>> > logical devices drbd setup . We are running this for a long while
>> > without
>> > bcache so the setup is stable and the new part here would be bcach=
e.
>>
>> Sounds pretty reasonable.
>>
>> > P.S. during the benchmarks bcache outperformed in every way flashc=
ache
>> > (I
>> > tried two different sequential size settings with flash cache, bot=
h
>> > underperformed)
>>
>> Cool! Would love to see the numbers :)
>>
>> > Regards,
>> >
>> > Alexandru Ionica
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-bc=
ache"
>> > in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>
>
