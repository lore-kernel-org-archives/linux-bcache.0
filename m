From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Wed, 30 Apr 2014 10:24:55 -0700
Message-ID: <20140430172455.GA3029@birch.djwong.org>
References: <20140411002636.GB9176@birch.djwong.org>
 <20140411004649.GA4817@kmo>
 <20140411014135.GA18933@birch.djwong.org>
 <20140412023101.GC9176@birch.djwong.org>
 <CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19456 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422650AbaD3RZH (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 30 Apr 2014 13:25:07 -0400
Content-Disposition: inline
In-Reply-To: <CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Daniel Smedegaard Buus <danielbuus@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Sam Fulcomer <enotty@brown.edu>, Francis Moreau <francis.moro@gmail.com>, Daniel J Blueman <daniel@quora.org>, linux-bcache@vger.kernel.org

On Wed, Apr 30, 2014 at 01:51:14PM +0200, Daniel Smedegaard Buus wrote:
> Hi :)
> 
> What's the state of this?
> 
> I have this issue on a number of EC2 instances that are using bcache
> to speed up EBS access by caching on the ephemeral SSDs (writethrough
> mode).
> 
> "echo 0 > /sys/block/bcache0/bcache/writeback_running" as suggested by
> others stops the flood of "blocked" messages in dmesg, but it only
> partly fixes the 2.0 minimum load average issue (instead, it's now a
> 1.0 minimum load average).

I haven't spent time on figuring out the other source of load average.  Kent
didn't seem to like the patch to convert the bcache_writeback thread to
interruptible sleep (I recall he said it was 'wrong', but didn't elaborate).

--D
> 
> I just tried the latest kernel I could get my hands on for Ubuntu
> Trusty, the mainline v3.15-rc2 (built April 20th), and it exhibits the
> same behavior.
> 
> Thanks :)
> 
> Daniel
