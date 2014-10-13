From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: How to invalidate all cache
Date: Mon, 13 Oct 2014 21:30:58 +0800
Message-ID: <20141013133058.GA19065@gmail.com>
References: <20141013030351.GA12742@gmail.com>
 <CACHGV4Jn3ML=2PO9FtoT4OXZCtpt56bOb=TmnVanv7Tm2MJyDg@mail.gmail.com>
 <20141013034536.GA13155@gmail.com>
 <178936476.20141013104314@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62665 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbaJMNUd (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 13 Oct 2014 09:20:33 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so5881577pab.32
        for <linux-bcache@vger.kernel.org>; Mon, 13 Oct 2014 06:20:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <178936476.20141013104314@pvgoran.name>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pavel Goran <via-bcache@pvgoran.name>
Cc: linux-bcache@vger.kernel.org

On Mon, Oct 13, 2014 at 10:43:14AM +0700, Pavel Goran wrote:
> Hello Zheng,
> 
> Monday, October 13, 2014, 10:45:37 AM, you wrote:
> 
> > Yes, detaching a backing device will make all dirty data to be written
> > back to the backing device.  But if I understand correctly it couldn't
> > invalidate all data in cache device.  That means that after attaching
> > backing device the data in cache device is still valid.
> 
> It  would  be  a  bug if cached data were considered valid after detaching and
> re-attaching. Because while a cache device an a backing device were separated,
> data  could be written to a backing device, this would possibly make data in a
> "disconnected" cache obsolete.

Ah, Thanks for pointing it out.  I got it.

BTW, there is a bug when I tried to detach/attach a backing device.
A patch has sent out to the mailing list.  That would be great if some
one can review it.

Regards,
                                                - Zheng
