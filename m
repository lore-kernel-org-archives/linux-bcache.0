From: Marc MERLIN <marc@merlins.org>
Subject: Re: Bcache confirmed unsafe with 4.14.0? 4.14.1?
Date: Fri, 24 Nov 2017 08:29:56 -0800
Message-ID: <20171124162956.slic7hvffpivhohp@merlins.org>
References: <20171124074112.7x7nnnqabrc3werm@merlins.org>
 <788678673.20171124162253@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52297 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753484AbdKXQaB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 11:30:01 -0500
Content-Disposition: inline
In-Reply-To: <788678673.20171124162253@pvgoran.name>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pavel Goran <via-bcache@pvgoran.name>
Cc: linux-bcache@vger.kernel.org

On Fri, Nov 24, 2017 at 04:22:53PM +0700, Pavel Goran wrote:
> Hello Marc,
> 
> Friday, November 24, 2017, 2:41:12 PM, you wrote:
> 
> > I have bcache | dmcrypt | btrfs, and I was upgrading to 4.14.0 when
> > someone told me about the corruption problems people noticed in 4.14.0
> 
> > Is there an understood root cause and something to avoid to not trigger
> > the bug, or not so much?
> 
> The bug was caused by a change in the block layer code (outside of bcache),
> commit 74d46992e0d9dee7f1f376de0d56d31614c8a17a, "block: replace bi_bdev with
> a gendisk pointer and partitions index". I don't know if there are any
> specific usage patterns that trigger the problem. I strongly suggest not to
> run the affected kernel versions on any machine that uses bcache (or, even
> better, on any machine at all).
> 
> > I saw a bunch of patches go by and I'm not too clear if 4.14.1 is safe,
> > or not.
> 
> In 4.14.1 (as published here
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/tag/?h=v4.14.1),
> this bug was not fixed yet. However, the very recent 4.14.2 does contain the
> fix (commit 62530ed8b1d07a45dec94d46e521c0c6c2d476e6, "bio: ensure
> __bio_clone_fast copies bi_partno").

Thanks for clearing that up, I duly appreciate it.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
