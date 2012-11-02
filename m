From: James Sefton <james-3k2nYdb70uTQXOPxS62xeg@public.gmane.org>
Subject: Re: Bcache Journal
Date: Fri, 2 Nov 2012 03:44:00 +0000 (UTC)
Message-ID: <loom.20121102T043837-976@post.gmane.org>
References: <508D5B43.4040504@cslab.ece.ntua.gr> <20121029204330.GA14917@google.com> <508EF98F.5040209@cslab.ece.ntua.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Alex Pyrgiotis <apyrgio@...> writes:

> 
> On 10/29/2012 10:43 PM, Kent Overstreet wrote:
> > On Sun, Oct 28, 2012 at 06:20:19PM +0200, Alex Pyrgiotis wrote:
> >> Hi,
> >>
> >> In the wiki, it is mentioned that bcache can run either with or
> >> without a journal.
> >> What I'd like to ask is which is the default bcache configuration
> >> (journal on|off?) and is there an option in the make-bcache tool to
> >> change this configuration?
> > That's out of dat... What page did you find that on? Running without a
> > journal hasn't been an option in ages...
> Hi Kent,
> 
> Here's the link: http://bcache.evilpiepirate.org/Design#Journal
> The out-dated part is "It is possible to create cache devices..."
> >
> > (You wouldn't want to run without the journal, it's there to improve
> > performance)
> Yeah, I know. Just wanted to have a look at bcache's knobs and switches...
> Thanks again. 
> 


Hi Kent,

Out of interest - I am also having trouble with the docs and I am getting them 
from the same server as Alex.

http://evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt

Just wondering if we are both looking in the wrong place??

The docs seem to be outdated somewhat.
As an example there is a list of sysfs entries described at the bottom of the 
page.  A lot of these either do not exist or have changed names, and a lot of 
new ones seem to be added that are not listed in the docs.

Is this site the wrong place to be looking or are the docs simply out of date?

(If the docs are out of date then maybe we can help you maintain them.)

Regards,

James
