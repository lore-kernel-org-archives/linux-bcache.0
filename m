From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v2] bcache: explicitly destroy mutex while exiting
Date: Fri, 27 Oct 2017 12:15:12 -0700
Message-ID: <CAJ+L6qek7Rt5HvCU_Y0anpoa731Jzu+QeC9P=FVCxj9ksPFpVg@mail.gmail.com>
References: <20171010090049.6596-1-liangchen.linux@gmail.com>
 <01f432e8-950a-fc9f-150d-0b51fa9e7559@coly.li> <c06f2a04-3654-0bb9-f07d-ee6d2b27868d@lyle.org>
 <alpine.LRH.2.11.1710271903590.24585@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:54831 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdJ0TPO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 15:15:14 -0400
Received: by mail-qk0-f181.google.com with SMTP id n5so9573173qke.11
        for <linux-bcache@vger.kernel.org>; Fri, 27 Oct 2017 12:15:14 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1710271903590.24585@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Coly Li <i@coly.li>, Liang Chen <liangchen.linux@gmail.com>, linux-bcache@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org

On Fri, Oct 27, 2017 at 12:05 PM, Eric Wheeler
<bcache@lists.ewheeler.net> wrote:
> Should this Cc: stable to avoid the register race (possible
> crash?) described by Liang in other stable kernels?
>
> Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>

This seems like an unlikely failure; basically you must have built
bcache for debug (which not many of us are doing on previous stable
series), and then be critically out of resources at the time that
bcache is registering.  Seems like more trouble than it's worth to
send it to -stable.

Mike
