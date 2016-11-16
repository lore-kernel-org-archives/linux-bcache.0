From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: __bch_btree_iter_unlock+0x6a/0xb0 or OpenAFS bug?
Date: Wed, 16 Nov 2016 05:40:56 -0900
Message-ID: <20161116144056.uiqyfplos6ab7ju6@kmo-pixel>
References: <2bb548a4-cce9-e854-e6e8-4cb3fe86af58@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35465 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752131AbcKPOlA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Nov 2016 09:41:00 -0500
Received: by mail-pg0-f49.google.com with SMTP id p66so79828707pga.2
        for <linux-bcache@vger.kernel.org>; Wed, 16 Nov 2016 06:41:00 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <2bb548a4-cce9-e854-e6e8-4cb3fe86af58@posteo.de>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Karl-Philipp Richter <krichter@posteo.de>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

On Wed, Nov 16, 2016 at 12:21:05PM +0100, Karl-Philipp Richter wrote:
> A bcachefs or an OpenAFS bug? I only experience this with the OpenAFS
> cache on a one-partition bcachefs mount.

Where are you getting __bch_btree_iter_unlock() from?
