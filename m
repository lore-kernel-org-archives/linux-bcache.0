From: Marc MERLIN <marc@merlins.org>
Subject: Bcache confirmed unsafe with 4.14.0? 4.14.1?
Date: Thu, 23 Nov 2017 23:41:12 -0800
Message-ID: <20171124074112.7x7nnnqabrc3werm@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43107 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbdKXHlQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Nov 2017 02:41:16 -0500
Received: from svh-gw.merlins.org ([173.11.111.145]:51294 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1eI8bp-00014z-Hy
        for <linux-bcache@vger.kernel.org>; Thu, 23 Nov 2017 23:41:16 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1eI8bo-0008Nq-Mr
        for linux-bcache@vger.kernel.org; Thu, 23 Nov 2017 23:41:12 -0800
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I have bcache | dmcrypt | btrfs, and I was upgrading to 4.14.0 when
someone told me about the corruption problems people noticed in 4.14.0

Is there an understood root cause and something to avoid to not trigger
the bug, or not so much?

I saw a bunch of patches go by and I'm not too clear if 4.14.1 is safe,
or not.

Can someone advise?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
