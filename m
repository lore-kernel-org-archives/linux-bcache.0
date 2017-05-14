From: Marc MERLIN <marc@merlins.org>
Subject: make-bcache bug?
Date: Sun, 14 May 2017 10:58:40 -0700
Message-ID: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33110 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754693AbdENSHu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2017 14:07:50 -0400
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

bcache-tools (1.0.8-2+b1)

gargamel:~# make-bcache  -C /dev/sde2
Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
gargamel:~# make-bcache  --wipe-bcache -C /dev/sde2 
Device /dev/sde2 already has a non-bcache superblock, remove it using wipefs and wipefs -a

/dev/sde2 is an old bcache I'm reformatting.
The first message is correct
The 2nd one is not "/dev/sde2 already has a non-bcache superblock"

Clearly it can't have a bcache and not a bcache superblock, right?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
