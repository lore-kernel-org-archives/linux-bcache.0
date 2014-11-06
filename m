From: Zachary Palmer <zep_kernel.org@bahj.com>
Subject: Re: Is bcache dead?
Date: Thu, 06 Nov 2014 10:03:56 -0500
Message-ID: <545B8DDC.4070905@bahj.com>
References: <545229F8.8000502@profihost.ag> <CALJ65zm0UpNKZKZmT26Gv6+CA6ijTS60+PVoCroLA4aipo-bPg@mail.gmail.com> <54529797.2020004@hardwarefreak.com> <20141030233425.GA28233@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 173-8-11-57-WashingtonDC.hfc.comcastbusiness.net ([173.8.11.57]:45999
	"EHLO bahj.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKFPVk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Nov 2014 10:21:40 -0500
In-Reply-To: <20141030233425.GA28233@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>


> On Thu, Oct 30, 2014 at 02:55:03PM -0500, Stan Hoeppner wrote:
>> On 10/30/2014 09:14 AM, Kent Overstreet wrote:
>>> no, I've just been severely overworked, and overstressed, to the point
>>> that it might be time for a change of jobs - and unfortunately, there
>>> still isn't anyone else who can step in. It's not fun being the single
>>> point of failure.
>> Don't sweat it Kent.  Don't get discouraged.  Stay positive.
>>
>> I tried bcache a few weeks ago for a pretty niche application and it
>> wasn't suitable for that workload for what I wanted it to do.  I asked
>> questions here to make it work but got no responses.  Would have been a
>> feather in your cap to had bcache on those systems--two 44TiB LUNs on
>> the small ones, 14x 44TiB LUNs on the large one--if it could have been
>> made to work with that workload.  We'll probably fix it by modifying the
>> app to do full stripe buffer writes.  Yes, this is much more work than
>> simply slapping in bcache, had it worked.  I was looking for a quick fix.
>>
>> I know the demands from myself and others can create stress.  But when
>> you feel stressed by it, remember that the demand is a direct result of
>> you creating something special, that people really want to use.
>>
>> You recognize and acknowledge the fact that you're a one man show right
>> now.  Your users know it too.  Do what you can when you can, and do it
>> right.  I think most people will be more forgiving of delays than
>> mistakes, or broken promises, or silence.  Communication helps.  If
>> you're bogged down, just post a quick note the list letting everyone
>> know.  A quick update like that goes a long way, whereas silence breeds
>> discontent among users, because they don't know what's going on.
>>
>> Keep your chin up.  You'll get there, even if it takes longer than folks
>> would like.
>>
>> Best regards,
>>
>> Stan
> Thanks, I really do appreciate the kind words.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
If I can throw mine in as well, I've been running bcache on my Debian 
Wheezy laptop for around a year now.  (I'm using the Debian backports 
3.12 kernel.)  When I first moved to bcache, I noticed that certain 
operations -- interacting with Git repositories and building LaTeX 
documents, for instance -- became much snappier.  I'm using a feeble 
little 32GB SSD that came with the laptop to cache a 1TB drive and I'm 
even using writethrough caching (more out of paranoia about the quality 
of my cheap little SSD than anything else), but it makes a difference.

Since then, it has been quietly humming along and I've stopped paying 
attention to it.  And that's the beauty of a good tool like this: I can 
stop paying attention to it.  I've enjoyed a year of better I/O and, 
other than in the initial setup, I haven't paid anything in maintenance 
burden: no instability, no hiccups, no unexplained hangs.  So for my 
part as an end user just trying to get a little edge out of my laptop 
hardware, thank you!  I expect I'm speaking on behalf of quite a few 
people when I say that you've made things better in a subtle but 
significant way.  :)

Cheers,

Zach
