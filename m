From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] checksum error probably after switching to crc64
Date: Thu, 22 Sep 2016 03:57:05 -0800
Message-ID: <20160922115705.hhh6fidftgwx3rhu@kmo-pixel>
References: <74415af5-1208-22e5-acd5-6f94410056e3@mejor.pl>
 <fe5c0816-2700-20a5-ce59-02473bcaed42@mejor.pl>
 <20160922113428.rgvfedltplq6oxd7@kmo-pixel>
 <6f5d196d-8782-69ef-e197-ee300ba923ea@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33110 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934008AbcIVL5K (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Sep 2016 07:57:10 -0400
Received: by mail-pa0-f48.google.com with SMTP id hm5so28785340pac.0
        for <linux-bcache@vger.kernel.org>; Thu, 22 Sep 2016 04:57:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6f5d196d-8782-69ef-e197-ee300ba923ea@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Thu, Sep 22, 2016 at 01:38:44PM +0200, Marcin Mirosław wrote:
> W dniu 22.09.2016 o 13:34, Kent Overstreet pisze:
> > On Thu, Sep 22, 2016 at 01:14:45PM +0200, Marcin Mirosław wrote:
> >> W dniu 22.09.2016 o 12:58, Marcin Mirosław pisze:
> >>> Hi!
> >>> I'm at:
> >>> commit b7cb7779de9609899fa53f7bab4e3cee69ac1f7e
> >>> Author: Kent Overstreet <kent.overstreet@gmail.com>
> >>> Date:   Wed Sep 21 17:38:38 2016 -0800
> >>>
> >>>     bcache: fix an ordering issue in btree_interior_update code
> >>>
> >>>     Also a bunch of refactoring
> >>>
> >>>
> >>> Steps:
> >>> # bcache format --discard  --compression_type=lz4 /dev/system10/bcache
> >>> (underlaying devices does not support discard)
> >>> # mount & use fs
> >>> # echo crc64 > data_checksum
> >>> # echo crc64 > metadata_checksum
> >>> # use filesystem
> >>> After sometime I'm getting:
> >>> [ 6444.192279] bcache (dm-11): IO error on dm-11 for checksum error
> >>
> >> After some trying to read files dmesg says:
> >> [ 7651.598498] bcache (dm-11): IO error on dm-11 for checksum error
> >> [ 7657.066482] bio_checksum_uncompress: 83 callbacks suppressed
> > 
> > The crc64 fix turned out to be an incompatible change for crc32c, so I had to
> > revert it. I'm just going to wait till I do all the other breaking changes for
> > that one (which should be soon).
> 
> 
> Even when files are written after changing to crc64?

That was the original bug, so yeah.
