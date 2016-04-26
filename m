From: ching lu <lsching17@gmail.com>
Subject: writeback mode behaviour on proper shut down
Date: Tue, 26 Apr 2016 17:26:38 +0800
Message-ID: <CACHiF8AEZ0Ppoa9mzou76o8j5UC-gXyjt25EDvnqq9S-Kk0B8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34797 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcDZJ0j (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 26 Apr 2016 05:26:39 -0400
Received: by mail-oi0-f52.google.com with SMTP id k142so8809932oib.1
        for <linux-bcache@vger.kernel.org>; Tue, 26 Apr 2016 02:26:39 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all,

if i have 1 SSD caching 1 HDD using bcache, the cache mode is writeback

if the PC shutdown/unmount normally, will all dirty data in the cache
be flushed to backing device before poweroff?

i am afraid that SSD lose data if left without power for a long time.
e.g. hoilday.

Thanks in advance,
C
