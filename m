From: Vlad <vovan@vovan.nl>
Subject: Adding net cache device to existing bcache
Date: Wed, 18 Dec 2013 19:17:28 +0100
Message-ID: <52B1E6B8.3080103@net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from 77-175-29-125.FTTH.ispfabriek.nl ([77.175.29.125]:42549 "EHLO
	srv2.net.home" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752203Ab3LRSR3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 18 Dec 2013 13:17:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by srv2.net.home (Postfix) with ESMTP id 8CE4920A64D
	for <linux-bcache@vger.kernel.org>; Wed, 18 Dec 2013 19:17:28 +0100 (CET)
Received: from srv2.net.home ([127.0.0.1])
	by localhost (webmail.net.home [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id bb_SIYsarXHv for <linux-bcache@vger.kernel.org>;
	Wed, 18 Dec 2013 19:17:28 +0100 (CET)
Received: from [192.168.1.2] (vovan.net.home [192.168.1.2])
	(Authenticated sender: vovan)
	by srv2.net.home (Postfix) with ESMTPSA id 477D920A647
	for <linux-bcache@vger.kernel.org>; Wed, 18 Dec 2013 19:17:28 +0100 (CET)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I'm trying to add new cache device to an existing bcache, but
unsuccessfully... I thought it should as simple as formating the new
cache device (make-bcache) and then attaching it to an existing bcache
device. However, this procedure won't work.
Is there any useful howto or another info about this subject.

Regards,
Vlad.
