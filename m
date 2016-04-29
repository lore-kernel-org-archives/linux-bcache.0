From: ching lu <lsching17@gmail.com>
Subject: scrub backing device
Date: Fri, 29 Apr 2016 10:13:42 +0800
Message-ID: <CACHiF8Bm9i=m-nCVv2MnSFVDcgmnOzSytzYo0gzjkfp0u8Y52A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36740 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbcD2CNn (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 28 Apr 2016 22:13:43 -0400
Received: by mail-oi0-f54.google.com with SMTP id x201so104465539oif.3
        for <linux-bcache@vger.kernel.org>; Thu, 28 Apr 2016 19:13:43 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,

i want to develop a script to perform data scrubbing periodically.

For my use case, i think it is meaningless to scrub cached data.

If i change the cache mode to "none", will it turn off the read cache too?

Furthermore, will this invalidate cached data? (i do not want to "warm
up" the cache again after the scrubbing)

Thanks in advance,
c
