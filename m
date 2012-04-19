From: "Gerrit Tamboer" <gtamboer-JFNXyGN8thM@public.gmane.org>
Subject: RE: code stability (production readiness) and kernel versions
Date: Thu, 19 Apr 2012 11:03:07 +0200
Message-ID: <001c01cd1e0b$3d296910$b77c3b30$@snow.nl>
References: <CAPwaGKZi1MTU03X+eam4Nm7K_RoTaQQVqzbLFLsN3xWvpMn-1g@mail.gmail.com>	<CAH+dOxJMd_tObU8_y-o1irQFur=ooSt03=jVJoX7yDLSvzoOdw@mail.gmail.com> <CAPwaGKauVt36jziYrzOG6EUgX+ZPA0HnsTxoVCS0qoWZFvbyYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPwaGKauVt36jziYrzOG6EUgX+ZPA0HnsTxoVCS0qoWZFvbyYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: nl
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Alexandru Ionica' <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Alexandru,

Very interesting results, thanks for sharing!

Regards,
Gerrit

-----Original Message-----
=46rom: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Alexandru Ioni=
ca
Sent: woensdag 18 april 2012 16:23
To: Kent Overstreet
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: code stability (production readiness) and kernel versions

Hello,

My employer allowed me to publish the data, so here you go:
http://www.accelcloud.com/2012/04/18/linux-flashcache-and-bcache-perfor=
mance
-testing/

On Tue, Apr 17, 2012 at 10:30 AM, Kent Overstreet <koverstreet@google.c=
om>
wrote:
> Hey, sorry for the delay. Was travelling and I've been slow to catch=20
> up on email...
>
> On Fri, Apr 6, 2012 at 6:21 AM, Alexandru Ionica=20
> <alexandru.ionica-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hello,
>>
>> I have been doing several benchmarks (Phoronix test suite, disk=20
>> suite) and I'm really impressed with the performance when doing=20
>> writeback caching. For the benchmarks I did a git checkout and=20
>> compiled the 3.1.0+ kernel. As the wiki is outdated I am wondering i=
f=20
>> the patches have also been applied on a kernel version which is used=
=20
>> by server oriented distributions, meaning kernel version 2.6.32 for=20
>> example or if there is a way to apply the patches (if they exist
separately) to kernel version 2.6.32 .
>> I am interested in this specific version of the kernel as other=20
>> constrains impose it.
>
> Any chance you could share those benchmarks? I'll post them on the=20
> wiki (or give you an account). I could really use some benchmarks tha=
t=20
> are suitable for sharing, all the benchmarking I've done has been jus=
t=20
> focused on optimizing stuff.
>
>> Also ... do you think that your code is production ready when using=20
>> bcache to do writeback caching ? Of course I will keep testing but=20
>> I'd like to know if you think the code by now is production ready.
>
> Yeah, it is. Test it on your configuration, etc. etc. but writeback i=
s=20
> pretty mature and well tested at this point.
>
>> Basically I plan to run a setup like: bcache device assembled from=20
>> software
>> raid10 or raid0 (4 disk) + ssd ; on top of this a volume group ; on=20
>> top of logical devices drbd setup . We are running this for a long=20
>> while without bcache so the setup is stable and the new part here wo=
uld
be bcache.
>
> Sounds pretty reasonable.
>
>> P.S. during the benchmarks bcache outperformed in every way=20
>> flashcache (I tried two different sequential size settings with flas=
h=20
>> cache, both
>> underperformed)
>
> Cool! Would love to see the numbers :)
>
>> Regards,
>>
>> Alexandru Ionica
>> --
>> To unsubscribe from this list: send the line "unsubscribe=20
>> linux-bcache" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org=20
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-bcache"=
 in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info =
at
http://vger.kernel.org/majordomo-info.html
