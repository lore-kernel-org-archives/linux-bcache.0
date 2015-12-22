From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: dynamically resizing bcache devices
Date: Tue, 22 Dec 2015 12:40:44 +0100
Message-ID: <20151222124044.Horde.yBZenQERTNZN7P0HR3WeoI_@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:58158 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbbLVLkr (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Dec 2015 06:40:47 -0500
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.15 AUTH)
	with ESMTPA id n04c45rBMBeiNeA
	for <linux-bcache@vger.kernel.org>;
	Tue, 22 Dec 2015 12:40:44 +0100 (CET)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id 66CAC1C05C
	for <linux-bcache@vger.kernel.org>; Tue, 22 Dec 2015 12:40:44 +0100 (CET)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

an earlier, similar question went by unanswered, so let me give it  
another try:

I have set up a bcache device on top of DMRAID devices for cache and  
backing device.

While I can dynamically resize both RAIDs, the bcache device will not  
catch up with the changes "live". This conforms to what Kent wrote in  
2012 (http://comments.gmane.org/gmane.linux.kernel.bcache.devel/249):

--- cut here ---
For the backing device, I think things will just work - you'll just
have to close and reopen the backing device in order for bcache to
notice the new size. Bcache's superblock doesn't remember the size, it
just goes off of what the size of the backing device is when it's
registered.

There's currently no way to make bcache notice the backing device has
grown to do it at runtime, though that ought to be fairly simple too.
--- cut here ---

If this currently is still not implemented, has anyone started to work  
on some "resizebcache" tool, if only handling the backing device?

Regards,
Jens
