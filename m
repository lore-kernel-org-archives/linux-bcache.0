From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: bcache_gc: BUG: soft lockup
Date: Fri, 13 Nov 2015 12:09:24 +0000
Message-ID: <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:33058 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbbKMMTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 13 Nov 2015 07:19:15 -0500
Received: from rcube.hebserv.net (unknown [IPv6:2a02:4b8:105::10])
	by dbmail.hebserv.net (Postfix) with ESMTPSA id 8DC58167B7
	for <linux-bcache@vger.kernel.org>; Fri, 13 Nov 2015 13:09:26 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I recently tried bcache on a vanilla 4.1.12 kernel and got those strange soft lockup issues.
This happens at the system shutdown only but not every time, thus I suppose that it's related to bcache devices stopping.

My setup use 3 bcache devices each using dedicated hardware devices (1 HDD and 1 SSD), cache_mode is writeback and bucket/block sizes are the default ones.

I saw that a similar problem was solved in 3.17 so maybe it's a regression.

Any idea how to fix that ?

Regards,
-- 
Open is better
