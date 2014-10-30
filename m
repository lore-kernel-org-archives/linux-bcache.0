From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: Is bcache dead?
Date: Thu, 30 Oct 2014 16:34:25 -0700
Message-ID: <20141030233425.GA28233@kmo-pixel>
References: <545229F8.8000502@profihost.ag>
 <CALJ65zm0UpNKZKZmT26Gv6+CA6ijTS60+PVoCroLA4aipo-bPg@mail.gmail.com>
 <54529797.2020004@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58519 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161211AbaJ3Xc2 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Oct 2014 19:32:28 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so6067289pde.18
        for <linux-bcache@vger.kernel.org>; Thu, 30 Oct 2014 16:32:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <54529797.2020004@hardwarefreak.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Thu, Oct 30, 2014 at 02:55:03PM -0500, Stan Hoeppner wrote:
> On 10/30/2014 09:14 AM, Kent Overstreet wrote:
> > no, I've just been severely overworked, and overstressed, to the point
> > that it might be time for a change of jobs - and unfortunately, there
> > still isn't anyone else who can step in. It's not fun being the single
> > point of failure.
> 
> Don't sweat it Kent.  Don't get discouraged.  Stay positive.
> 
> I tried bcache a few weeks ago for a pretty niche application and it
> wasn't suitable for that workload for what I wanted it to do.  I asked
> questions here to make it work but got no responses.  Would have been a
> feather in your cap to had bcache on those systems--two 44TiB LUNs on
> the small ones, 14x 44TiB LUNs on the large one--if it could have been
> made to work with that workload.  We'll probably fix it by modifying the
> app to do full stripe buffer writes.  Yes, this is much more work than
> simply slapping in bcache, had it worked.  I was looking for a quick fix.
> 
> I know the demands from myself and others can create stress.  But when
> you feel stressed by it, remember that the demand is a direct result of
> you creating something special, that people really want to use.
> 
> You recognize and acknowledge the fact that you're a one man show right
> now.  Your users know it too.  Do what you can when you can, and do it
> right.  I think most people will be more forgiving of delays than
> mistakes, or broken promises, or silence.  Communication helps.  If
> you're bogged down, just post a quick note the list letting everyone
> know.  A quick update like that goes a long way, whereas silence breeds
> discontent among users, because they don't know what's going on.
> 
> Keep your chin up.  You'll get there, even if it takes longer than folks
> would like.
> 
> Best regards,
> 
> Stan

Thanks, I really do appreciate the kind words.
