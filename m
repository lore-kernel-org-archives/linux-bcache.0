From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Changes in /sys/bcache in kernel 3.13
Date: Tue, 18 Feb 2014 18:32:13 -0800
Message-ID: <20140219023213.GF24805@birch.djwong.org>
References: <5303DE88.3090801@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41199 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaBSCcT (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 18 Feb 2014 21:32:19 -0500
Content-Disposition: inline
In-Reply-To: <5303DE88.3090801@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: linux-bcache@vger.kernel.org

On Tue, Feb 18, 2014 at 11:28:24PM +0100, Rolf Fokkens wrote:
> Hi All,
> 
> bcache-status stopped working in kernel 3.13, see also:
> https://bugzilla.redhat.com/show_bug.cgi?id=1066555

Oh, there are RH bugzillas about bcache-status problems?  I guess that makes me
'upstream'.  :D

Well, I guess I'll fix the no-newline-at-end problem too.

> It's probably related to the change "Fix dirty_data accounting" in
> kernel 3.13-rc4. What specifically has changes is the fact that that
> /sys/fs/bcache/<UUID>/dirty_data has been removed, which breaks
> bcache-status (https://gist.github.com/djwong/6343451). Just
> removing the check / reference to this dirty_data item fixes
> bcache-status. Or has it been replaced by a specific item?

<shrug> I simply removed the dirty_data line and prettied up some of the
formatting too.  I don't have a problem with pulling the dirty data stats off
the backing device.

Gist updated.

--D
> 
> Oh, BTW: bcache.txt still refers to dirty_data in
> /sys/fs/bcache/<UUID> which doesn't seem correct to me.
> 
> Cheers,
> 
> Rolf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
