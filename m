From: "Paul B. Henson" <henson@acm.org>
Subject: RE: Another bcache hang
Date: Fri, 22 Nov 2013 11:51:24 -0800
Message-ID: <156301cee7bc$3b7fc420$b27f4c60$@acm.org>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com> <528F6BAD.7080703@warr.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59246 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3KVTv3 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 14:51:29 -0500
Received: by mail-pa0-f43.google.com with SMTP id bj1so1749376pad.30
        for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2013 11:51:29 -0800 (PST)
In-Reply-To: <528F6BAD.7080703@warr.net>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: 'Jason Warr' <jason@warr.net>
Cc: linux-bcache@vger.kernel.org

> From: Jason Warr [mailto:jason@warr.net]
> Sent: Friday, November 22, 2013 6:35 AM
>
> As I start to use more LVM based RAID, and with it fault allocation
> policy's, logically it makes more sense to setup individual volumes as
> backing stores instead of PV's.  That way you always know your caching
> the volumes you want no matter what PV device(s) they are sitting on.

I looked at LVM raid once a while ago, it didn't really seem quite there
yet. I haven't checked recently, do you consider it a better choice than
classic md raid now? It would be one less layer in the stack, but mdraid has
been pretty bulletproof for me for quite some time and I'd be hesitant to
switch.
