From: Michael Russo <mike@papersolve.com>
Subject: Re: Is bcache dead?
Date: Mon, 19 Jan 2015 18:36:59 +0000 (UTC)
Message-ID: <loom.20150119T192952-870@post.gmane.org>
References: <545229F8.8000502@profihost.ag> <CALJ65zm0UpNKZKZmT26Gv6+CA6ijTS60+PVoCroLA4aipo-bPg@mail.gmail.com> <54529797.2020004@hardwarefreak.com> <20141030233425.GA28233@kmo-pixel> <545B8DDC.4070905@bahj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52065 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbbASSkG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 19 Jan 2015 13:40:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glbd-linux-bcache@m.gmane.org>)
	id 1YDHF6-0005am-1l
	for linux-bcache@vger.kernel.org; Mon, 19 Jan 2015 19:40:04 +0100
Received: from pool-98-113-243-220.nycmny.fios.verizon.net ([98.113.243.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2015 19:40:04 +0100
Received: from mike by pool-98-113-243-220.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2015 19:40:04 +0100
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Zachary Palmer <zep_kernel.org <at> bahj.com> writes:

>  I expect I'm speaking on behalf of quite a few 
> people when I say that you've made things better in a subtle but 
> significant way.  :)
> 
> Cheers,
> 
> Zach
> 

I am a little late in this thread but I also wanted to say I appreciate the hard
 work put into bcache and I've had no trouble with it at all, except when my 
crappy OCZ VERTEX4 disappears (happens maybe once a month, or if the case gets a
 little too hot inside).  Then I'll need to reboot whether I'm in writeback 
OR writethrough mode (I've got bcache as my root FS and in both cases it's 
remounted r/o and bcache won't let me remount it r/w).  But it really makes 
things  faster (in either mode, though of course faster in writeback). Hopefully
 the stress level will go down and you will get some more time to work on 
bcache.
