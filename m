From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: bcache and LVM
Date: Tue, 09 Feb 2016 17:35:05 +0100
Message-ID: <20160209173505.Horde.i-16xdMRyqKAwPrC1ApgY6r@www3.nde.ag>
References: <87k2mgo2rz.fsf@vostro.rath.org>
 <20160208144419.Horde.Ci1_2KcBCEnOa-WxsDN90oU@www3.nde.ag>
 <87r3gmrhbn.fsf@thinkpad.rath.org>
 <20160209114452.Horde.0AlUHBhWkB7dDF8j0jmv3SL@www3.nde.ag>
 <87si11euti.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:39322 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbcBIQfJ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 9 Feb 2016 11:35:09 -0500
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.17 AUTH)
	with ESMTPA id e01a47s19GZ6R6y
	for <linux-bcache@vger.kernel.org>;
	Tue, 9 Feb 2016 17:35:06 +0100 (CET)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id 1085D1C068
	for <linux-bcache@vger.kernel.org>; Tue,  9 Feb 2016 17:35:05 +0100 (CET)
In-Reply-To: <87si11euti.fsf@vostro.rath.org>
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi Nikolas,

Zitat von Nikolaus Rath <Nikolaus@rath.org>:
> [...]
> Indeed. But it's also yet another slightly worrying tidbit (maybe LVM is
> not considering it by default for a good reason).

Agreed, but from what I read, newer versions of LVM were said to  
support bcache devices out of the box  
(https://www.redhat.com/archives/linux-lvm/2012-March/msg00007.html).

> Also, just now someone on -btrfs advised:
>
> | > Otherwise I'll give bcache a shot. I've avoided it so far because of the
> | > need to reformat and because of rumours that it doesn't work well with
> | > LVM or BTRFS. But it sounds as if that's not the case..
> |
> | It should work fine with _just_ BTRFS, but don't put any other layers
> | into the storage system like LVM or dmcrypt or mdraid, it's got some
> | pretty pathological interactions with the device mapper and md
> | frameworks still.

It might be that this is a bit oldish info. BTW, I read that BTRFS on  
LVM is bad and causes problems ;)

We run MD-RAID (R6 for HDDs, R1 for SSDs) beneath bcache. We've run  
thousands of Gigabytes of read and write traffic through this,  
successfully. (And of course - YMMV :-/ ). We've used SATA disks  
(RAID-compatible WD Red) & SSDs (when not running via Supermicro's  
servers with SAS Extender chassis) and SAS disks & SSDs (on those  
servers with SAS extender), all fine.

 From my point of view, bcache with latest bug fixes is a helpful and  
(operationally) stable solution.

Regards,
Jens
