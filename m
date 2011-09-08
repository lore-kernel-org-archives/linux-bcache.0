From: Bostjan Skufca <bostjan-CKT3X4mPfYE@public.gmane.org>
Subject: Re: New stuff up in git
Date: Thu, 8 Sep 2011 16:41:50 +0200
Message-ID: <CAEp_DRAb00hyBATJ5=V9_CGM1BpcUWcoehK8X3fo2WF8y0VWtg@mail.gmail.com>
References: <CAC7rs0tjhf73fRGE6rvVGjiCGc1coCAZTQNFqoC0iAn+YmGZng@mail.gmail.com>
	<CAFtEh-czTh2eJXGuAH2iO=PrcAwYxayVMMYQyXUj7n6qvGtGeQ@mail.gmail.com>
	<20110908091034.GA32005@moria>
	<CAFtEh-dAbCo1Ov3QZkSu8XPnmGtHNsZ3pZy3E6eA5ZTmPJ0tyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFtEh-dAbCo1Ov3QZkSu8XPnmGtHNsZ3pZy3E6eA5ZTmPJ0tyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

it would be really helpful if kernel patches (I mean diffs) would be pr=
ovided.
If it wasn't necessary to clone the whole repo to get to the bcache,
instead only download kernel source and apply a patch, then probably
some more people would be encouraged to try bcache and report possible
bugs and/or test performance.
I know I would do it.

With some automatic/scripted patch generation and publishing it would
really require minimal work from your part and probably provide much
more feedback.

Tools repo is not problematic in this respect. It is small.

Just a thought and a recommendation:)

b.


On 8 September 2011 11:16, Damien Churchill <damoxc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 8 September 2011 10:10, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>> On Thu, Sep 08, 2011 at 09:56:12AM +0100, Damien Churchill wrote:
>>> On 8 September 2011 09:49, Kent Overstreet <kent.overstreet@gmail.c=
om> wrote:
>>> > I just finished updating both the bcache (off 2.6.34) and the
>>> > bcache-3.1 branches with the latest stable code.
>>> >
>>> > Also got cgit set up and working, finally. Need to stick a link i=
n the
>>> > wiki to it..
>>> >
>>> > http://evilpiepirate.org/git
>>> >
>>> > I still haven't figured out how to pack a git repository so cloni=
ng it
>>> > doesn't take > 80% of my linode's ram, but cloning works for me s=
o I'm
>>> > done screwing with it for now.
>>> >
>>>
>>> I was able to make a clone by cloning Linus' repository on github,
>>> then adding your repository as a remote then fetching, in case that
>>> helps anyone.
>>
>> Yeah, that's one way around that issue. I really should just flip on
>> cloning over http... git's memory consumption is kind of infuriating=
=2E
>>
>
> I have to say I haven't really encountered memory issues with it when
> hosting, but then I haven't tried hosting anything as large as the
> kernel.
>
>>> > The bcache branch compiles but hasn't been tested. I don't expect=
 any
>>> > issues though, it's pretty close to what I normally develop/test =
on.
>>> >
>>> > The bcache-3.1 branch still doesn't quite compile, but it's prett=
y
>>> > close - I'm try and get a working version pushed tomorrow, I did =
boot
>>> > a linux 3.1 + bcache kernel at one point...
>>> >
>>>
>>> I made a patch using the bcache-3.1 branch that does apply to the 3=
=2E0
>>> tree as well FYI. Haven't attempted to compile it yet but will do i=
n a
>>> bit, see what happens. Do you need to set CONFIG_BCACHE=3Dy in the
>>> kernel config?
>>
>> I think the block layer's been fairly quiet since ~2.6.39 or .38, th=
e
>> patches in the bcache-3.1 tree should move back that far without any
>> issues. But it won't compile on any of them just yet.. I think the s=
tuff
>> that's left is trivial but it's late and I have to be up too early.
>>
>> And yeah, you'll need CONFIG_BCACHE.
>>
>
> Well I shall look forward to what patches tomorrow brings in that
> case. Thanks a lot!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
