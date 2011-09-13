From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New stuff up in git
Date: Mon, 12 Sep 2011 17:02:13 -0700
Message-ID: <CAC7rs0sSKFJSm-12VsERoGh-rLQPOPPGnJHyBA8oUPOs+VPMrA@mail.gmail.com>
References: <CAC7rs0tjhf73fRGE6rvVGjiCGc1coCAZTQNFqoC0iAn+YmGZng@mail.gmail.com>
	<j4d5bv$v1b$1@dough.gmane.org>
	<CAC7rs0uriXHsxKP0Z9JhZhSz5mgFG_o9hLKYnhRauFHr=2mfPg@mail.gmail.com>
	<4E6B0537.4060409@fastmail.co.uk>
	<CAC7rs0t57Kx1f3CsQCb3CCf7r7tB6TwmwOLYVw0RJjujXAcwTw@mail.gmail.com>
	<4E6EB6F7.9030806@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E6EB6F7.9030806-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Bowyer <gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Mon, Sep 12, 2011 at 6:50 PM, Greg Bowyer <gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org> w=
rote:
> Sorry for the delay I was away over the weekend, my changes (minimal =
as they
> are) are on github
>
> https://github.com/GregBowyer/linux-bcache
>
> I didn't spend much time working out compile errors if I put on debug=
ging,
> they should be pretty easy to fix, I just wanted to play
> I also didn't realize that I needed to format the backing device sepa=
rate to
> the cache device, I have not had a chance to fully test everything, I=
 will
> try it out over the next few days.
>
> Do you want me to give this a more serious look over ?

Nah, don't worry about spending any extra time on it. I've got a bunch
of minor stuff to fix and fixes to merge in right now, hopefully
should have some of that done tonight.

> On 09/09/11 16:12, Kent Overstreet wrote:
>>
>> Nice. If you want to push/email your changes I'll merge them into th=
e
>> bcache-3.1 branch.
>>
>> Now if only I had some up to date documentation... :)
>>
>> On Fri, Sep 9, 2011 at 11:35 PM, Greg Bowyer<gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
>> =A0wrote:
>>>
>>> On 09/09/11 15:27, Kent Overstreet wrote:
>>>>
>>>> On Fri, Sep 9, 2011 at 2:46 PM, Greg Bowyer<gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org=
>
>>>> =A0wrote:
>>>>>
>>>>> Sorry if this is a dumb question, is bcache-3.1 an update to bcac=
he for
>>>>> kernels 3.1+
>>>>
>>>> It's the current bcache code rebased onto 3.1, yeah.
>>>>
>>>>> I ask because I dumbly merged bcache onto the v3.0 tag today sinc=
e I
>>>>> want
>>>>> to
>>>>> have a play with bcache
>>>>
>>>> Heh. Did you get it to compile/boot? the bcache-3.1 branch isn't
>>>> _quite_ that far.
>>>
>>> I did get to compile and boot, although I took the bcache branch an=
d not
>>> bcache-3.1 (when I say compile it wont compile if I have debugging =
turned
>>> on, but I am ignoring that :S)
>>>>>
>>>>> On 08/09/11 01:49, Kent Overstreet wrote:
>>>>>>
>>>>>> I just finished updating both the bcache (off 2.6.34) and the
>>>>>> bcache-3.1 branches with the latest stable code.
>>>>>>
>>>>>> Also got cgit set up and working, finally. Need to stick a link =
in the
>>>>>> wiki to it..
>>>>>>
>>>>>> http://evilpiepirate.org/git
>>>>>>
>>>>>> I still haven't figured out how to pack a git repository so clon=
ing it
>>>>>> doesn't take> =A0 =A0 =A080% of my linode's ram, but cloning wor=
ks for me so
>>>>>> I'm
>>>>>> done screwing with it for now.
>>>>>>
>>>>>> The bcache branch compiles but hasn't been tested. I don't expec=
t any
>>>>>> issues though, it's pretty close to what I normally develop/test=
 on.
>>>>>>
>>>>>> The bcache-3.1 branch still doesn't quite compile, but it's pret=
ty
>>>>>> close - I'm try and get a working version pushed tomorrow, I did=
 boot
>>>>>> a linux 3.1 + bcache kernel at one point...
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-b=
cache"
>>>>> in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>>
>>>
>
>
