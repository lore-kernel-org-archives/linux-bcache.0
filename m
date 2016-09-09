From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] bcache: bch_open_as_blockdevs() register_cache_set
 err Bad checksum
Date: Fri, 9 Sep 2016 01:15:48 -0800
Message-ID: <20160909091548.j5h4axfpghzznux2@kmo-pixel>
References: <18fba014-c2d9-2685-cf6d-b1ee0de35bda@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34439 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbcIIJPw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Sep 2016 05:15:52 -0400
Received: by mail-pf0-f174.google.com with SMTP id p64so27808457pfb.1
        for <linux-bcache@vger.kernel.org>; Fri, 09 Sep 2016 02:15:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <18fba014-c2d9-2685-cf6d-b1ee0de35bda@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Sep 09, 2016 at 09:36:59AM +0200, Marcin Mirosław wrote:
> Hi!
> Today I launched host at my job. When I tried to mount bcachefs I got:
> bcache: bch_open_as_blockdevs() register_cache_set err Bad checksum
> 
> This is simple, not tieres fs. I don't have idea what to do next to help
> debug this. Data on this fs are completely unimportant.

The superblock checksum is bad (I'm going to improve that error message)... what
in the heck...

Anything remotely unusual about the machine or how you were using it?

Existing filesystem, right? Not freshly formatted?

The only thing I can really think of is there was a torn write while writing the
superblock - if the power failed or the VM was killed partway through writing
the superblock, that would cause it. Unfortunately we don't have backup
superblocks yet... I suppose I should really get on that...
