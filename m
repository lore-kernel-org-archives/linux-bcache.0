From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs bug during file creation and removal
Date: Tue, 15 Nov 2016 08:32:34 -0900
Message-ID: <20161115173234.z4gpy5tojxuillmm@kmo-pixel>
References: <99daab89-f7ba-25cb-f20d-503f171e2699@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34141 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbcKORci (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Nov 2016 12:32:38 -0500
Received: by mail-pf0-f173.google.com with SMTP id c4so25325564pfb.1
        for <linux-bcache@vger.kernel.org>; Tue, 15 Nov 2016 09:32:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <99daab89-f7ba-25cb-f20d-503f171e2699@posteo.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Karl-Philipp Richter <krichter@posteo.de>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Fri, Nov 11, 2016 at 04:52:42PM +0100, Karl-Philipp Richter wrote:
> Hi,
> During creation of an OpenAFS cache on a bcachefs mount (ca. 1 M files
> and directories) I probably got the error

The two errors are unrelated. The first warning is spurious - we fall back to
vmalloc() if kmalloc() fails, so I'll silence that.


>     [   97.560655] ------------[ cut here ]------------
>     [   97.560677] WARNING: CPU: 6 PID: 1802 at
> drivers/md/bcache/fs.c:78 __bch_write_inode+0x2d4/0x2e0 [bcache]

This one was a real bug - took awhile to track down, it was ultimately a bug in
the whiteouts compactaction code, it was using memcpy() when it was using
memmove() (and I couldn't reproduce it because the memcpy() I was getting did
the copy in the direction to make it work). It's fixed though - bcache-dev
should be working (I backed it out last week, after we figured out which commit
it was).

Thanks for the bug reports!
