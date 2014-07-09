From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Wed, 9 Jul 2014 21:18:50 +0200
Message-ID: <CAHnuAex9Ft9yx2dx_NdRYShARWZBzg2S++Y7ZQD_Em2crhd4vA@mail.gmail.com>
References: <20140411002636.GB9176@birch.djwong.org> <20140411004649.GA4817@kmo>
 <20140411014135.GA18933@birch.djwong.org> <20140412023101.GC9176@birch.djwong.org>
 <CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
 <20140430172455.GA3029@birch.djwong.org> <CAHnuAexAx_QK3tycB_2o60JDYZAHUgbec=fu3i47ZSXrL4nARg@mail.gmail.com>
 <CACHGV4+mNu_KV7JazT-34D++3S2NKhDkOmc_wo0QfrfdqpccoQ@mail.gmail.com>
 <CAHnuAez0rb9PLLEU7sB79x2_w14bJre+4ZbkWKyO+YUF255Czw@mail.gmail.com>
 <53BD658A.9020100@kieser.ca> <CAHnuAeyD2RJh+DNbBfRq4XtdsYKHGRv0kEa8yfTb+FX61Ln8kw@mail.gmail.com>
 <CACHGV4LX4r7f-gb+hsiNe0GYDODwUq8G-VsEx8_oJCxOpweQpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:64327 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGITTb (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Jul 2014 15:19:31 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so8749288oag.32
        for <linux-bcache@vger.kernel.org>; Wed, 09 Jul 2014 12:19:31 -0700 (PDT)
In-Reply-To: <CACHGV4LX4r7f-gb+hsiNe0GYDODwUq8G-VsEx8_oJCxOpweQpg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Slava Pestov <sp@datera.io>
Cc: Peter Kieser <peter@kieser.ca>, linux-bcache@vger.kernel.org

On Wed, Jul 9, 2014 at 8:19 PM, Slava Pestov <sp@datera.io> wrote:
> I sent two patches to fix the writeback thread -- if you apply both of
> them, everything should work fine.
>

That's fantastic! :D Where is the right place to look for these patches?

Thanks!

Daniel
