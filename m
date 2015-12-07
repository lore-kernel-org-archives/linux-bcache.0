From: "Yannis Aribaud" <bugs@d6bell.net>
Subject: Re: bcache_gc: BUG: soft lockup
Date: Mon, 07 Dec 2015 10:35:52 +0000
Message-ID: <c5d6be2727642ec01b53cd8d28c962bf@rcube.hebserv.net>
References: <06d43fd0101a31a3a3bd4896ba50e4cc@rcube.hebserv.net>
 <20151130070743.11343yqeihgbzfsv@imap.suse.de>
 <1448626993.2877.112.camel@suse.de>
 <2f979d1d6e991272cebc8ff40a955c8a@rcube.hebserv.net>
 <1447419912.2616.19.camel@suse.de> <1447418245.2616.15.camel@suse.de>
 <648d9a0567372b10a3861eee8320328c@rcube.hebserv.net>
 <7d53afb3c7a34bb1022f0d9b6c079022@rcube.hebserv.net>
 <9c96132d5fce4a5a77b1b086f7c6095d@rcube.hebserv.net>
 <594053ea9538352f4f3e01b954c6080d@rcube.hebserv.net>
 <alpine.LRH.2.11.1511291738340.5445@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from dbmail.hebserv.net ([78.40.121.80]:34120 "EHLO
	dbmail.hebserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbbLGKfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 7 Dec 2015 05:35:55 -0500
In-Reply-To: <06d43fd0101a31a3a3bd4896ba50e4cc@rcube.hebserv.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Yannis Aribaud <bugs@d6bell.net>, Johannes Thumshirn <jthumshirn@suse.de>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Hi everyone,

It's been one week I'm using a 4.2.6 kernel merged with the Bcache patches from Ewheeler and no signs of any kind of trouble I had before.
Thus it seems your patches fix my soft lockup issue.
It's currently running on one of my ceph nodes, I will certainly push it on the others during the next weeks.

It would be great to merge thoses patches upstream since it seems that using Bcache in production requires those fixes.

Anyway, thanks to all of you for your time, advices and work on Bcache. I'll keep you updated.

Regards,
-- 
Open is better
