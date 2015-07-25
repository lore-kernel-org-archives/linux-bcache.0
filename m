From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Upgrade path to bcachefs
Date: Sat, 25 Jul 2015 10:15:41 +0200
Message-ID: <55B345AD.9050204@megasoft.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:48799 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbbGYIUd (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sat, 25 Jul 2015 04:20:33 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 26A4147E4F3
	for <linux-bcache@vger.kernel.org>; Sat, 25 Jul 2015 10:15:45 +0200 (CEST)
Received: from mfilter38-d.gandi.net (mfilter38-d.gandi.net [217.70.178.169])
	by relay2-d.mail.gandi.net (Postfix) with ESMTP id 6595AC5A41
	for <linux-bcache@vger.kernel.org>; Sat, 25 Jul 2015 10:15:43 +0200 (CEST)
Received: from relay2-d.mail.gandi.net ([217.70.183.194])
	by mfilter38-d.gandi.net (mfilter38-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id F4eI3ZiVH8BJ for <linux-bcache@vger.kernel.org>;
	Sat, 25 Jul 2015 10:15:42 +0200 (CEST)
Received: from [172.17.0.70] (cable-213-34-255-70.zeelandnet.nl [213.34.255.70])
	(Authenticated sender: killian.de.volder@megasoft.be)
	by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 005E6C5A40
	for <linux-bcache@vger.kernel.org>; Sat, 25 Jul 2015 10:15:41 +0200 (CEST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I have been wondering:

If I recall correctly: the backing device is just a bunch of bytes right ?
(Excluding the bcache header.)

If the bcachefs header (for the backing device)  isn't bigger then bcache,
one should be able to write a tool to wipe the bcache header.
Could one copy the dev.data.first_sector from the bcache-header and write a new bcachefs-header using this information ?

So the steps could be:
 1) Remove the caching device.
 2) Unmount it (could be tricky in some situation, like the root mount)
 3) Run make-bcachefs --upgrade /dev/xxx
 4) Add your caching device.

-- 
Killian De Volder
