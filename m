From: "Paul B. Henson" <henson@acm.org>
Subject: RE: Another bcache hang
Date: Fri, 22 Nov 2013 11:46:56 -0800
Message-ID: <155b01cee7bb$9befd5d0$d3cf8170$@acm.org>
References: <20131121135604.GA26424@professorx.home.zettazebra.com> <14da01cee71f$28d233f0$7a769bd0$@acm.org> <20131122034919.GA25040@professorx.home.zettazebra.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39748 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3KVTrB (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 22 Nov 2013 14:47:01 -0500
Received: by mail-pa0-f49.google.com with SMTP id kx10so1729529pab.8
        for <linux-bcache@vger.kernel.org>; Fri, 22 Nov 2013 11:47:01 -0800 (PST)
In-Reply-To: <20131122034919.GA25040@professorx.home.zettazebra.com>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "'David H. Rhodes Clymer'" <david@zettazebra.com>
Cc: linux-bcache@vger.kernel.org

> From: David H. Rhodes Clymer [mailto:david@zettazebra.com]
> Sent: Thursday, November 21, 2013 7:49 PM
>
> Laziness, mostly. The RAID1 array is a PV that houses filesystems we'd
> rather thot lose. The development databases are not so critical - we
> rebuild them at least once a week anyway. The use of LVs was a quick
> and easy way to test various caching implementations without increasing
> the risk of data loss or corruption in the rest of the system.

Ah, okay, I get it; you had a pre-existing PV with production stuff on it
you didn't want to lose and were just testing out bcache, makes sense.

I haven't seen any responses to your hang report though :(, while obviously
there's no expectation of support, it's always nice if you're going to drop
something into production to have a forum where the experts give you a hand
when things blow chunks.
