From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.8.8, bcache deadlock and hard lockup
Date: Sun, 20 Nov 2016 13:26:50 -0800
Message-ID: <20161120212650.4ov7pk4e4syl4tju@merlins.org>
References: <20161118164643.g7ttuzgsj74d6fbz@merlins.org>
 <20161118184915.j6dlazbgminxnxzx@merlins.org>
 <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49437 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753826AbcKTV0z (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 20 Nov 2016 16:26:55 -0500
Content-Disposition: inline
In-Reply-To: <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: linux-bcache@vger.kernel.org

On Mon, Nov 21, 2016 at 05:13:41AM +0800, Coly Li wrote:
> Hi Marc,
> 
> Could you please give me an exact procedure that how the environment is
> configured, and how the commands are executed ? I will try them on my
> machine to reproduce it.

Thanks for offering.
So I did more testing, and while bcache piled up and died in the end,
the problem seems to be a VM issue and bcache might not handle some
memory case quite right, or may simply do everything right and be in a
losing battle with a VM problem.

Current details on
https://plus.google.com/u/0/+MarcMERLIN/posts/A3FrLVo3kc6
Right now I'm testing 3.19rc5 to see if it gets around this VM problem,
but I'm fairly sure at this point that bcache is not the issue.

Will report back.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
