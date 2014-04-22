From: Nikolay Amiantov <nikoamia@gmail.com>
Subject: Bug in bcache (task blocked)
Date: Tue, 22 Apr 2014 23:56:52 +0400
Message-ID: <CA+waHKVJFgUc2rshdVn+D_AtOWHOX-ncYORZyVvKtcqW9sEaog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45643 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbaDVT5N (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 22 Apr 2014 15:57:13 -0400
Received: by mail-lb0-f169.google.com with SMTP id n15so969649lbi.28
        for <linux-bcache@vger.kernel.org>; Tue, 22 Apr 2014 12:57:12 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello,
I have a bug report on bugzilla.kernel.org ([1]) on bug that was
present from 3.13 and haven't seen any response from that time,
despite being bisected. I figured out that maybe info just hasn't got
to the developers, so I wanted to repost it to this mailing list. I'm
sorry if this problem is already known.

Nikolay.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=69471
