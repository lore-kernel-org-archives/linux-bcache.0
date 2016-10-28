From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PULL] bcache: multiple updates
Date: Thu, 27 Oct 2016 19:12:33 -0600
Message-ID: <5160da7c-e38e-1527-2b09-2ca240df57c3@kernel.dk>
References: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33825 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935453AbcJ1BN0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Oct 2016 21:13:26 -0400
Received: by mail-pf0-f169.google.com with SMTP id n85so27086767pfi.1
        for <linux-bcache@vger.kernel.org>; Thu, 27 Oct 2016 18:12:37 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1610262037160.24191@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Kai Krakow <kai@kaishome.de>, Wido den Hollander <wido@widodh.nl>

On 10/27/2016 05:27 PM, Eric Wheeler wrote:
> Hi Jens,
>
> Please pull this v4.9-rc2 based series of bcache updates for v4.9-rc3:
> (You may disregard the previous -rc1-based request.)
>
>   git pull https://bitbucket.org/ewheelerinc/linux.git v4.9-rc2-bcache-updates
>
> Thank you!
>
> --
> Eric Wheeler
>
> ]# git log --oneline v4.9-rc2..HEAD
> bd532a6 bcache: partition support: add 16 minors per bcacheN device
> 3312845 bcache: Make gc wakeup sane, remove set_task_state()
> 6bb7f1e bcache: update bio->bi_opf bypass/writeback REQ_ flag hints
> 3d58a09 bcache: documentation for ioprio cache hinting
> 2e8884b bcache: introduce per-process ioprio-based bypass/writeback hints

How many of these are applicable to 4.9-rc3? I took a quick look at
them, and some of them look like they should go into the 4.10 branch
instead. We're after the merge window, so only strict fixes. Cleanups
and no features, no go.

-- 
Jens Axboe
