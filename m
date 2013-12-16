From: "Matthew Patton" <pattonme@yahoo.com>
Subject: Re: 2 drives btrfs raid1 with one ssd
Date: Sun, 15 Dec 2013 20:11:45 -0500
Message-ID: <op.w75uxvdkf3gqgg@desktop.patton.net>
References: <1387155717.6876.29.camel@N900-P>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm29-vm1.bullet.mail.ne1.yahoo.com ([98.138.90.63]:49001 "HELO
	nm29-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751908Ab3LPBML (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 Dec 2013 20:12:11 -0500
In-Reply-To: <1387155717.6876.29.camel@N900-P>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, Pavol Cupka <pavol.cupka@gmail.com>

On Sun, 15 Dec 2013 20:01:57 -0500, Pavol Cupka <pavol.cupka@gmail.com>  
wrote:

> I would like to use a bcache for btrfs filesystem residing on two  
> identical disk as raid1 using btrfs' raid (without soft/hard raid).
>
> Is it possible?

if I understood you correctly, no.

> I would like to use the same ssd/ssd partition for caching both  
> drives/mirror. Is this doable?

You will have to build the btrfs 'raid' on top of two bcache devices. If  
the caching device for both devices in the same SSD (partitioned) what's  
the point? Assuming Btrfs has a similar feature set to MD's Raid1  
write-mostly, you could accelerate the one side, and run the other half of  
the mirror without acceleration. Otherwise I would just use MD's Raid1 and  
be done with it. Put btrfs/ext4/xfs on top as you like.

Does your intended workload really benefit from putting an SSD into the  
mix?
