From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Compilation error: ERROR: "pagecache_add_put"
 [drivers/md/bcache/bcache.ko] undefined!
Date: Tue, 29 Mar 2016 13:01:39 -0800
Message-ID: <20160329210139.GA8239@kmo-pixel>
References: <56FA8D3C.60307@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35255 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbcC2VBo (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 29 Mar 2016 17:01:44 -0400
Received: by mail-pf0-f175.google.com with SMTP id n5so24040859pfn.2
        for <linux-bcache@vger.kernel.org>; Tue, 29 Mar 2016 14:01:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56FA8D3C.60307@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Tue, Mar 29, 2016 at 04:12:12PM +0200, Marcin Miros=C5=82aw wrote:
> Hi again!
> Since commit 53b6273b131a864947a2c55a18c07e86487e0a87 I'm getting err=
ors:
> Kernel: arch/x86/boot/bzImage is ready  (#6)
>   Building modules, stage 2.
>   MODPOST 538 modules
> ERROR: "pagecache_add_put" [drivers/md/bcache/bcache.ko] undefined!

Thanks, fixed.

Also pushed another small patch for the memory allocation failure in th=
e lz4
code - it ought to work reliably in practice now.
