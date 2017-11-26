From: Marc MERLIN <marc@merlins.org>
Subject: Re: bcache removal: ida_remove called for id=64 which is not
 allocated.
Date: Sat, 25 Nov 2017 16:06:09 -0800
Message-ID: <20171126000609.fnhh2guxhtqptanv@merlins.org>
References: <20171125231127.7kv7uypcj3pbddqo@merlins.org>
 <86f09bf6-0953-4345-43e6-1f61bd7cef14@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53488 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdKZAGK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Nov 2017 19:06:10 -0500
Content-Disposition: inline
In-Reply-To: <86f09bf6-0953-4345-43e6-1f61bd7cef14@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org

On Sat, Nov 25, 2017 at 03:40:44PM -0800, Michael Lyle wrote:
> I believe this is fixed by 1dbe32ad0a82f39c6 which is in Linus's tree
> for 4.15.  Unfortunately it's not a candidate for -stable because it
> changes device numbering.
> 
> Can you easily try a 4.15 RC to see if this is fixed for you?

Thanks.
I'll try when I can later, but basically it's not urgent for me, I'm
rarely in a situation where I can even trigger this, so I mostly wanted
to make sure it was a known thing, which it seems to be :)

Thanks for the quick reply
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
