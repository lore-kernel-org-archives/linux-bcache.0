From: "Stephen R. van den Berg" <srb@cuci.nl>
Subject: Re: 3.18.3 + latest bcache-dev
Date: Wed, 21 Jan 2015 17:45:53 +0100
Message-ID: <20150121164553.GA15237@cuci.nl>
References: <20150121012424.GB5533@cuci.nl>
 <CALJ65znLYCJaN2fHx0-7P8RQHPUVkaBpw=ckt0_tQjznth35rw@mail.gmail.com>
 <20150121110400.GA14729@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:49058 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbAUQqA (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 21 Jan 2015 11:46:00 -0500
Content-Disposition: inline
In-Reply-To: <20150121110400.GA14729@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Well, what I did was:
- Take out sdg.
- Reformat both caching and backing devices and started over.

I still have the kernel logs of the previous fault condition, but
not the data anymore.

What I notice are:
- The 100% CPU usage for four bcache_writebac processes is back.  I've
  already tried raising the value you suggested from 30 to 60, but I did
  not have an opportunity to reboot yet.  Will report back on this.
- When I run bcache-super-show on the backing devices, it works just fine.
- When I run bcache-super-show on the caching devices (while in service)
  I get something like this:

sb.magic		ok
sb.first_sector		8 [match]
sb.csum			FFFFFFFF5D55BF8D [expected 726D3B42D08769EC]
Corrupt superblock (bad csum)

  On both caching devices.  Is this to be expected?
-- 
Stephen.
