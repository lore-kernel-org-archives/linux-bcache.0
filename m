From: =?ISO-8859-1?Q?Roberto_Alc=E2ntara?= <roberto-ek926an30Vg66dlzjLgC1g@public.gmane.org>
Subject: Re: code stability (production readiness) and kernel versions
Date: Fri, 20 Apr 2012 14:05:33 -0300
Message-ID: <CAEt6MXmDdZmB16vNz6NG6HZeP5awACBQxJ0hoO3ZmdOvz8bGcw@mail.gmail.com>
References: <CAPwaGKZi1MTU03X+eam4Nm7K_RoTaQQVqzbLFLsN3xWvpMn-1g@mail.gmail.com>
 <CAH+dOxJMd_tObU8_y-o1irQFur=ooSt03=jVJoX7yDLSvzoOdw@mail.gmail.com>
 <2E02F577-5903-4879-AD3D-043268366569@fnarfbargle.com> <CAHYUNGbZqiBhtpsfwomMw_iEyXqT_MO=3YoQ24XxOWB1BsBkLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHYUNGbZqiBhtpsfwomMw_iEyXqT_MO=3YoQ24XxOWB1BsBkLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Adam,

What about use bache in raid1 flash devices?

        =A0- Roberto


On Fri, Apr 20, 2012 at 1:53 PM, Adam Berkan <aberkan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote=
:
> If you completely lose a flash device that contains significant
> quantities of dirty data, you'll have a hard time recovering any data
> from the backing device. =A0All of the writeback testing we've done s=
o
> far has assumed device failures are limited to small regions of the
> device, and bcache tries to recover what it can when it encounters
> such errors. =A0It doesn't do anything reasonable in the case of full
> device loss.
>
> I would not recommend using bcache in writeback mode anywhere where
> you can't afford to lose the whole device.
>
> Adam
>
> On Fri, Apr 20, 2012 at 8:51 AM, Brad Campbell <brad-+nnirC7rrGZibQn6LdNjmg@public.gmane.org>=
 wrote:
>>>
>> On 17/04/2012, at 4:30 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>>
>>>
>>>
>>>> Also ... do you think that your code is production ready when usin=
g bcache
>>>> to do writeback caching ? Of course I will keep testing but I'd li=
ke to
>>>> know if you think the code by now is production ready.
>>>
>>> Yeah, it is. Test it on your configuration, etc. etc. but writeback=
 is
>>> pretty mature and well tested at this point.
>>>
>> I've been giving serious thought to using this in a production envir=
onment. It performs well in my staging system, but my biggest concern r=
evolves around the ultimate reliability of the ssd.
>>
>> How much testing have you performed with regard to cache device fail=
ures in a writeback scenario? I like the idea of mirroring the cache de=
vices to replicate dirty data, however I know that is not implemented y=
et.
>>
>> We run a raid10 of SAS cheetahs. I'd love to mount a cache in there,=
 but ultimately we have little information about what happens if the ss=
d starts to flake out. I guess more than that, there is little real inf=
ormation out there detailing common or potential ssd failure modes.
>>
>> I'd assume you've performed plenty of testing over the development o=
f bcache. Can you fill us in a bit as to what to expect when things go =
south?
>>
>> Regards,
>> Brad--
>> To unsubscribe from this list: send the line "unsubscribe linux-bcac=
he" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
