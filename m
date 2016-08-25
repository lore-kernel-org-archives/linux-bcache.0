From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs][tier] kernel BUG at drivers/md/bcache/super.c:1561!
 after double changing state of device
Date: Thu, 25 Aug 2016 14:03:33 +0200
Message-ID: <3bfada34-3dd7-8e28-036a-8c027848f90d@mejor.pl>
References: <d29af387-c549-345d-974a-ee21047978ad@mejor.pl>
 <ca2d4c8e-37bc-bc63-3153-3a089c54ccc4@mejor.pl>
 <a38921be-e827-d227-6e86-3713f42db09c@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:43655 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752917AbcHYME3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Aug 2016 08:04:29 -0400
In-Reply-To: <a38921be-e827-d227-6e86-3713f42db09c@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

https://lwn.net/Articles/655183/ :
"Caveat: don't try to use tiering and checksumming or compression at the
same time yet, the read path needs to be reworked to handle both at the
same time."

Is it sill valid?
