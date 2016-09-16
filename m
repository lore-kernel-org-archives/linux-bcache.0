From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Fri, 16 Sep 2016 01:16:27 -0800
Message-ID: <20160916091627.nmu2syyabwcohhh3@kmo-pixel>
References: <20160916083853.5syjxgpb4f73bmtt@kmo-pixel>
 <17792e18-4315-0e12-bc5a-96d1cb3e10d5@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36842 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753500AbcIPJQc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 05:16:32 -0400
Received: by mail-pf0-f178.google.com with SMTP id q2so5673042pfj.3
        for <linux-bcache@vger.kernel.org>; Fri, 16 Sep 2016 02:16:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <17792e18-4315-0e12-bc5a-96d1cb3e10d5@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Sep 16, 2016 at 11:02:10AM +0200, Marcin Mirosław wrote:
> W dniu 16.09.2016 o 10:38, Kent Overstreet pisze:
> [...]
> > I haven't yet tried randomly flipping the compression type at runtime, I'll try
> > that now...
> 
> Don't forget changing other options, simply changing compression type I
> tested some times ago and it worked;) I think that also heavy writes
> while making changes are important.

Yeah, I think you're right about heavy writes - the one other bug remotely like
this that's been reported was an intermittent deadlock under heavy write load.

But "heavy write workload" describes a lot of the tests I already have, so I'm
not sure what I'm missing. Argh.
