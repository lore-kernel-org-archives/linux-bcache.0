From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is bcache dead?
Date: Thu, 30 Oct 2014 14:55:03 -0500
Message-ID: <54529797.2020004@hardwarefreak.com>
References: <545229F8.8000502@profihost.ag> <CALJ65zm0UpNKZKZmT26Gv6+CA6ijTS60+PVoCroLA4aipo-bPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:41012 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbaJ3Tyb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 30 Oct 2014 15:54:31 -0400
In-Reply-To: <CALJ65zm0UpNKZKZmT26Gv6+CA6ijTS60+PVoCroLA4aipo-bPg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On 10/30/2014 09:14 AM, Kent Overstreet wrote:
> no, I've just been severely overworked, and overstressed, to the point
> that it might be time for a change of jobs - and unfortunately, there
> still isn't anyone else who can step in. It's not fun being the single
> point of failure.

Don't sweat it Kent.  Don't get discouraged.  Stay positive.

I tried bcache a few weeks ago for a pretty niche application and it
wasn't suitable for that workload for what I wanted it to do.  I asked
questions here to make it work but got no responses.  Would have been a
feather in your cap to had bcache on those systems--two 44TiB LUNs on
the small ones, 14x 44TiB LUNs on the large one--if it could have been
made to work with that workload.  We'll probably fix it by modifying the
app to do full stripe buffer writes.  Yes, this is much more work than
simply slapping in bcache, had it worked.  I was looking for a quick fix.

I know the demands from myself and others can create stress.  But when
you feel stressed by it, remember that the demand is a direct result of
you creating something special, that people really want to use.

You recognize and acknowledge the fact that you're a one man show right
now.  Your users know it too.  Do what you can when you can, and do it
right.  I think most people will be more forgiving of delays than
mistakes, or broken promises, or silence.  Communication helps.  If
you're bogged down, just post a quick note the list letting everyone
know.  A quick update like that goes a long way, whereas silence breeds
discontent among users, because they don't know what's going on.

Keep your chin up.  You'll get there, even if it takes longer than folks
would like.

Best regards,

Stan
