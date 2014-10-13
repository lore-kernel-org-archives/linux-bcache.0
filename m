From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: How to invalidate all cache
Date: Mon, 13 Oct 2014 11:45:37 +0800
Message-ID: <20141013034536.GA13155@gmail.com>
References: <20141013030351.GA12742@gmail.com>
 <CACHGV4Jn3ML=2PO9FtoT4OXZCtpt56bOb=TmnVanv7Tm2MJyDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60785 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaJMDfL (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 12 Oct 2014 23:35:11 -0400
Received: by mail-pa0-f51.google.com with SMTP id lj1so5062440pab.24
        for <linux-bcache@vger.kernel.org>; Sun, 12 Oct 2014 20:35:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CACHGV4Jn3ML=2PO9FtoT4OXZCtpt56bOb=TmnVanv7Tm2MJyDg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: linux-bcache@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>

Hi Slava,

Thanks for your reply.

On Sun, Oct 12, 2014 at 08:16:31PM -0700, Slava Pestov wrote:
> You can try to detach the backing device, which will cause all dirty
> data to be written back, and attach it again.

Yes, detaching a backing device will make all dirty data to be written
back to the backing device.  But if I understand correctly it couldn't
invalidate all data in cache device.  That means that after attaching
backing device the data in cache device is still valid.  All I want to
do is to remove all data in cache device.  Any idea?

Regards,
                                                - Zheng

> 
> On Sun, Oct 12, 2014 at 8:03 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > Hi all,
> >
> > I am trying to do some benchmarks against bcache, espeically in cache
> > miss scenario, but I don't find a user interface to invalidate all
> > cache.  Anyone can tell me how to do that.
> >
> > Thanks in advance,
> >                                                 - Zheng
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
