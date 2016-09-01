From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH V2 00/22] Replace the CFQ I/O Scheduler with BFQ
Date: Thu, 1 Sep 2016 14:06:02 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1609011349290.5413@mail.ewheeler.net>
References: <1470654917-4280-1-git-send-email-paolo.valente@linaro.org> <20160808131954.GA12647@infradead.org> <20160831220949.GD5967@sirena.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160831220949.GD5967@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, linux-bcache@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: linux-bcache@vger.kernel.org

On Wed, 31 Aug 2016, Mark Brown wrote:
[...]
> I personally feel that given that it looks like this is all going to
> take a while it'd still be good to merge BFQ at least as an alternative
> scheduler so that people can take advantage of it while the work on
> modernising everything to use blk-mq - that way we can hopefully improve
> the state of the art for users in the short term or at least help get
> some wider feedback on how well this works in the real world
> independently of the work on blk-mq.

I would like to chime in agree fervently with Mark.  

We have a pair of very busy hypervisors with a complicated block stack 
integrating bcache, drbd, LVM, dm-thin, kvm, ggaoed (AoE target), zram 
swap, continuous block-layer backups and snapshot verifies to tertiary 
storage, cgroup block IO throttled limits, and lots of hourly dm-thin 
snapshots replicated to tertiary storage.  All of this is performed under 
heavy memory pressure (35-40% swapped out to zram).

The systems work moderately well under cfq, but *amazingly well* using 
BFQ.  I like BFQ so much that I've backported v8r2 to Linux v4.1 [1].

+1 to upstream this as a new scheduler without replacing CFQ.

Including BFQ would be a boon for Linux and the community at large.

--
Eric Wheeler

[1] Based on Linux v4.1-rc1, it cleanly merges forward into v4.7:
	https://bitbucket.org/ewheelerinc/linux/branch/v4.1-rc1-bfq-v8
	git pull https://bitbucket.org/ewheelerinc/linux.git v4.1-rc1-bfq-v8
