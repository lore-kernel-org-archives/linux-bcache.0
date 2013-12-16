From: "Matthew Patton" <pattonme@yahoo.com>
Subject: Re: register_bcache() error opening /dev/md2: bad block/bucket size
Date: Sun, 15 Dec 2013 20:02:38 -0500
Message-ID: <op.w75uiojsf3gqgg@desktop.patton.net>
References: <20131130033736.GF5195@bender.unx.csupomona.edu>
 <000401ceefb5$f0aa6160$d1ff2420$@acm.org> <52AE4BD1.3080001@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from nm16-vm6.bullet.mail.ne1.yahoo.com ([98.138.91.109]:44426 "HELO
	nm16-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751908Ab3LPBDE (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 15 Dec 2013 20:03:04 -0500
In-Reply-To: <52AE4BD1.3080001@wp.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, Jakub Witkowski <skylynx@wp.pl>

On Sun, 15 Dec 2013 19:39:45 -0500, Jakub Witkowski <skylynx@wp.pl> wrote:

> to use larger block but bcache I think I use this. The another problem  
> is that SSD's manufacturers don't release information about some basic  
> info about SSD like page size or nand erase block size

Sometimes they post it in technical papers or will supply on request.  
Regardless, optimization at this stage is a total waste of time, IMO.  
Provision 25-30% spare area on your drive and let it do it's thing. Unless  
you're in the habit of buying el-cheapo, cr*p drives (stay away from  
low-priced consumer) the firmware is smart enough to do the right thing.

If you want consistent speed and reliable drives you MUST spend money and  
get the professional  or high-end gear.
