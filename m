From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs][tier] INFO: task bch_tier_read:21414 blocked for more
 than 120 seconds.
Date: Wed, 12 Oct 2016 13:07:46 +0200
Message-ID: <b96021dc-9eaa-ea03-291f-1612d73f49c4@mejor.pl>
References: <ebd2b9da9ab215488fd59797d8d1d67d@mejor.pl>
 <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:57558 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932187AbcJLLIc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Oct 2016 07:08:32 -0400
In-Reply-To: <20161012012600.s2cq5ac37hwwrp3e@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 12.10.2016 o 03:26, Kent Overstreet pisze:
Hi,
[...]
> You're not the only one who's seeing this, I've been chasing this bug for the
> past several days...
> 

Is something that can be done on my side to help with it?
I can add information that tier0 device is a device with short time of
writing requests - it's a HW controller with RAM. Second bling shot is
that using btree-node=256k was problematic some time ago:
http://www.spinics.net/lists/linux-bcache/msg04178.html , maybe this is
somehow related to the btree-node size?

Marcin
