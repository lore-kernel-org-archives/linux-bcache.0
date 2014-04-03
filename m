From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Issue (as expected) when upgrading from 3.12 to 3.13.7
Date: Thu, 03 Apr 2014 18:18:35 +0200
Message-ID: <533D89DB.2060306@gmail.com>
References: <lh8t08$1dd$1@ger.gmane.org> <alpine.DEB.2.02.1404031057430.4261@noise.cbg.collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:63047 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaDCQRS (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 3 Apr 2014 12:17:18 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so2083606wes.20
        for <linux-bcache@vger.kernel.org>; Thu, 03 Apr 2014 09:17:17 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.02.1404031057430.4261@noise.cbg.collabora.co.uk>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Vivek Dasmohapatra <vivek@collabora.co.uk>
Cc: linux-bcache@vger.kernel.org

On 04/03/2014 12:02 PM, Vivek Dasmohapatra wrote:
> On Sun, 30 Mar 2014, Francis Moreau wrote:
> 
> Hi Francis: A quick question for you if you have the time:
> How is the bcache constructed? ie which devices are in it?
> 

sure: I'm using bcache on a very basic setup: no MD or LVM involved.
/dev/sda4 (900Mo) is the backing device while /dev/sdb (120G) is the
cache device. On top of bcache0 I'm using ext4 and I'm using it as my
root device.

> I have had similar lockup problems when using partitions
> as backing, but not whole devices. That is to say:
> 
>     { ram0 : sdb1 }  often deadlocks for me (depending on the offset
>                      of the partition)
> 
>     { ram0 : sdb  }  always seems to work fine
> 
> Although in neither case am I able to tear down the device and
> flush it all to backing after heavy use: That always locks up
> for me. (Fortunately I'm making throwaway filesystems for a build
> daemon so that part I can live with).
> 

For now it doesn't endup to lock up (cross fingers). It only fills the
kernel logs, well I hope.

Thanks.
