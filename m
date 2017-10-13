From: Michael Lyle <mlyle@lyle.org>
Subject: Re: New bcache maintainer
Date: Thu, 12 Oct 2017 22:46:05 -0700
Message-ID: <df927a31-8b62-2c39-8311-f55b62aab204@lyle.org>
References: <20171013034922.3yuodviniahhwstx@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:55149 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdJMFqI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 01:46:08 -0400
Received: by mail-pf0-f174.google.com with SMTP id n89so820373pfk.11
        for <linux-bcache@vger.kernel.org>; Thu, 12 Oct 2017 22:46:07 -0700 (PDT)
In-Reply-To: <20171013034922.3yuodviniahhwstx@moria.home.lan>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org

On 10/12/2017 08:49 PM, Kent Overstreet wrote:
> Michael Lyle will be taking over the role of bcache maintainer. He has my
> complete confidence as well as excellent technical judgement and prior
> experinence, so please work with him and help him out :)
> 
> I'll still be available for questions/advice at the code; I've been discussing
> with Michael his work on the writeback code, and anyone else who's doing work on
> the bcache code should feel free to contact me as well - best way is as always
> via the bcache irc channel, on irc.oftc.net. But I'll still be focusing on
> bcachefs, and I expect that Michael and Coly and others will be able to handle
> most anything that comes up.
> 
> And now, I would like to ask everyone to thank Michael for taking this on,
> playing the maintainer role isn't exactly fun and I know he'll make a better
> maintainer than I ever was :)

Kent ---

Thanks for your support, you may be a little over-optimistic.

Everyone else--

I'm looking forward to working with you all to make bcache better--
faster, more robust, and more concurrent.

A bit of my background-- I've been running Linux since 0.99pl15.  I'm
currently maintainer of dRonin, a drone autopilot with a few thousand
users, and a few related repositories of tools.

Professionally, I've worked in the area of high-speed networking,
distributed systems, and block storage at a variety of startups.
including supervising and contributing to a bit of driver work.  I am
new to maintaining a subsystems, though, so I'd appreciate everyone's
help and patience.

I have a tree up at

https://github.com/mlyle/linux/ bcache-for-next

which contains linux-next and Coly's latest for-next patches, plus a
couple more on my control system series of changes.  I also have put up
a preliminary continuous integration builder at:

http://jar.lyle.org:8080/job/linux/

which right now just builds branches in my repository, but I am planning
to add some limited automated VM test of bcache to it and checkpatch
etc.  A summary of the current state of the bcache-for-next tree is
currently at:

http://jar.lyle.org:8080/job/linux/16/

Mike
