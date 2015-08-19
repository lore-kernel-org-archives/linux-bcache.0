From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: writeback minimum rate
Date: Wed, 19 Aug 2015 11:43:51 +0200
Message-ID: <20150819114351.Horde.d5Yn5tRURFeroTYdYbeQcse@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:55041 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbbHSJoA (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 19 Aug 2015 05:44:00 -0400
Received: from hh2-mail.hh.nde.ag (gw-hh2.hh.nde.ag [85.183.17.20])
	by post.strato.de (RZmta 37.9 AUTH)
	with ESMTPA id a04a02r7J9hvguz
	for <linux-bcache@vger.kernel.org>;
	Wed, 19 Aug 2015 11:43:57 +0200 (CEST)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.102.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by hh2-mail.hh.nde.ag (Postfix) with ESMTPS id 5BC841C05C
	for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2015 11:43:50 +0200 (CEST)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi *,

from looking at /sys/block/*/bcache/writeback_rate_debug, it seems  
there's a minimum writeback rate of "512".

Is there a configuration option to increase that value? Changes to  
writeback_rate get overwritten by bcache's algorithm.

I'd like to influence the hysteresis boundaries - our backend can take  
much more write action, especially at night. I don't want a "quick and  
full write-back", though.

Regards,
Jens
