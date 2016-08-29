From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] Can't mount tiered fs. (after updating kernel?)
Date: Mon, 29 Aug 2016 04:57:56 -0800
Message-ID: <20160829125756.ycu2mxwmvykhsrwl@kmo-pixel>
References: <8e67f156-a5b7-007a-9f5f-81ea11263e9e@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35935 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757174AbcH2M6F (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2016 08:58:05 -0400
Received: by mail-pa0-f50.google.com with SMTP id ci2so9009216pad.3
        for <linux-bcache@vger.kernel.org>; Mon, 29 Aug 2016 05:58:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <8e67f156-a5b7-007a-9f5f-81ea11263e9e@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Mon, Aug 29, 2016 at 02:37:45PM +0200, Marcin Mirosław wrote:
> Hi!
> Today I've updated linux-bcache to
> 58b5f01a443201c4b6c219fa14e6712a0dc08b06 . Changed some option in

That was a bug in a reserves patch - I backed it out, update again.
