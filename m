From: Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: /dev/bcache* missing after reboot
Date: Thu, 5 Dec 2013 16:37:49 +0100
Message-ID: <20131205153749.GA1848@teapot>
References: <9FA7630E-7DC4-4F45-B5E1-FFFB511EFA8B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from sw.mfedv.net ([212.82.36.162]:41222 "EHLO sw.mfedv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3LEPh5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Thu, 5 Dec 2013 10:37:57 -0500
Content-Disposition: inline
In-Reply-To: <9FA7630E-7DC4-4F45-B5E1-FFFB511EFA8B@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Thierry De Leeuw <deleeuw.thierry@gmail.com>
Cc: linux-bcache@vger.kernel.org

[already sent 2 days ago, but did not appear on the list]

On Mon, Dec 02, 2013 at 11:36:47PM +0100, Thierry De Leeuw wrote:
> Hi,
> 
> Running Linux 3.12.1. I have disk /dev/sda2 with LVM that has, amongst
> other, lvHome as a bcache device, and the cache resides on /dev/sdb1
> 
> My PC hung and I had to do a forced shutdown.
> 
> Now the /dev/bcache0 (and so on) do not appear anymore.

Perhaps you need to re-register / re-attach the backing device to the
caching device, something like 

   echo /dev/dm-xx > /sys/fs/bcache/register
   echo yyyyyyy > /sys/devices/virtual/block/dm-xx/bcache/attach   

If that does not help, you can try to force starting the bcache backing
device without the caching device (might give you serious fs damage with
writeback):

  echo "1" > /sys/devices/virtual/block/dm-xx/bcache/running

But since you are using LVM, you might want to create a snapshot of the
backing device LV before doing this, just in case.

Regards
Matthias
