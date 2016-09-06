From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] BUG: soft lockup - CPU#0 stuck for 22s!
 [bch_copygc_read:5328]
Date: Tue, 6 Sep 2016 05:08:58 -0800
Message-ID: <20160906130858.titi5zimv6ptid7e@kmo-pixel>
References: <5e794b2230e3af7ec0a06eaceaf7a6fc@mejor.pl>
 <20160904001729.r3qjqpin62i6d4so@kmo-pixel>
 <c3e7064966b0449f5107bf3cb637c308@mejor.pl>
 <20160906022407.vukmxltjiyq3hn5s@kmo-pixel>
 <bfc629b3-6f12-a658-d609-bbc1e764dddb@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33675 "EHLO
        mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756033AbcIFNJC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Sep 2016 09:09:02 -0400
Received: by mail-pa0-f54.google.com with SMTP id cm16so23697435pac.0
        for <linux-bcache@vger.kernel.org>; Tue, 06 Sep 2016 06:09:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <bfc629b3-6f12-a658-d609-bbc1e764dddb@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Sep 06, 2016 at 01:08:57PM +0200, Marcin Mirosław wrote:
> <low priority wish>
> it could be good to check if on disk format of every device is correct
> and supported.

Whoops - that should be fixed now.
