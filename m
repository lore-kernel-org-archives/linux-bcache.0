From: Vivek Dasmohapatra <vivek@collabora.co.uk>
Subject: Re: Issue (as expected) when upgrading from 3.12 to 3.13.7
Date: Thu, 3 Apr 2014 17:21:32 +0100 (BST)
Message-ID: <alpine.DEB.2.02.1404031719310.4261@noise.cbg.collabora.co.uk>
References: <lh8t08$1dd$1@ger.gmane.org> <alpine.DEB.2.02.1404031057430.4261@noise.cbg.collabora.co.uk> <533D89DB.2060306@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39070 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaDCQVg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 3 Apr 2014 12:21:36 -0400
In-Reply-To: <533D89DB.2060306@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Thu, 3 Apr 2014, Francis Moreau wrote:

> On 04/03/2014 12:02 PM, Vivek Dasmohapatra wrote:
>> On Sun, 30 Mar 2014, Francis Moreau wrote:
>>
>> Hi Francis: A quick question for you if you have the time:
>> How is the bcache constructed? ie which devices are in it?
>>
>
> sure: I'm using bcache on a very basic setup: no MD or LVM involved.
> /dev/sda4 (900Mo) is the backing device while /dev/sdb (120G) is the
> cache device. On top of bcache0 I'm using ext4 and I'm using it as my
> root device.

Ok, interesting. I've had some luck tweaking the offset of the backing
device partition: Some offsets trigger the bug consistently and others
never seem to, so it seems to be some sort of weird alignment bug.
