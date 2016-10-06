From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] time of mounting filesystem with high number of dirs
Date: Thu, 6 Oct 2016 05:01:54 -0800
Message-ID: <20161006130154.zjdy6kfcergsf6ld@kmo-pixel>
References: <5c0639691edb57d1b63b06effb5283d1@mejor.pl>
 <20160907211212.6pvxo7p5z3v2nvhf@kmo-pixel>
 <20160909015629.356sy3q4gg35szbn@kmo-pixel>
 <6720d1e4-29f9-28a2-18ba-63c7380a3ee8@mejor.pl>
 <20160909090049.o45khhwy5t52icch@kmo-pixel>
 <9c9e7ab6-a654-635f-a695-033221093dd0@mejor.pl>
 <20160913023514.j5kcmiz3kn6iw53l@kmo-pixel>
 <00730b22-fc04-1d3e-5526-dfe3a4586415@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33928 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbcJFNB7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Oct 2016 09:01:59 -0400
Received: by mail-pa0-f68.google.com with SMTP id r9so1104727paz.1
        for <linux-bcache@vger.kernel.org>; Thu, 06 Oct 2016 06:01:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <00730b22-fc04-1d3e-5526-dfe3a4586415@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Wed, Oct 05, 2016 at 02:51:55PM +0200, Marcin Mirosław wrote:
> W dniu 13.09.2016 o 04:35, Kent Overstreet pisze:
> [...]
> Hi!
> I'm picking thread with mention about allocation problem.
> 
> > Sorry I forgot to reply to your email about the OOMs - those messages are
> > actually nothing to worry about, we have a mempool we use if that allocation
> > fails (I'll change it to not print out that message now, just got sidetracked).
> 
> Today I tried to mount freshly formated filesystem (with lz4 enabled at
> format time). Mount failed with message in dmesg:

Hey - this is another one I've got a fix for in the on disk format changes
branch :) I've got a patch that splits out the gzip and lz4 compression
workspaces, and allocates the gzip one with vmalloc, and adds feature bits to
the superblock so it doesn't have to allocate them at all if compression isn't
in use.

Hoping to get that stuff out soon...
