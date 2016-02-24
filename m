From: Marc MERLIN <marc@merlins.org>
Subject: Disabling bcache from boot when it crashes?
Date: Wed, 24 Feb 2016 08:37:16 -0800
Message-ID: <20160224163716.GA19447@merlins.org>
References: <20160215060410.GA30802@merlins.org> <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59868 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbcBXQhh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 24 Feb 2016 11:37:37 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1602240403300.32077@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Wed, Feb 24, 2016 at 06:53:05AM +0000, Eric Wheeler wrote:
> Do you have the bcache stability patches? 4.3.3 might be missing some 
> critical patches.
> 
> Be sure to cherry-pick these from linux 4.5-rc1:
> 	git cherry-pick 2ef9ccbf~1..627ccd20
> or use one of the 4.1 or 3.18 longterm kernels.
> 
> I've not see any memory allocation issues before in bcache, but you 
> definitely want those patches for general stability.

I'm running 4.4.2, so I'm assuming I don't have those fixes, thanks for the
heads up.

Well, your message is timely, just as you wrote this, I got bcache that
crashed my system as I was shutting down, and then I was unable to ever
reboot because bcache would detect my partitions, start bcache, and crash
before I could do anything to fix it.

A few questions though:
1) is there any bcache boot option I can give to disable bcache at boot
time?

2) I had to boot from rescue media and sadly the version of wipefs there
wasn't good enough to find the bcache sig and remove it.
I then tried to change the bcache cache partition type to 0, but that didn't
help either.
Eventually I had to shrink the bcache cache partition to 1 cylinder and
finally then it stopped being detected at boot and the crashes stopped.
(dd of /dev/zero would have worked, but it's an ssd, and I didn't want to
allocate blocks on the flash that had not been used yet to give more room
for garbage collection).

Was there a better way of doing this?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
