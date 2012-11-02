From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache Journal
Date: Fri, 2 Nov 2012 09:57:53 -0700
Message-ID: <20121102165753.GE14917@google.com>
References: <20121102151620.GB14917@google.com>
 <93462A6BCE1CD840B94554FBBEE4C93603075DA022@THHS2E12BE8X.hostedservice2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <93462A6BCE1CD840B94554FBBEE4C93603075DA022-DfMK7iAD4PJfakIiyABxvNnpRUX5XqCHU7KNoL8tkdc@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

On Fri, Nov 02, 2012 at 04:44:30PM +0000, James Sefton wrote:
> Hi Kent,
> 
> Help with the docs is something I can do and I would be pleased to have the chance to contribute something back.
> 
> I would like to expand the document somewhat so that there is a short quickstart guide, your information on how it all works, detailed command reference, a howto section showing how to do things (such as shrink backing device!) and finally an updated list of sysfs structure.

That'd be great. It'd really be valuable to have someone other than me
working on those docs too, from the perspective of someone who doesn't
already know the code through and through.

> I notice you are currently doing a lot of work on MD integration.  Is this functional yet?  Should the documentation show how to use MD with bCache?

No, I wasn't doing any of that work and it seems to have dropped off. I
may pick it up myself at some point, but I don't know when I'll have
time.

I have been thinking a bit about md integration of a different kind
though, since I finally got bcache set up on my home machine caching my
raid 6 - if bcache was aware of the layout of the stripes and perhaps
there was some sort of communication between bcache and md, there'd be
(possibly significant) room for improvement with write performance...
that's kind of off topic though since I haven't started on that either.

> I will work on it offline and email you the text file for review and you can include it when you are happy with it.
> 
> Would this be okay or would you prefer to keep it as it is and just fix the errors?

That'd be fine. 

> Also, are there any guidelines/requirements for documentation content/format or is it simply just that it has to be in one plain text file?

I do like keeping it with the rest of the kernel documentation (which
does mean plain text), but there's really no hard and fast rules - I
just try to keep the style consistent.

> If you are happy with all this, I will get on it as soon as I can.   Please tell me if I am overstepping the mark here and you just want the docs fixing rather than expanding.

Not at all! Go for it :)

I don't think there's any gaping holes, as far as functionality that
isn't mentioned in the documentation or whatever - but there is a lot
that could be fleshed out.

Background writeback and the algorithms/heuristics it uses, and also the
heuristics that control whethere bcache will cache a given io would
probably be a good place to start.

I dunno what confuses people the most, though.

Thanks!


> Regards,
> 
> James Sefton
> Phase 5 Communications Ltd.
> 
> Tel: 01226 285600
> 
> 
> -----Original Message-----
> From: Kent Overstreet [mailto:koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org] 
> Sent: 02 November 2012 15:16
> To: James Sefton
> Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Bcache Journal
> 
> On Fri, Nov 02, 2012 at 03:44:00AM +0000, James Sefton wrote:
> > Alex Pyrgiotis <apyrgio@...> writes:
> > 
> > > 
> > > On 10/29/2012 10:43 PM, Kent Overstreet wrote:
> > > > On Sun, Oct 28, 2012 at 06:20:19PM +0200, Alex Pyrgiotis wrote:
> > > >> Hi,
> > > >>
> > > >> In the wiki, it is mentioned that bcache can run either with or
> > > >> without a journal.
> > > >> What I'd like to ask is which is the default bcache configuration
> > > >> (journal on|off?) and is there an option in the make-bcache tool to
> > > >> change this configuration?
> > > > That's out of dat... What page did you find that on? Running without a
> > > > journal hasn't been an option in ages...
> > > Hi Kent,
> > > 
> > > Here's the link: http://bcache.evilpiepirate.org/Design#Journal
> > > The out-dated part is "It is possible to create cache devices..."
> > > >
> > > > (You wouldn't want to run without the journal, it's there to improve
> > > > performance)
> > > Yeah, I know. Just wanted to have a look at bcache's knobs and switches...
> > > Thanks again. 
> > > 
> > 
> > 
> > Hi Kent,
> > 
> > Out of interest - I am also having trouble with the docs and I am getting them 
> > from the same server as Alex.
> > 
> > http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt
> > 
> > Just wondering if we are both looking in the wrong place??
> > 
> > The docs seem to be outdated somewhat.
> > As an example there is a list of sysfs entries described at the bottom of the 
> > page.  A lot of these either do not exist or have changed names, and a lot of 
> > new ones seem to be added that are not listed in the docs.
> > 
> > Is this site the wrong place to be looking or are the docs simply out of date?
> 
> That's the right place, some of that is out of date though. I think it's
> _mostly_ the sysfs stuff.
> 
> > (If the docs are out of date then maybe we can help you maintain them.)
> 
> Please do! All the documentation should be in the kernel tree, so you
> can just send me patches for that. Any questions about what it should
> say, go ahead and ask.
