From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Fri, 16 Sep 2016 04:36:34 -0800
Message-ID: <20160916123634.3bvr6zy25smpi3jp@kmo-pixel>
References: <20160916083853.5syjxgpb4f73bmtt@kmo-pixel>
 <17792e18-4315-0e12-bc5a-96d1cb3e10d5@mejor.pl>
 <20160916091627.nmu2syyabwcohhh3@kmo-pixel>
 <4ce5eedb-8e38-ef94-e01e-b46f9ce8c4d4@mejor.pl>
 <20160916112436.fbvvirrjc6zkmorw@kmo-pixel>
 <6c126ac9-d88c-680e-c51c-09159485f569@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36437 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751056AbcIPMgj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 08:36:39 -0400
Received: by mail-pa0-f65.google.com with SMTP id my20so461782pab.3
        for <linux-bcache@vger.kernel.org>; Fri, 16 Sep 2016 05:36:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6c126ac9-d88c-680e-c51c-09159485f569@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Sep 16, 2016 at 02:27:11PM +0200, Marcin Mirosław wrote:
> W dniu 16.09.2016 o 13:24, Kent Overstreet pisze:
> > addr2line -i -e vmlinux ffffffffc095b021
> 
> # addr2line -i -e vmlinux ffffffffc095b021
> ??:0
> 
> bcache is compiled as a module at this host:(
> I recompiled kernel and build bcache inside kernel. I'm getting now much
> more:

The sha1 code - oh, I know what's going on. I'll work on a fix tomorrow.
