From: Tim Small <tim@buttersideup.com>
Subject: Re: bcache stability patches: Now mainlined!
Date: Wed, 24 Feb 2016 08:57:16 +0000
Message-ID: <56CD706C.3070400@buttersideup.com>
References: <CAO2mnow-HG_0pnDVFGfU0e+hPXfT=zMTrdemwiv=pxgJ+m4o2w@mail.gmail.com>
 <alpine.LRH.2.11.1512291807510.30746@mail.ewheeler.net>
 <56841B8B.6070306@kernel.dk> <20151231031500.GA8265@kmo-pixel>
 <5684A030.1040306@kernel.dk>
 <alpine.LRH.2.11.1602240626110.32077@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.251.4]:34778 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbcBXJnK (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 04:43:10 -0500
In-Reply-To: <alpine.LRH.2.11.1602240626110.32077@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org

On 24/02/16 06:45, Eric Wheeler wrote:
> I would like to thank everyone involved in getting these patches 
> mainlined.  Bcache should now be stable on the following releases:
> 
> 	mainline: 4.5-rc1 (and later)
> 	longterm: 4.1.18
> 	longterm: 3.18.27
> 
> Please test on your favorite branch and let us know how it goes.

According to https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=779628#25

... these patches are now in the Debian testing ("Stretch") kernel
(currently 4.3.x based), and it suggests that they may also be applied
to Debian stable ("Jessie") - which is 3.16.x based in a future Debian
"point release".

Cheers,

Tim.
