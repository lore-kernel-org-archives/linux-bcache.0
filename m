From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcachefs: can bcachefs export block devices?
Date: Wed, 3 Aug 2016 22:04:05 -0800
Message-ID: <20160804060405.GA8042@kmo-pixel>
References: <alpine.LRH.2.11.1605251440480.24690@mx.ewheeler.net>
 <20160525225113.GA20180@kmo-pixel>
 <alpine.LRH.2.11.1608031727480.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36110 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbcHDGLj (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 4 Aug 2016 02:11:39 -0400
Received: by mail-pa0-f41.google.com with SMTP id pp5so80438132pac.3
        for <linux-bcache@vger.kernel.org>; Wed, 03 Aug 2016 23:09:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1608031727480.10662@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

On Wed, Aug 03, 2016 at 05:30:02PM -0700, Eric Wheeler wrote:
> Hey Kent,
> 
> I noticed that blockdev.c got an overhaul in bcache-dev recently.  Getting 
> closer to blockdev export from bcachefs?

No, not really. I've actually hardly touched that stuff - to the extent that I
have I've just been fixing a few random bugs here and there to get the old style
bcache functionality closer to working again.

> Actually it looks like you've been pretty busy on that branch in general.  
> 
> What's new?  

Oh, random stuff. I've been posting some on patreon lately:
https://www.patreon.com/bcachefs

(And yes, I do need money if anyone would be willing to chip in).

The main user visible thing is compression is finally useful - I finally
finished the disk accounting stuff so that enabling compression actually lets
you store more data on a fs.

Besides that, it's mainly been bug fixing and internal refactoring working
towards snapshots. I'm gonna write something up about the plan for snapshots
soon.
