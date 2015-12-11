From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: SSD failed - can I recover data from HDDs
Date: Fri, 11 Dec 2015 15:05:23 +0100
Message-ID: <20151211150523.Horde.FPYUrIAxjf2RB9mfwnBrrvR@www3.nde.ag>
References: <loom.20150524T023926-291@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:61285 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbbLKOLa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 11 Dec 2015 09:11:30 -0500
In-Reply-To: <loom.20150524T023926-291@post.gmane.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter <pkozbial@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi Peter,

first of all, is there some date setup problem with your client  
machine or has the issue been resolved as it is from May? ;)

> Received: [...]
>        for <linux-bcache@vger.kernel.org>; Fri, 11 Dec 2015 04:10:05 +0100
> X-Injected-Via-Gmane: http://gmane.org/
> To:	linux-bcache@vger.kernel.org
> From:	Peter <pkozbial@gmail.com>
> Subject: SSD failed - can I recover data from HDDs
> Date:	Sun, 24 May 2015 00:46:33 +0000 (UTC)


Zitat von Peter <pkozbial@gmail.com>:

> I've set up bcache with one SSD and two HDD (using btrfs).
>
> Unfortunately after power failure the first SSD partition (root) is
> corrupted, the second (swap) and the third (bcache caching) are fine.
>
> I have two (btrfs formatted) hard drives and would really really love to
> have my data recovered from the hard drives (2 x 5TB). Is there any guide
> how to do that?

have you tried booting the machine via some recovery media, loading  
the bcache module and then manually registering both the cache and the  
backing devices? If both HDDs and the caching partition on the SSD are  
intact, this should work.

Generally, I'd then backup the data that you want to keep safe.

Depending on what you intent to do with the SSD and how bcache was set  
up, you then may want to make sure the cache is fully migrated to the  
HDDs. That should enable you to replace the SSD, if desired.

You have not indicated what you want to do to recover the remainders  
of your system - if you simply want to reload some backup, then  
setting up bcache manually should be ok. If you're reinstalling your  
"root" (without touching the bcache'd devices nor the bcache  
partition) and set up bcache afterward, you ought to be fine, too.

Regards,
Jens
