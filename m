From: Alexandru Ionica <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: code stability (production readiness) and kernel versions
Date: Wed, 18 Apr 2012 16:22:58 +0200
Message-ID: <CAPwaGKauVt36jziYrzOG6EUgX+ZPA0HnsTxoVCS0qoWZFvbyYQ@mail.gmail.com>
References: <CAPwaGKZi1MTU03X+eam4Nm7K_RoTaQQVqzbLFLsN3xWvpMn-1g@mail.gmail.com>
	<CAH+dOxJMd_tObU8_y-o1irQFur=ooSt03=jVJoX7yDLSvzoOdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH+dOxJMd_tObU8_y-o1irQFur=ooSt03=jVJoX7yDLSvzoOdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

My employer allowed me to publish the data, so here you go:
http://www.accelcloud.com/2012/04/18/linux-flashcache-and-bcache-perfor=
mance-testing/

On Tue, Apr 17, 2012 at 10:30 AM, Kent Overstreet
<koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Hey, sorry for the delay. Was travelling and I've been slow to catch
> up on email...
>
> On Fri, Apr 6, 2012 at 6:21 AM, Alexandru Ionica
> <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hello,
>>
>> I have been doing several benchmarks (Phoronix test suite, disk suit=
e) and
>> I'm really impressed with the performance when doing writeback cachi=
ng. For
>> the benchmarks I did a git checkout and compiled the 3.1.0+ kernel. =
As the
>> wiki is outdated I am wondering if the patches have also been applie=
d on a
>> kernel version which is used by server oriented distributions, meani=
ng
>> kernel version 2.6.32 for example or if there is a way to apply the =
patches
>> (if they exist separately) to kernel version 2.6.32 .
>> I am interested in this specific version of the kernel as other cons=
trains
>> impose it.
>
> Any chance you could share those benchmarks? I'll post them on the
> wiki (or give you an account). I could really use some benchmarks tha=
t
> are suitable for sharing, all the benchmarking I've done has been jus=
t
> focused on optimizing stuff.
>
>> Also ... do you think that your code is production ready when using =
bcache
>> to do writeback caching ? Of course I will keep testing but I'd like=
 to
>> know if you think the code by now is production ready.
>
> Yeah, it is. Test it on your configuration, etc. etc. but writeback i=
s
> pretty mature and well tested at this point.
>
>> Basically I plan to run a setup like: bcache device assembled from s=
oftware
>> raid10 or raid0 (4 disk) + ssd ; on top of this a volume group ; on =
top of
>> logical devices drbd setup . We are running this for a long while wi=
thout
>> bcache so the setup is stable and the new part here would be bcache.
>
> Sounds pretty reasonable.
>
>> P.S. during the benchmarks bcache outperformed in every way flashcac=
he (I
>> tried two different sequential size settings with flash cache, both
>> underperformed)
>
> Cool! Would love to see the numbers :)
>
>> Regards,
>>
>> Alexandru Ionica
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
