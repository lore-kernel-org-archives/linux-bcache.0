From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: dynamically resizing the backend storage
Date: Wed, 19 Aug 2015 12:00:29 +0200
Message-ID: <20150819120029.Horde.hD2_b5ZxN3Ic3ehPGRzlkqo@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:8266 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbbHSKAh (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 19 Aug 2015 06:00:37 -0400
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.9 AUTH)
	with ESMTPA id Q05089r7JA0ZkYv
	for <linux-bcache@vger.kernel.org>;
	Wed, 19 Aug 2015 12:00:35 +0200 (CEST)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id CAA3A1C05C
	for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2015 12:00:27 +0200 (CEST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi *,

while testing bcache some weeks ago on kernel 3.12, I noticed that  
resizing the back-end storage did not reflect immediately in the  
bcache device:

- RAID6 backend
- RAID1 cache device
- bcache0 from these two

I added another disk to the RAID6 array, but the size of bcache0 only  
adjusted after a reboot.

Is this expected behavior, and has this probably changed in a more  
current bcache implementation? Would I have had to issue some specific  
call to cause a "live update" within bcache?

This is about using bcache to speed up NAS/SAN storage, and having to  
reboot the server to reflect a change in the back-end RAID would be  
somewhat... impractical ;)

Regards,
Jens
