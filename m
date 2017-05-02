From: Nix <nix@esperi.org.uk>
Subject: what happened to the nifty ioprio cache hinting stuff?
Date: Tue, 02 May 2017 11:54:38 +0100
Message-ID: <877f1zil5d.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:50804 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdEBLZD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 May 2017 07:25:03 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Eric Wheeler <bcache@linux.ewheeler.net>

I found the ioprio cache hinting quite exciting (I know, I'm weird):
it won't help with writeback or e.g. NFS, but it will certainly let me
do things like run backups without wearing my SSD out.

This was in ewheeler's for-4.10-block-bcache-updates branch, but it
didn't get into 4.10 or 4.11, even while other commits on the same
branch did :( is it dead? (I mean, it still seems to *apply* to 4.11...)

-- 
NULL && (void)
