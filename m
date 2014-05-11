From: Zhe Yang <yangzhe1990@gmail.com>
Subject: bcache: btree_split() couldn't split
Date: Mon, 12 May 2014 00:52:00 +0800
Message-ID: <CANvbpLSjsFqS-Mt_OmVz2ALP9b-0pwzhh1k5yehz01W8Hj7=bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34844 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaEKQwD (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 11 May 2014 12:52:03 -0400
Received: by mail-lb0-f169.google.com with SMTP id s7so6925760lbd.0
        for <linux-bcache@vger.kernel.org>; Sun, 11 May 2014 09:52:00 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

I'm a bcache user. During use of bcache, I hit this situation very
often. Every time after this, filesystem upon bcache's device was
automatically remounted ro and need a fsck.

I'm using archlinux with stocking 3.13.5 ~ 3.14.1 kernel. Is there any
way to prevent hitting this situation?

BTW, I'd also like to propose a feature related to performance. Bcache
use LRU by default. So every data MISS will write bcache. But SSD
drive can't run normally at writing 20MB/s all the time. Some SSD will
have up to 50ms delay for each write under this kind of stress. Thus,
the overall performance of bcache degrades to HDD, just because of the
write of MISSed data. Could you implement a ratio, for example only
50% MISSed data could be written to SSD?

Sincerely,
    Zhe Yang
