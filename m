From: Donald Pearson <donaldwhpearson@gmail.com>
Subject: attching with multiple backing devices
Date: Fri, 3 Jul 2015 16:02:23 -0500
Message-ID: <CAC=t97D_Yr0Ya2qu=sGk89JaODtz9K4QiQcCF8G2PX=Y+0zeYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33167 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbbGCVCm (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 3 Jul 2015 17:02:42 -0400
Received: by obpn3 with SMTP id n3so75131983obp.0
        for <linux-bcache@vger.kernel.org>; Fri, 03 Jul 2015 14:02:42 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

The example information I've been able to find isn't clear on proper
implementation with multiple backing devices.  The following is an
exerpt from the documentation.  I have 12 backing devices (bcache0 -
bcache11).. do I run this just once against any one of the 12, one of
the 12 in particular, or do I run this 12 times, once for each of the
12 backing devices that I want cached?

ATTACHING:

After your cache device and backing device are registered, the backing device
must be attached to your cache set to enable caching. Attaching a backing
device to a cache set is done thusly, with the UUID of the cache set in
/sys/fs/bcache:

  echo <UUID> > /sys/block/bcache0/bcache/attach

Regards,
Donald
