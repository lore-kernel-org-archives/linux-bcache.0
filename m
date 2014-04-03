From: Vivek Dasmohapatra <vivek@collabora.co.uk>
Subject: Re: Issue (as expected) when upgrading from 3.12 to 3.13.7
Date: Thu, 3 Apr 2014 11:02:37 +0100 (BST)
Message-ID: <alpine.DEB.2.02.1404031057430.4261@noise.cbg.collabora.co.uk>
References: <lh8t08$1dd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38882 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaDCKCl (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 3 Apr 2014 06:02:41 -0400
In-Reply-To: <lh8t08$1dd$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Sun, 30 Mar 2014, Francis Moreau wrote:

Hi Francis: A quick question for you if you have the time:
How is the bcache constructed? ie which devices are in it?

I have had similar lockup problems when using partitions
as backing, but not whole devices. That is to say:

    { ram0 : sdb1 }  often deadlocks for me (depending on the offset
                     of the partition)

    { ram0 : sdb  }  always seems to work fine

Although in neither case am I able to tear down the device and
flush it all to backing after heavy use: That always locks up
for me. (Fortunately I'm making throwaway filesystems for a build
daemon so that part I can live with).
