From: "Paul B. Henson" <henson@acm.org>
Subject: RE: Another bcache hang
Date: Fri, 22 Nov 2013 15:52:27 -0800
Message-ID: <001b01cee7dd$e82f5d90$b88e18b0$@acm.org>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com> <528F6BAD.7080703@warr.net> <156301cee7bc$3b7fc420$b27f4c60$@acm.org> <528FBFCE.7020104@warr.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59560 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3KVXwc (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 18:52:32 -0500
Received: by mail-pa0-f46.google.com with SMTP id kl14so1985605pab.19
        for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2013 15:52:32 -0800 (PST)
In-Reply-To: <528FBFCE.7020104@warr.net>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: 'Jason Warr' <jason@warr.net>
Cc: linux-bcache@vger.kernel.org

> From: Jason Warr [mailto:jason@warr.net]
> Sent: Friday, November 22, 2013 12:34 PM
>
> I would say it is going to be a better choice for use cases that are
> more dynamic in nature.  By that I mean where you may have a larger
> number of smaller volumes that may have different needs for redundancy
> and/or where you may be adding or removing physical devices often.

Ah, that's true; using raid at the lvm layer allows you to selectively
choose redundancy as opposed to dropping the entire pv on top of an mdraid.

> There are lots of good options that are becoming more viable now that we
> have a real in kernel caching device to mask out allot of previous
> performance concerns.

Continuing to veer off-topic ;), what kernel version are you currently using
with bcache? I was originally thinking of going 3.10LTS, but ended up
installing 3.11 based on the mailing list traffic.
