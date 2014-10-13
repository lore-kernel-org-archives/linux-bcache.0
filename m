From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: How to invalidate all cache
Date: Mon, 13 Oct 2014 11:03:51 +0800
Message-ID: <20141013030351.GA12742@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38870 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaJMCx1 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 12 Oct 2014 22:53:27 -0400
Received: by mail-pd0-f172.google.com with SMTP id ft15so4905100pdb.3
        for <linux-bcache@vger.kernel.org>; Sun, 12 Oct 2014 19:53:26 -0700 (PDT)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>

Hi all,

I am trying to do some benchmarks against bcache, espeically in cache
miss scenario, but I don't find a user interface to invalidate all
cache.  Anyone can tell me how to do that.

Thanks in advance,
                                                - Zheng
