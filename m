From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.8.8, bcache deadlock and hard lockup
Date: Sun, 20 Nov 2016 16:04:13 -0800
Message-ID: <20161121000413.n5okcoqthaagiqel@merlins.org>
References: <20161118164643.g7ttuzgsj74d6fbz@merlins.org>
 <20161118184915.j6dlazbgminxnxzx@merlins.org>
 <b6c3daab-d990-e873-4d0f-0f0afe2259b1@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50771 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbcKUAES (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 20 Nov 2016 19:04:18 -0500
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

Well, let's see:

source and destination look like this:
mdadm raid 5 \
ssd bcache ----  dmcrypt - btrfs 

Then I do a 10TB btrfs send from dev1 to dev2

The exact commands, some I typed a long time ago. This is live data, not
a test environment I just spin up for testing.
That said, is that what you were asking about?

But as I said, right now I removed the caching device from dev2, so
bcache is still there but doing nothing, and I'm still getting kernel
OOM problems as per http://pastebin.com/2LUicF3k

I'm currently testing 4.19rc5 to see if the VM changes help my case.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
