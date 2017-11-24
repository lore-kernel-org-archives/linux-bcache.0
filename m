From: Michael Lyle <mlyle@lyle.org>
Subject: Commits for 4.15-- bcache
Date: Fri, 24 Nov 2017 15:14:23 -0800
Message-ID: <20171124231427.9563-1-mlyle@lyle.org>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pl0-f52.google.com ([209.85.160.52]:37482 "EHLO
        mail-pl0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753772AbdKXXOj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 18:14:39 -0500
Received: by mail-pl0-f52.google.com with SMTP id 61so5114819plf.4
        for <linux-bcache@vger.kernel.org>; Fri, 24 Nov 2017 15:14:39 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk

Hi Jens,

We have a few more small things:

Huacai Chen (1):
      bcache: Fix building error on MIPS

Michael Lyle (1):
      bcache: check return value of register_shrinker

Rui Hua (1):
      bcache: recover data from backing when data is clean

Tang Junhui (1):
      bcache: add a comment in journal bucket reading

Most important is Rui Hua's change, which prevents EINTR from being
returned to users unexpectedly (and is cc'd stable).  All changes are
reviewed and have had a moderate degree of test.

Thanks,

Mike
