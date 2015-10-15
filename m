From: Simon Herter <sim.herter@gmail.com>
Subject: Btrfs on bcache device: mount options?
Date: Thu, 15 Oct 2015 15:04:35 +0200
Message-ID: <87mvvk4718.fsf@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49862 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbJONEg (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 15 Oct 2015 09:04:36 -0400
Received: from simon-t420 ([85.212.23.189]) by mrelayeu.kundenserver.de
 (mreue005) with ESMTPSA (Nemesis) id 0Lgt3C-1aOVGO1nvi-00oIjM for
 <linux-bcache@vger.kernel.org>; Thu, 15 Oct 2015 15:04:34 +0200
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I'm using btrfs on a bcache device and I'm a bit confused about mount
options. For example, bcache may (if I understood correctly) bypass the
cache completely for sequential access. So should I use "ssd" mount
option or not? Are there any general recommendations?

Thanks
-Simon
