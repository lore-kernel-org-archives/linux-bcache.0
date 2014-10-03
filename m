From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: can't attach
Date: Fri, 03 Oct 2014 15:21:27 -0500
Message-ID: <542F0547.3060805@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:17568 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaJCUay (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Oct 2014 16:30:54 -0400
Received: from [134.64.128.215] (unknown [192.65.45.20])
	by greer.hardwarefreak.com (Postfix) with ESMTPA id C81946C0F6
	for <linux-bcache@vger.kernel.org>; Fri,  3 Oct 2014 15:21:09 -0500 (CDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

# ls -la /sys/fs/bcache
total 0
drwxr-xr-x 3 root root    0 Oct  3 14:39 .
drwxr-xr-x 6 root root    0 Oct  2 16:32 ..
drwxr-xr-x 7 root root    0 Oct  3 14:50 8246b830-95d4-420d-aff8-894efc348801
--w------- 1 root root 4096 Oct  3 14:39 register
--w------- 1 root root 4096 Oct  3 14:50 register_quiet


# echo 8246b830-95d4-420d-aff8-894efc348801 > /sys/block/bcache0/bcache/attach
bash: echo: write error: Invalid argument


What's the problem here?

Thanks,
Stan
