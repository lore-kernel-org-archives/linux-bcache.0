From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH resend 1/2] bcache: Use %zi to format size_t
Date: Mon, 3 Feb 2014 19:49:25 +0100
Message-ID: <CAMuHMdU6mQpQJtjULE+b+7eOiq=mzEhsb-yZeBemPo6gQaKrQg@mail.gmail.com>
References: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
	<lcojvq$n46$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50848 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaBCSt0 (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 3 Feb 2014 13:49:26 -0500
In-Reply-To: <lcojvq$n46$1@ger.gmane.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org

On Mon, Feb 3, 2014 at 6:34 PM, Ian Pilcher <arequipeno@gmail.com> wrote:
> Shouldn't size_t use %zu?

Technically yes. %zi/%zd prints signed numbers (ssize_t), while %zu prints
unsigned (size_t).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
