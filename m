From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Bcachefs testing needed
Date: Sat, 5 Nov 2016 08:05:02 -0800
Message-ID: <20161105160502.5bknr5ufufzdyn3i@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36418 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbcKEQFG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 5 Nov 2016 12:05:06 -0400
Received: by mail-pf0-f174.google.com with SMTP id 189so68548716pfz.3
        for <linux-bcache@vger.kernel.org>; Sat, 05 Nov 2016 09:05:06 -0700 (PDT)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org, chris@cooperteam.net, marcin@mejor.pl

Chris, Marcin, anyone else who wants to help out - the bcachefs-testing branch
needs testing before I merge in those patches.

Chris was seeing filesystem corruption with the foreground btree merging
patches, and I still haven't figured out what that was (although I have fixed
some possible culprits), so please don't run this on anything with real data
until it's seen some more testing. This branch also doesn't have btree node
merging yet - it's got the btree locking changes, and some new work making
iterators more rigorous and tightening up invariants. Once we're sure that stuff
is all good I'll push out btree node merging again.

And I definitely could use more testers - testing is getting to be a significant
bottleneck these days.
