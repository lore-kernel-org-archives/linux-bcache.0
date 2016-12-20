From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs-testing] missing inode 6502 (nlink 1) (repair
 unimplemented)
Date: Mon, 19 Dec 2016 17:56:13 -0900
Message-ID: <20161220025613.lm6mzkloodtknwol@moria.home.lan>
References: <850720fc-0d61-1f10-8e2a-39e644fb79e0@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34102 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbcLTC4R (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Dec 2016 21:56:17 -0500
Received: by mail-pf0-f195.google.com with SMTP id y68so8157794pfb.1
        for <linux-bcache@vger.kernel.org>; Mon, 19 Dec 2016 18:56:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <850720fc-0d61-1f10-8e2a-39e644fb79e0@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "marcin@mejor.pl" <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Dec 13, 2016 at 10:29:47AM +0100, marcin@mejor.pl wrote:
> Hi Kent, all!
> 
> Yesterday I was testing bcacefs mounted at /home on desktop. Next I
> hibernated box. Today I resumed OS, upgraded kernel to:
> commit ee9f55a7cd209a821f79c1092b5c53959ab1bc47
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Thu Dec 8 17:28:02 2016 -0900
> 
>     bcache: don't flush journal unnecessarily
> 
> commit 125312566ed797bc0c8b87ae9dbf694a68ddef33
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Mon Dec 12 12:53:56 2016 -0900
> 
>     bcache: short circuit bch_prio_write() and journal flush when possible
> 
> 
> and next I rebooted. Now I can't mount /home because of error (it's not
> problem, I've got backup). Error is:

I _think_ this one is fixed in bcache-dev now - I found some bugs in the
journalling code thanks to Josef Bacik's dm log-writes tool, and the new torture
test isn't finding any new bugs.

Let me know if you see it again, once you grab the latest code.
