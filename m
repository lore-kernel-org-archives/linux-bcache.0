From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [bcachefs] Mounting the same device multiple times now works
Date: Tue, 11 Aug 2015 00:34:53 -0800
Message-ID: <20150811083453.GA29708@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35582 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbbHKIe7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 11 Aug 2015 04:34:59 -0400
Received: by pacgr6 with SMTP id gr6so46086487pac.2
        for <linux-bcache@vger.kernel.org>; Tue, 11 Aug 2015 01:34:59 -0700 (PDT)
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: Ming Lin <mlin@kernel.org>

Like in other filesystems, you can now do

mount /dev/sda1 /foo
mount /dev/sda1 /bar

What this really means is that if the udev hook has registered the bcache device
via the old style sysfs interface for caching, you'll still be able to mount the
device like normal.

Keep the bug reports coming!
