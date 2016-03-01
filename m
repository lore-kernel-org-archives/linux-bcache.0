From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PULL] bcache fixes for v4.5-rc6
Date: Tue, 1 Mar 2016 01:08:32 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1602292216450.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:48217 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750832AbcCABIe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 29 Feb 2016 20:08:34 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: axboe@kernel.dk
Cc: Marc MERLIN <marc@merlins.org>, linux-bcache@vger.kernel.org, Zhu Yanhai <zhu.yanhai@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Nelles <evilazrael@evilazrael.de>

Hi Jens,

Can we still get these in for 4.5?  One is a race, the other is just error 
handling.

Please pull:
  git pull https://bitbucket.org/ewheelerinc/linux.git v4.5-rc6-bcache-fixes 

bcache: fix race of writeback thread starting before complete initialization
bcache: cleaned up error handling around register_cache()


# git diff --stat HEAD~2
 drivers/md/bcache/super.c | 44 
++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

-Eric


--
Eric Wheeler, President           eWheeler, Inc. dba Global Linux Security
888-LINUX26 (888-546-8926)        Fax: 503-716-3878           PO Box 25107
www.GlobalLinuxSecurity.pro       Linux since 1996!     Portland, OR 97298
