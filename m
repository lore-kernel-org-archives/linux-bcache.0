From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: md-raid5 with bcache member devices => kernel panic
Date: Fri, 6 Dec 2013 00:08:13 +0100
Message-ID: <20131205230813.GF1848@teapot>
References: <20131205212913.GE1848@teapot>
 <20131205225234.GA4054@kmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41252 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3LEXIX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Dec 2013 18:08:23 -0500
Content-Disposition: inline
In-Reply-To: <20131205225234.GA4054@kmo>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: nks@daterainc.com, linux-bcache@vger.kernel.org

On Thu, Dec 05, 2013 at 02:52:34PM -0800, Kent Overstreet wrote:
> On Thu, Dec 05, 2013 at 10:29:13PM +0100, Matthias Ferdinand wrote:
> Erk. I thought I was done with these bugs. Nick, do you think you could try and
> track this down?
> 
> Looking at this:
> http://dl.mfedv.net/md5raid_on_bcache_panic/mdraid5_on_bcache_panic_3.12.2.txt
> 
> that's a null pointer deref; if Matthias could get the exact line number it
I have no idea how to do that - can you help me out on that?

> Matthias - I'm running bcache on top of a raid6 at home and I've never seen
I only get panics when I use md-raid on top of bcaches:

              LVM
               |
           md-raid5
         /     |     \
  bcache0  bcache1  bcache2
   |           |       |
  sdb6       sdc6     sdd6

(probably an unusual setup; just playing around...)

To reproduce, just writing anything to an LV on top of this should do
(linear writes). If some r/w random i/o is then added (start of VM in my
setup), it breaks.

Regards
Matthias
