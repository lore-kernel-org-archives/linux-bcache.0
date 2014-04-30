From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Wed, 30 Apr 2014 13:51:14 +0200
Message-ID: <CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
References: <20140411002636.GB9176@birch.djwong.org> <20140411004649.GA4817@kmo>
 <20140411014135.GA18933@birch.djwong.org> <20140412023101.GC9176@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45683 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbaD3Lvz (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 30 Apr 2014 07:51:55 -0400
Received: by mail-ob0-f173.google.com with SMTP id wn1so1802067obc.4
        for <linux-bcache@vger.kernel.org>; Wed, 30 Apr 2014 04:51:54 -0700 (PDT)
In-Reply-To: <20140412023101.GC9176@birch.djwong.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Sam Fulcomer <enotty@brown.edu>, Francis Moreau <francis.moro@gmail.com>, Daniel J Blueman <daniel@quora.org>, linux-bcache@vger.kernel.org

Hi :)

What's the state of this?

I have this issue on a number of EC2 instances that are using bcache
to speed up EBS access by caching on the ephemeral SSDs (writethrough
mode).

"echo 0 > /sys/block/bcache0/bcache/writeback_running" as suggested by
others stops the flood of "blocked" messages in dmesg, but it only
partly fixes the 2.0 minimum load average issue (instead, it's now a
1.0 minimum load average).

I just tried the latest kernel I could get my hands on for Ubuntu
Trusty, the mainline v3.15-rc2 (built April 20th), and it exhibits the
same behavior.

Thanks :)

Daniel
