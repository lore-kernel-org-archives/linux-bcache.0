From: Jan Wiele <jan@wiele.org>
Subject: Re: Hang in bcache/qemu
Date: Thu, 19 Jan 2017 15:06:15 +0100
Message-ID: <2468407.km8j8RHp0H@j-t460p>
References: <2059985.veGUll5WnS@j-t460p> <4700072.elc5RSLsh5@j-t460p> <20170119134244.f6bydzrfsghq57ll@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from fabrik17.de ([78.47.224.236]:56720 "EHLO mail.fabrik17.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752783AbdASOGk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 19 Jan 2017 09:06:40 -0500
In-Reply-To: <20170119134244.f6bydzrfsghq57ll@moria.home.lan>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

Am Donnerstag, 19. Januar 2017, 04:42:44 CET schrieb Kent Overstreet:
> On Thu, Jan 19, 2017 at 01:22:47PM +0100, Jan Wiele wrote:
> > Am Mittwoch, 18. Januar 2017, 09:48:30 CET schrieb Andre Noll:
> > > On Wed, Jan 18, 04:35, Kai Krakow wrote
> > > 
> > > FWIW, I'm seeing this as well on different hardware, and with both
> > > deadline and CFQ, so it's not a scheduler issue. The problem seems to
> > > be the bcache writeback thread calling down_write(&dc->writeback_lock)
> > > while already holding this lock.
> > 
> > Yes, the bug doesn't get triggered when the caching mechanism is set to
> > writethrough.
> 
> Is there something else blocked that's holding writeback_lock?

I'm not seeing any other blocked tasks in the kernel log, if it is that what 
you mean. 

If you could provide me with some instructions to follow on a hang, I will try 
to reproduce it next weekend.
