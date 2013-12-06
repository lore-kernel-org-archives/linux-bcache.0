From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: Re: Using bcache to save power -- safe?
Date: Fri, 6 Dec 2013 11:41:44 +0100
Message-ID: <CAA-O0XjDVi3aUYbRWpjmcCBdeZkdu7jeVYHVqLccyoCZOM4Nzw@mail.gmail.com>
References: <CAA-O0Xh0p1ERoR_QDrzj3T_5b-G63fnW+ykLqmu8L=_A3m5p8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:60722 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3LFKlp (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Fri, 6 Dec 2013 05:41:45 -0500
Received: by mail-vc0-f170.google.com with SMTP id ht10so516443vcb.15
        for <linux-bcache@vger.kernel.org>; Fri, 06 Dec 2013 02:41:44 -0800 (PST)
In-Reply-To: <CAA-O0Xh0p1ERoR_QDrzj3T_5b-G63fnW+ykLqmu8L=_A3m5p8A@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Wed, Dec 4, 2013 at 3:59 PM, Wesley W. Terpstra <wesley@terpstra.ca> wrote:
> My question: Can I leave writeback_running=0, or will it hurt my data?
>
> Is near-permanent writeback_running=0 safe?

I'm still quite interested to know if this will come back to bite me.
