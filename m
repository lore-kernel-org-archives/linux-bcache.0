From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v2] made consistent displayed help and manpage with
 options acepted by bcache
Date: Sat, 3 Sep 2016 20:36:11 -0800
Message-ID: <20160904043611.6nw2vjhs3j2cnnqm@kmo-pixel>
References: <822ea882-4c6c-2fe0-2434-91be528df726@mejor.pl>
 <24f2eff0-f39a-64af-2168-0a0e08a2bbf2@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33861 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbcIDEgQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Sep 2016 00:36:16 -0400
Received: by mail-pf0-f196.google.com with SMTP id g202so7822022pfb.1
        for <linux-bcache@vger.kernel.org>; Sat, 03 Sep 2016 21:36:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <24f2eff0-f39a-64af-2168-0a0e08a2bbf2@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Sep 02, 2016 at 02:56:16PM +0200, Marcin Mirosław wrote:
> W dniu 02.09.2016 o 14:24, Marcin Mirosław pisze:
> Hi!
> 
> This patch fix misleading in name of options in manpage and displayed
> help. But still remains in manpage unimplemented options like "stats" or
> "status". I don't kno how to handle it, remove?
> 
> I'm resending patch due to bad formating.

Can you send with git format-patch or git send-email?

Also go aheand and remove the unimplemented stuff from the manpage.
