From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New stuff up in git
Date: Fri, 9 Sep 2011 16:12:51 -0700
Message-ID: <CAC7rs0t57Kx1f3CsQCb3CCf7r7tB6TwmwOLYVw0RJjujXAcwTw@mail.gmail.com>
References: <CAC7rs0tjhf73fRGE6rvVGjiCGc1coCAZTQNFqoC0iAn+YmGZng@mail.gmail.com>
	<j4d5bv$v1b$1@dough.gmane.org>
	<CAC7rs0uriXHsxKP0Z9JhZhSz5mgFG_o9hLKYnhRauFHr=2mfPg@mail.gmail.com>
	<4E6B0537.4060409@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E6B0537.4060409-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Bowyer <gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Nice. If you want to push/email your changes I'll merge them into the
bcache-3.1 branch.

Now if only I had some up to date documentation... :)

On Fri, Sep 9, 2011 at 11:35 PM, Greg Bowyer <gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org> w=
rote:
> On 09/09/11 15:27, Kent Overstreet wrote:
>>
>> On Fri, Sep 9, 2011 at 2:46 PM, Greg Bowyer<gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
>> =A0wrote:
>>>
>>> Sorry if this is a dumb question, is bcache-3.1 an update to bcache=
 for
>>> kernels 3.1+
>>
>> It's the current bcache code rebased onto 3.1, yeah.
>>
>>> I ask because I dumbly merged bcache onto the v3.0 tag today since =
I want
>>> to
>>> have a play with bcache
>>
>> Heh. Did you get it to compile/boot? the bcache-3.1 branch isn't
>> _quite_ that far.
>
> I did get to compile and boot, although I took the bcache branch and =
not
> bcache-3.1 (when I say compile it wont compile if I have debugging tu=
rned
> on, but I am ignoring that :S)
>>>
>>> On 08/09/11 01:49, Kent Overstreet wrote:
>>>>
>>>> I just finished updating both the bcache (off 2.6.34) and the
>>>> bcache-3.1 branches with the latest stable code.
>>>>
>>>> Also got cgit set up and working, finally. Need to stick a link in=
 the
>>>> wiki to it..
>>>>
>>>> http://evilpiepirate.org/git
>>>>
>>>> I still haven't figured out how to pack a git repository so clonin=
g it
>>>> doesn't take> =A0 =A080% of my linode's ram, but cloning works for=
 me so I'm
>>>> done screwing with it for now.
>>>>
>>>> The bcache branch compiles but hasn't been tested. I don't expect =
any
>>>> issues though, it's pretty close to what I normally develop/test o=
n.
>>>>
>>>> The bcache-3.1 branch still doesn't quite compile, but it's pretty
>>>> close - I'm try and get a working version pushed tomorrow, I did b=
oot
>>>> a linux 3.1 + bcache kernel at one point...
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-bca=
che"
>>> in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>
>
