From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL REQUEST]: bcache stability patches
Date: Sun, 29 Nov 2015 20:13:36 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1511291750520.5445@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from [71.19.153.34] ([71.19.153.34]:59137 "EHLO mail.ewheeler.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751788AbbK3EO2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Sun, 29 Nov 2015 23:14:28 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-bcache@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, Joshua Schmid <jschmid@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, Takashi Iwai <tiwai@suse.de>, Zheng Liu <gnehzuil.liu@gmail.com>, manover@gmail.com, g2p.code@gmail.com, stefan.bader@canonical.com

Hello all,

Please pull this bcache branch with stability patches and see if it fixes 
any issue that you might have!  If you have stability patches (*that you 
have tested*) which are not part of this branch, then please forward them 
so they can be included.

We have been using bcache with great performance and stability for over a 
year; it is the best SSD caching mechanism that we have found for our 
workload.  

I've been collecting these fixes for a while now and just put them up on 
github so they can be easily merged.  I continue to see mailing list 
discussions about problems that users are having which these patches 
address, so hopefully we can get these merged:
 
  https://github.com/ewheelerinc/linux/commits/bcache-patches-for-3.17
  git add remote ewheelerinc https://github.com/ewheelerinc/linux.git
  git fetch ewheelerinc
  git merge ewheelerinc/bcache-patches-for-3.17

This branch is from a clone of Linus's tree circa 3.17-rc so git merge 
should bring this in cleanly to any later branch.  This will merge cleanly 
into kernel.org longerm versions v4.1.13 and v3.18.24.  The original 
author is cited in each commit; you are being Cc'ed in this email if you 
are an author on any of these patches or are part of a mailing list thread 
indicating problems that this pull may fix.

Each commit includes `Cc: stable@vger.kernel.org` so if they get pulled 
into mainline we will see bcache stable on the newer LTS branches of 
kernel.org.

This git branch includes patches that have been collected and tested by 
Denis Bychkov from his post on 2015-09-16 with one exception: the 
refill_dirty() patch has been updated to the latest stable version which 
Kent posted the next day.  The refill_dirty patch addresses issues when 
bcache is backed by raid5/6 md's causing 
queue_limits->partial_stripes_expensive to be nonzero.


Kent,

Can this be sent to Jens for a pull into mainline?  If you can give your 
OK on this patchset then I'll approach Jens and see if he can pull this 
in.  Maybe Cc him in your response.

If there's anything in here that you would like to omit or change from 
this pull then let me know and I'll rebase.

Thanks!

-Eric



--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
