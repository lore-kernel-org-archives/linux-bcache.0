From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: PostgreSQL licensed code on Linux
Date: Tue, 29 May 2018 15:55:16 -0700
Message-ID: <20180529225516.GH31712@garbanzo.do-not-panic.com>
References: <CAB=NE6XGCM0nZqvq74JPnSKgvL37Nkwvr3H3cAQ=ooTYJt7Rdg@mail.gmail.com>
 <20180529192643.GA3487@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529192643.GA3487@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Coly Li <colyli@suse.de>, Ciaran Farrell <ciaran.farrell@suse.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, linux-bcache@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tso Ted <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Jonas Oberg <jonas@fsfe.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, May 29, 2018 at 03:26:43PM -0400, Kent Overstreet wrote:
> On Tue, May 29, 2018 at 12:14:01PM -0700, Luis R. Rodriguez wrote:
> > The question over future possible PostgreSQL licensed code on Linux came up
> > to me recently. While doing some quick of digging around I found code
> > already under such license it seems:
> > 
> > The file drivers/md/bcache/util.c has:
> > 
> > cafe563591446 (Kent Overstreet 2013-03-23 16:11:31 -0700 318) /*
> > cafe563591446 (Kent Overstreet 2013-03-23 16:11:31 -0700 319)  * Portions
> > Copyright (c) 1996-2001, PostgreSQL Global Development Group (Any
> > cafe563591446 (Kent Overstreet 2013-03-23 16:11:31 -0700 320)  * use
> > permitted, subject to terms of PostgreSQL license; see.)
> > 
> > That seems to indicate that we've had already PostgreSQL licensed code on
> > Linux since Kent's addition of bcache to Linux in 2013. The portion of code
> > is rather small though, to me it seems to cover only crc_table[],
> > bch_crc64_update(), and bch_crc64(). Four things:
> 
> Yep, it's just that code.

Great, thanks for the confirmation.

> > a) This is the only code on Linux which seems to use PostgreSQL
> > b) The language for license seem to be cut off, 'see.' seems incomplete,
> > whereas typically it would point to a file with the full language text.
> > c) We can only infer what portions of the file are under this license
> > d) Even though some licenses claim to be GPL-Compatible, if possible we
> > should dual license such with the GPL if possible (*)
> > 
> > If some folks are considering adding yet more code to Linux which is
> > currently under a PostgreSQL license I figured reviewing the existing
> > PostgreSQL code's use may be a good start to set precedent for future work.
> > Since we already have at least one file with a PostgreSQL-sort-of boiler
> > plate it at least sets the precedent we have already sort of dealt with
> > PostgreSQL.
> > 
> > My recommendations:
> > 
> > As silly as it may be we should split out the PostgreSQL licensed code from
> > drivers/md/bcache/util.c into its own file and while at it clarify the
> > license.
> > 
> > If possible, if we can dual license this code with GPL it would be good as
> > it would do two things:
> > 
> > 1) Removes any ambiguity in case of questions over GPL Compatibility in the
> > future about the PostgreSQL license
> > 
> > 2) Other folks considering using PostgreSQL licensed code on Linux have a
> > template they can use
> 
> Sounds good to me, I'll defer to your judgement since you have more experience
> with these things than me :) Let me know if there's anything you need from me. I
> never modified that code besides renaming the functions, but dual licensing
> would be fine by me.

IANAL, but my recommendations below.

Trying to get all interested parties on Linux to agree PostgreSQL is
indeed GPL-Compatible is certainly possible but may require a bit of
legal billable hours on quite a bit of parts in the community. It takes
a long time...

Dual licensing would be preferred to avoid adding yet-another-license
and possibile ambiguities over compatibility, however, that would
require the original copyright holder's permission.

You can poke if you'd like, however there are two other alternatives.

a) License new code to GPL and add provenance notice for PostgreSQL
	-  Useful if we know upstream PostgreSQL does not care for our
	   own changes

b) Dual license GPL/PostgreSQL with provenance notice for the original
   PostgreSQL code.

   	- Useful if we know PostgreSQL may be interested in reaping
	  benefit of our own changes on Linux as well.

a) and b) are possible if you made changes to the code (even space and
style changes count). If you opt for a) our code on Linux and evolutions of it
remains GPL, but would annotate provenance from the PostgreSQL license.
It'd include language such as:

-------------------------------------------------------------------------------
<GPL header>

  * This file incorporates work covered by the following copyright and
  * permission notice: 

<Original PostgreSQL header and copyrght notice>
-------------------------------------------------------------------------------

So for instance this strategy was done on the carl9170 device driver rewrite
where Johannes took ISC licensed otus device driver from staging and
rewrote the driver based on it, an example file with the notice:

drivers/net/wireless/ath/carl9170/phy.c

This followed the guidence previously provided by SFLC on dealing with
this [0].

But since there may be other code coming up we have to consider what the
goals are.

  - Is the plan to consider incorporating more PostgreSQL
    licensed code on Linux? 

  - Is the goal to also let the PostgreSQL reap benefit of our own
    enhancements?
    
If so for both then, and we if we really dont' want to get a good set of
company attorneys to say "PostgreSQL is GPL compatible", then b)
should work. It would be something like:

-------------------------------------------------------------------------------
<GPL header>
etc... later version; or, when distributed separately from the Linux kernel or      
when incorporated into other software packages, subject to the license:    

<latest PostgreSQL header and copyrght notice with your name>

  * This file incorporates work covered by the following copyright and
  * permission notice: 

<Original PostgreSQL header and copyrght notice>
-------------------------------------------------------------------------------

[0] https://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html

  Luis
