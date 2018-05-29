From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: PostgreSQL licensed code on Linux
Date: Tue, 29 May 2018 15:26:43 -0400
Message-ID: <20180529192643.GA3487@kmo-pixel>
References: <CAB=NE6XGCM0nZqvq74JPnSKgvL37Nkwvr3H3cAQ=ooTYJt7Rdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAB=NE6XGCM0nZqvq74JPnSKgvL37Nkwvr3H3cAQ=ooTYJt7Rdg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Coly Li <colyli@suse.de>, Ciaran Farrell <ciaran.farrell@suse.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, linux-bcache@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tso Ted <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Jonas Oberg <jonas@fsfe.org>
List-Id: linux-bcache@vger.kernel.org

On Tue, May 29, 2018 at 12:14:01PM -0700, Luis R. Rodriguez wrote:
> The question over future possible PostgreSQL licensed code on Linux came up
> to me recently. While doing some quick of digging around I found code
> already under such license it seems:
> 
> The file drivers/md/bcache/util.c has:
> 
> cafe563591446 (Kent Overstreet 2013-03-23 16:11:31 -0700 318) /*
> cafe563591446 (Kent Overstreet 2013-03-23 16:11:31 -0700 319)  * Portions
> Copyright (c) 1996-2001, PostgreSQL Global Development Group (Any
> cafe563591446 (Kent Overstreet 2013-03-23 16:11:31 -0700 320)  * use
> permitted, subject to terms of PostgreSQL license; see.)
> 
> That seems to indicate that we've had already PostgreSQL licensed code on
> Linux since Kent's addition of bcache to Linux in 2013. The portion of code
> is rather small though, to me it seems to cover only crc_table[],
> bch_crc64_update(), and bch_crc64(). Four things:

Yep, it's just that code.

> 
> a) This is the only code on Linux which seems to use PostgreSQL
> b) The language for license seem to be cut off, 'see.' seems incomplete,
> whereas typically it would point to a file with the full language text.
> c) We can only infer what portions of the file are under this license
> d) Even though some licenses claim to be GPL-Compatible, if possible we
> should dual license such with the GPL if possible (*)
> 
> If some folks are considering adding yet more code to Linux which is
> currently under a PostgreSQL license I figured reviewing the existing
> PostgreSQL code's use may be a good start to set precedent for future work.
> Since we already have at least one file with a PostgreSQL-sort-of boiler
> plate it at least sets the precedent we have already sort of dealt with
> PostgreSQL.
> 
> My recommendations:
> 
> As silly as it may be we should split out the PostgreSQL licensed code from
> drivers/md/bcache/util.c into its own file and while at it clarify the
> license.
> 
> If possible, if we can dual license this code with GPL it would be good as
> it would do two things:
> 
> 1) Removes any ambiguity in case of questions over GPL Compatibility in the
> future about the PostgreSQL license
> 
> 2) Other folks considering using PostgreSQL licensed code on Linux have a
> template they can use

Sounds good to me, I'll defer to your judgement since you have more experience
with these things than me :) Let me know if there's anything you need from me. I
never modified that code besides renaming the functions, but dual licensing
would be fine by me.
