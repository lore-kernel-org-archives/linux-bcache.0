From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: RE: Bcache Journal
Date: Fri, 2 Nov 2012 16:44:30 +0000
Message-ID: <93462A6BCE1CD840B94554FBBEE4C93603075DA022@THHS2E12BE8X.hostedservice2.net>
References: <20121102151620.GB14917@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121102151620.GB14917-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

Hi Kent,

Help with the docs is something I can do and I would be pleased to have the chance to contribute something back.

I would like to expand the document somewhat so that there is a short quickstart guide, your information on how it all works, detailed command reference, a howto section showing how to do things (such as shrink backing device!) and finally an updated list of sysfs structure.

I notice you are currently doing a lot of work on MD integration.  Is this functional yet?  Should the documentation show how to use MD with bCache?

I will work on it offline and email you the text file for review and you can include it when you are happy with it.

Would this be okay or would you prefer to keep it as it is and just fix the errors?

Also, are there any guidelines/requirements for documentation content/format or is it simply just that it has to be in one plain text file?

If you are happy with all this, I will get on it as soon as I can.   Please tell me if I am overstepping the mark here and you just want the docs fixing rather than expanding.

Regards,

James Sefton
Phase 5 Communications Ltd.

Tel: 01226 285600


-----Original Message-----
From: Kent Overstreet [mailto:koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org] 
Sent: 02 November 2012 15:16
To: James Sefton
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Bcache Journal

On Fri, Nov 02, 2012 at 03:44:00AM +0000, James Sefton wrote:
> Alex Pyrgiotis <apyrgio@...> writes:
> 
> > 
> > On 10/29/2012 10:43 PM, Kent Overstreet wrote:
> > > On Sun, Oct 28, 2012 at 06:20:19PM +0200, Alex Pyrgiotis wrote:
> > >> Hi,
> > >>
> > >> In the wiki, it is mentioned that bcache can run either with or
> > >> without a journal.
> > >> What I'd like to ask is which is the default bcache configuration
> > >> (journal on|off?) and is there an option in the make-bcache tool to
> > >> change this configuration?
> > > That's out of dat... What page did you find that on? Running without a
> > > journal hasn't been an option in ages...
> > Hi Kent,
> > 
> > Here's the link: http://bcache.evilpiepirate.org/Design#Journal
> > The out-dated part is "It is possible to create cache devices..."
> > >
> > > (You wouldn't want to run without the journal, it's there to improve
> > > performance)
> > Yeah, I know. Just wanted to have a look at bcache's knobs and switches...
> > Thanks again. 
> > 
> 
> 
> Hi Kent,
> 
> Out of interest - I am also having trouble with the docs and I am getting them 
> from the same server as Alex.
> 
> http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt
> 
> Just wondering if we are both looking in the wrong place??
> 
> The docs seem to be outdated somewhat.
> As an example there is a list of sysfs entries described at the bottom of the 
> page.  A lot of these either do not exist or have changed names, and a lot of 
> new ones seem to be added that are not listed in the docs.
> 
> Is this site the wrong place to be looking or are the docs simply out of date?

That's the right place, some of that is out of date though. I think it's
_mostly_ the sysfs stuff.

> (If the docs are out of date then maybe we can help you maintain them.)

Please do! All the documentation should be in the kernel tree, so you
can just send me patches for that. Any questions about what it should
say, go ahead and ask.
