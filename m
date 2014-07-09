From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Re: [PATCH] bcache: fix writeback thread to sleep less intrusively
Date: Wed, 9 Jul 2014 12:27:51 +0200
Message-ID: <CAHnuAez0rb9PLLEU7sB79x2_w14bJre+4ZbkWKyO+YUF255Czw@mail.gmail.com>
References: <20140411002636.GB9176@birch.djwong.org> <20140411004649.GA4817@kmo>
 <20140411014135.GA18933@birch.djwong.org> <20140412023101.GC9176@birch.djwong.org>
 <CAHnuAewaE5r0Z9L+EL93SscrrYsFphnrWCD4Vb32O8VjX2PK+w@mail.gmail.com>
 <20140430172455.GA3029@birch.djwong.org> <CAHnuAexAx_QK3tycB_2o60JDYZAHUgbec=fu3i47ZSXrL4nARg@mail.gmail.com>
 <CACHGV4+mNu_KV7JazT-34D++3S2NKhDkOmc_wo0QfrfdqpccoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41984 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaGIK2i (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Wed, 9 Jul 2014 06:28:38 -0400
Received: by mail-oa0-f47.google.com with SMTP id g18so802444oah.34
        for <linux-bcache@vger.kernel.org>; Wed, 09 Jul 2014 03:28:37 -0700 (PDT)
In-Reply-To: <CACHGV4+mNu_KV7JazT-34D++3S2NKhDkOmc_wo0QfrfdqpccoQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
Cc: linux-bcache@vger.kernel.org

On Thu, May 1, 2014 at 11:53 PM, Slava Pestov <sp@datera.io> wrote:
> Hi Daniel and Darrick,
>
> I mailed a patch that attempts to fix the uninterruptible issue while taking
> Kent's feedback regarding your earlier patch into account. Please test it
> out and let me know what you think.
>

Curious about what ever happened to this bug. This patch fixed the
load bug, but with new problems added...

Did anyone ever fix this properly? Or is it being attended to?

Thanks, and thanks for the great work so far :)

Daniel
