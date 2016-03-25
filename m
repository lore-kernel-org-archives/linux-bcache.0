From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Bug - bcache: "unable to handle kernel NULL pointer dereference"
 when trying to add a md caching device
Date: Fri, 25 Mar 2016 01:49:18 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
References: <56F4058B.1030309@roesner-online.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:34465 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbcCYBtY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 24 Mar 2016 21:49:24 -0400
In-Reply-To: <56F4058B.1030309@roesner-online.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Cc: linux-bcache@vger.kernel.org

On Thu, 24 Mar 2016, Sebastian Roesner wrote:
> I experienced a bug after upgrading to a recent kernel (4.5.0).
> 
> # echo /dev/md2 > /sys/fs/bcache/register
> 
> gives me a stack trace.
> 
> I created a bug in the kernel bugtracker but I'm not sure if it has been
> noticed by the bcache developers:
> 
> <https://bugzilla.kernel.org/show_bug.cgi?id=114871>

The dereference appears to happen inside of bio_trim which is core block 
code.  In this case, it looks like bio_trim is being passed a null pointer 
to *bio, but by whom?  

Please send this output:

tail /sys/block/md2/queue/discard_*

> Could somebody have a look?

It could be an allocation failure in bcache that gets pushed down the 
stack at registration.  If that is the case, please pull these two fixes 
branches which may have missed 4.5:

git pull https://bitbucket.org/ewheelerinc/linux v4.5-rc6-bcache-fixes
git pull https://bitbucket.org/ewheelerinc/linux v4.5-rc7-bcache-fixes


For list reference, this is the trace:

Mar 17 21:54:20 gropius kernel: [ 1544.712759] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
Mar 17 21:54:20 gropius kernel: [ 1544.712847] IP: [<ffffffff811e53b4>] bio_trim+0xf/0x2a
[...]
Mar 17 21:54:20 gropius kernel: [ 1544.717685]  [<ffffffffa008c3be>] ? raid1_make_request+0x2e8/0xad7 [raid1]
Mar 17 21:54:20 gropius kernel: [ 1544.717718]  [<ffffffff811f07da>] ? blk_queue_split+0x377/0x3d4
Mar 17 21:54:20 gropius kernel: [ 1544.717754]  [<ffffffffa006cb5f>] ? md_make_request+0xf6/0x1e9 [md_mod]
Mar 17 21:54:20 gropius kernel: [ 1544.717787]  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
Mar 17 21:54:20 gropius kernel: [ 1544.717824]  [<ffffffffa045dc79>] ? prio_io+0x85/0x95 [bcache]
Mar 17 21:54:20 gropius kernel: [ 1544.717858]  [<ffffffffa0460205>] ? register_cache_set+0x355/0x8d0 [bcache]
Mar 17 21:54:20 gropius kernel: [ 1544.717893]  [<ffffffffa046177b>] ? register_bcache+0xffb/0x114b [bcache]

-Eric
