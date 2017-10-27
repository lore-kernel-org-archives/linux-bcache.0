From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [PATCH v2] bcache: explicitly destroy mutex while exiting
Date: Fri, 27 Oct 2017 19:05:45 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1710271903590.24585@mail.ewheeler.net>
References: <20171010090049.6596-1-liangchen.linux@gmail.com> <01f432e8-950a-fc9f-150d-0b51fa9e7559@coly.li> <c06f2a04-3654-0bb9-f07d-ee6d2b27868d@lyle.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1641074820-1074948329-1509131149=:24585"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:53248 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751610AbdJ0TK6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 15:10:58 -0400
In-Reply-To: <c06f2a04-3654-0bb9-f07d-ee6d2b27868d@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <i@coly.li>, Liang Chen <liangchen.linux@gmail.com>, linux-bcache@vger.kernel.org, kent.overstreet@gmail.com, linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1641074820-1074948329-1509131149=:24585
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 10 Oct 2017, Michael Lyle wrote:

> On 10/10/2017 05:25 AM, Coly Li wrote:
> > On 2017/10/10 下午5:00, Liang Chen wrote:
> >> mutex_destroy does nothing most of time, but it's better to call
> >> it to make the code future proof and it also has some meaning
> >> for like mutex debug.
> >>
> >> As Coly pointed out in a previous review, bcache_exit() may not be
> >> able to handle all the references properly if userspace registers
> >> cache and backing devices right before bch_debug_init runs and
> >> bch_debug_init failes later. So not exposing userspace interface
> >> until everything is ready to avoid that issue.
> >>
> >> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > 
> > Hi Liang,
> > 
> > No more comment from me, it looks good. Thanks.
> > 
> > Reviewed-by: Coly Li <colyli@suse.de>
> 
> Looks good to me too.
> 
> Reviewed-by: Michael Lyle <mlyle@lyle.org>

Should this Cc: stable to avoid the register race (possible 
crash?) described by Liang in other stable kernels?

Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--1641074820-1074948329-1509131149=:24585--
