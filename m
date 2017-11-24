From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: Bcache confirmed unsafe with 4.14.0? 4.14.1?
Date: Fri, 24 Nov 2017 16:22:53 +0700
Message-ID: <788678673.20171124162253@pvgoran.name>
References: <20171124074112.7x7nnnqabrc3werm@merlins.org>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:54501 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdKXJW5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 04:22:57 -0500
In-Reply-To: <20171124074112.7x7nnnqabrc3werm@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

Hello Marc,

Friday, November 24, 2017, 2:41:12 PM, you wrote:

> I have bcache | dmcrypt | btrfs, and I was upgrading to 4.14.0 when
> someone told me about the corruption problems people noticed in 4.14.0

> Is there an understood root cause and something to avoid to not trigger
> the bug, or not so much?

The bug was caused by a change in the block layer code (outside of bcache),
commit 74d46992e0d9dee7f1f376de0d56d31614c8a17a, "block: replace bi_bdev with
a gendisk pointer and partitions index". I don't know if there are any
specific usage patterns that trigger the problem. I strongly suggest not to
run the affected kernel versions on any machine that uses bcache (or, even
better, on any machine at all).

> I saw a bunch of patches go by and I'm not too clear if 4.14.1 is safe,
> or not.

In 4.14.1 (as published here
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/tag/?h=v4.14.1),
this bug was not fixed yet. However, the very recent 4.14.2 does contain the
fix (commit 62530ed8b1d07a45dec94d46e521c0c6c2d476e6, "bio: ensure
__bio_clone_fast copies bi_partno").

> Can someone advise?

> Thanks,
> Marc

Pavel Goran
  
