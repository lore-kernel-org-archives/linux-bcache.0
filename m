From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: size limit for backing store? block sizes? ("[sdx] Bad block
 number requested")
Date: Thu, 9 Feb 2017 12:43:21 -0900
Message-ID: <20170209214321.l5lkpqzi52zo3ezm@moria.home.lan>
References: <20170207133558.Horde.vMEQ46joRTaI1D7afBcEmGv@www3.nde.ag>
 <20170207205855.3d9c0985@jupiter.sol.kaishome.de>
 <20170208002843.Horde.s0-rn8GSuWk8FVkt60OB6Yb@www3.nde.ag>
 <20170208005732.207098f6@jupiter.sol.kaishome.de>
 <alpine.LRH.2.11.1702091335000.5783@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35089 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752309AbdBIVyG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Feb 2017 16:54:06 -0500
Received: by mail-pf0-f175.google.com with SMTP id 202so310896pfx.2
        for <linux-bcache@vger.kernel.org>; Thu, 09 Feb 2017 13:52:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1702091335000.5783@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org, Kai Krakow <hurikhan77@gmail.com>

On Thu, Feb 09, 2017 at 01:37:46PM -0800, Eric Wheeler wrote:
> Maybe --block 4096 should be default in make-bcache?
> 
> Kent, is there any reason this wouldn't be a good idea?

That'd break things for people who expect sub 4k DIO to work (and if your
devices all have 512 byte sectors, that's a perfectly reasonable thing to
expect).

Unfortunately, there's no easy solution here.
