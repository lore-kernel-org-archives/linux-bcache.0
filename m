From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Hang in bcache/qemu
Date: Thu, 19 Jan 2017 04:42:44 -0900
Message-ID: <20170119134244.f6bydzrfsghq57ll@moria.home.lan>
References: <2059985.veGUll5WnS@j-t460p>
 <20170118043556.08485efe@jupiter.sol.kaishome.de>
 <20170118084830.GA3690@tuebingen.mpg.de>
 <4700072.elc5RSLsh5@j-t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36828 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbdASQiO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 19 Jan 2017 11:38:14 -0500
Received: by mail-pf0-f170.google.com with SMTP id 189so14744321pfu.3
        for <linux-bcache@vger.kernel.org>; Thu, 19 Jan 2017 08:38:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4700072.elc5RSLsh5@j-t460p>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Jan Wiele <jan@wiele.org>
Cc: linux-bcache@vger.kernel.org

On Thu, Jan 19, 2017 at 01:22:47PM +0100, Jan Wiele wrote:
> Am Mittwoch, 18. Januar 2017, 09:48:30 CET schrieb Andre Noll:
> > On Wed, Jan 18, 04:35, Kai Krakow wrote
> > 
> > FWIW, I'm seeing this as well on different hardware, and with both
> > deadline and CFQ, so it's not a scheduler issue. The problem seems to
> > be the bcache writeback thread calling down_write(&dc->writeback_lock)
> > while already holding this lock.
> Yes, the bug doesn't get triggered when the caching mechanism is set to 
> writethrough.

Is there something else blocked that's holding writeback_lock?
