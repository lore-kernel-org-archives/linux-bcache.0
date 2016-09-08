From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2 00/22] Replace the CFQ I/O Scheduler with BFQ
Date: Thu, 8 Sep 2016 14:11:29 +0200
Message-ID: <e793b5d5-b41b-72eb-30a0-a62907fadc99@suse.de>
References: <1470654917-4280-1-git-send-email-paolo.valente@linaro.org>
 <20160808131954.GA12647@infradead.org> <20160831220949.GD5967@sirena.org.uk>
 <alpine.LRH.2.11.1609011349290.5413@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49505 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752029AbcIHMLc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Sep 2016 08:11:32 -0400
In-Reply-To: <alpine.LRH.2.11.1609011349290.5413@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, Mark Brown <broonie@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, linux-bcache@vger.kernel.org, Omar Sandoval <osandov@fb.com>

On 09/01/2016 11:06 PM, Eric Wheeler wrote:
> On Wed, 31 Aug 2016, Mark Brown wrote:
> [...]
>> I personally feel that given that it looks like this is all going to
>> take a while it'd still be good to merge BFQ at least as an alternative
>> scheduler so that people can take advantage of it while the work on
>> modernising everything to use blk-mq - that way we can hopefully improve
>> the state of the art for users in the short term or at least help get
>> some wider feedback on how well this works in the real world
>> independently of the work on blk-mq.
> 
> I would like to chime in agree fervently with Mark.  
> 
> We have a pair of very busy hypervisors with a complicated block stack 
> integrating bcache, drbd, LVM, dm-thin, kvm, ggaoed (AoE target), zram 
> swap, continuous block-layer backups and snapshot verifies to tertiary 
> storage, cgroup block IO throttled limits, and lots of hourly dm-thin 
> snapshots replicated to tertiary storage.  All of this is performed under 
> heavy memory pressure (35-40% swapped out to zram).
> 
> The systems work moderately well under cfq, but *amazingly well* using 
> BFQ.  I like BFQ so much that I've backported v8r2 to Linux v4.1 [1].
> 
> +1 to upstream this as a new scheduler without replacing CFQ.
> 
> Including BFQ would be a boon for Linux and the community at large.
> 
Personally, the main grudge I have against the BFQ patchset is that it
_replaces_ the existing CFQ.
CFQ with all its drawbacks is reasonably well understood, and we have a
very large performance dataset. Replacing it with BFQ will invalidate
all of this, with us having to redo _every_ of these performance tests.
If, OTOH, BFQ would be added as an alternative to CFQ we could switch to
it during runtime, allowing the user to configure the system as he sees
fit. We did the same thing for the 'as' scheduler, so it's not a problem
in principle.

With that modification it's then a matter of policy whether it _should_
be integrated into the mainline kernel, seeing that it'll be part of a
deemed obsolete subsystem.
But this behaviour is precisely what made me giving up on hacking qemu;
patches are being ignored or turned down because they are touching areas
which are supposed be rewritten in the near future.
And no deadline given nor any repositories to be had where this rewrite
could be looked at.
Which makes contributing _really_ hard and very frustrating; and I think
this indeed would be a suitable topic for KS.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
