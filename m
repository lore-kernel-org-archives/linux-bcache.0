From: =?UTF-8?Q?Marcin_Miros=c5=82aw?= <marcin@mejor.pl>
Subject: Re: [bcachefs] bcache (dm-10): IO error on dm-10 for checksum error
 (due to change of str_hash?)
Date: Fri, 16 Sep 2016 11:02:10 +0200
Message-ID: <17792e18-4315-0e12-bc5a-96d1cb3e10d5@mejor.pl>
References: <20160916083853.5syjxgpb4f73bmtt@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from jowisz.mejor.pl ([81.4.120.72]:64988 "EHLO jowisz.mejor.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752280AbcIPJCk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2016 05:02:40 -0400
In-Reply-To: <20160916083853.5syjxgpb4f73bmtt@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

W dniu 16.09.2016 o 10:38, Kent Overstreet pisze:
[...]
> I haven't yet tried randomly flipping the compression type at runtime, I'll try
> that now...

Don't forget changing other options, simply changing compression type I
tested some times ago and it worked;) I think that also heavy writes
while making changes are important.

Marcin
