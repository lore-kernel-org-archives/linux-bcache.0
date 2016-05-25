From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: bcachefs: can bcachefs export block devices?
Date: Wed, 25 May 2016 14:47:29 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1605251440480.24690@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:60823 "EHLO mx.ewheeler.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbcEYVrQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Wed, 25 May 2016 17:47:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 31040A0F4B
	for <linux-bcache@vger.kernel.org>; Wed, 25 May 2016 14:47:30 -0700 (PDT)
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JJ-0StTlTTmX for <linux-bcache@vger.kernel.org>;
	Wed, 25 May 2016 14:47:29 -0700 (PDT)
Received: from 23-95-35-21-host.colocrossing.com (unknown [23.95.35.21])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id C8E77A0F4A
	for <linux-bcache@vger.kernel.org>; Wed, 25 May 2016 14:47:29 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org


I have a few bcachefs questions that pertain to its use with block 
devices.  

Does bcachefs's implementation reuse and update the existing 
bcache code such that the block device driver inherits the bcachefs 
improvements?  I understand the cache superblock changed, maybe the cached 
dev super too.

Can bcachefs provide /dev/bcacheN devices without loop.ko?  

If so, are these simply filesystem objects (files)?


--
Eric Wheeler
