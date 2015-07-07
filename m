From: Denis Bychkov <manover@gmail.com>
Subject: Re: attching with multiple backing devices
Date: Tue, 7 Jul 2015 15:03:59 -0400
Message-ID: <CAO2mnoyaZrqb0SKXPeE_Lz9Ont-5yWHpbjPf_q+4RnO0DGiULQ@mail.gmail.com>
References: <CAC=t97D_Yr0Ya2qu=sGk89JaODtz9K4QiQcCF8G2PX=Y+0zeYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:32830 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933656AbbGGTD7 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 7 Jul 2015 15:03:59 -0400
Received: by oiyy130 with SMTP id y130so149050516oiy.0
        for <linux-bcache@vger.kernel.org>; Tue, 07 Jul 2015 12:03:59 -0700 (PDT)
In-Reply-To: <CAC=t97D_Yr0Ya2qu=sGk89JaODtz9K4QiQcCF8G2PX=Y+0zeYQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: linux-bcache@vger.kernel.org

Hi,

By running this command you tell bcache you want the backing device
associated with a particular cache set (currently only one cache set
is
supported, but nevermind), so yes, you run it 12 times feeding it 12
different UUIDs. Until you register a backing device, it won't be
associated with any cache set, so despite being perfectly accessible
it will be working in a pass-through mode.

On Fri, Jul 3, 2015 at 5:02 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:
> The example information I've been able to find isn't clear on proper
> implementation with multiple backing devices.  The following is an
> exerpt from the documentation.  I have 12 backing devices (bcache0 -
> bcache11).. do I run this just once against any one of the 12, one of
> the 12 in particular, or do I run this 12 times, once for each of the
> 12 backing devices that I want cached?
>
> ATTACHING:
>
> After your cache device and backing device are registered, the backing device
> must be attached to your cache set to enable caching. Attaching a backing
> device to a cache set is done thusly, with the UUID of the cache set in
> /sys/fs/bcache:
>
>   echo <UUID> > /sys/block/bcache0/bcache/attach
>
> Regards,
> Donald
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

Denis
