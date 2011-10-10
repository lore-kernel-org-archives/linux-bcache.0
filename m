From: LuVar <luvar@plaintext.sk>
Subject: Re: [GIT] Bcache version 12
Date: Mon, 10 Oct 2011 13:35:02 +0100 (GMT+01:00)
Message-ID: <741908052.14171318250102625.JavaMail.root@shiva>
References: <20111006175808.GA9886@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111006175808.GA9886@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk, akpm@linux-foundation.org, neilb@suse.de, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-bcache@vger.kernel.org

Hi,

----- "Pavel Machek" <pavel@ucw.cz> wrote:

> Hi!
> 
> > It can cache filesystem metadata - it can cache anything.
> > 
> > Because bcache has its own superblock (much like md), it can
> guarantee
> > that bcache devices are consistent; this is particularly important
> if
> > you want to do writeback caching. You really don't want to
> accidently
> > mount a filesystem that you were doing writeback caching on without
> the
> > ache - bcache makes it impossible to do so accidently.
> > 
> > Is any of that useful?
> 
> I guess some kind of benchmark would be nice....? I don't know what
> fair workload for this is. System bootup? Kernel compile after
> reboot?

I guess, fair benchmark is ordinary work... For example I have running my PC with uptimes sometimes more than 10 days, so booting up is not critical. For me is critical startup of my eclipse with some workspace (work, school, personal...). To have more standard comparison I suggest to have some "standard" (average user) workload for testing. Somewhere I have seen to do:
1. system bootup
2. startup of some programs (firefox,gimp,hugin)
3. do some work in openned programs (they used some macros)
4. save all work and shutdown pc

Imho measuring time for something like this could be relevant measure of general speedup => user experience speedup. This workload probably could be simulated by running phoronix test suite.

To measure speedup in some other quantity (kbps, iops...) there is probably problem with workload type (database, iozone...). Random benchmark will just measure how bcache slows down random operations. To measure speed up there have to be some repetitive io reading from disk (starting same programs...).

PS: I want to make some time to install bcache and try to make some simple benchmarks.... I hope that I will find some time for this around Christmas...

> 
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
