From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New stuff up in git
Date: Fri, 9 Sep 2011 15:27:37 -0700
Message-ID: <CAC7rs0uriXHsxKP0Z9JhZhSz5mgFG_o9hLKYnhRauFHr=2mfPg@mail.gmail.com>
References: <CAC7rs0tjhf73fRGE6rvVGjiCGc1coCAZTQNFqoC0iAn+YmGZng@mail.gmail.com>
	<j4d5bv$v1b$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <j4d5bv$v1b$1@dough.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Bowyer <gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

On Fri, Sep 9, 2011 at 2:46 PM, Greg Bowyer <gbowyer-97jfqw80gc69FHfhHBbuYA@public.gmane.org> wr=
ote:
> Sorry if this is a dumb question, is bcache-3.1 an update to bcache f=
or
> kernels 3.1+

It's the current bcache code rebased onto 3.1, yeah.

> I ask because I dumbly merged bcache onto the v3.0 tag today since I =
want to
> have a play with bcache

Heh. Did you get it to compile/boot? the bcache-3.1 branch isn't
_quite_ that far.

>
> On 08/09/11 01:49, Kent Overstreet wrote:
>>
>> I just finished updating both the bcache (off 2.6.34) and the
>> bcache-3.1 branches with the latest stable code.
>>
>> Also got cgit set up and working, finally. Need to stick a link in t=
he
>> wiki to it..
>>
>> http://evilpiepirate.org/git
>>
>> I still haven't figured out how to pack a git repository so cloning =
it
>> doesn't take> =A080% of my linode's ram, but cloning works for me so=
 I'm
>> done screwing with it for now.
>>
>> The bcache branch compiles but hasn't been tested. I don't expect an=
y
>> issues though, it's pretty close to what I normally develop/test on.
>>
>> The bcache-3.1 branch still doesn't quite compile, but it's pretty
>> close - I'm try and get a working version pushed tomorrow, I did boo=
t
>> a linux 3.1 + bcache kernel at one point...
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
