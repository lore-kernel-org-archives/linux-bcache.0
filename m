From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] [PATCH v2] bcache: fix calling ida_simple_remove() with
 incorrect minor
Date: Fri, 27 Oct 2017 12:22:15 -0700
Message-ID: <CAJ+L6qc2ask5y-VeYJAtN_H+9WR2ChxWcQ9z++KEUM4WesGU6w@mail.gmail.com>
References: <OFF5D425D9.E63AA2AA-ON48258155.00224AFB-48258155.002299BE@zte.com.cn>
 <alpine.LRH.2.11.1707130355040.9683@mail.ewheeler.net> <alpine.LRH.2.11.1710271914140.24585@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:43741 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbdJ0TWQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Oct 2017 15:22:16 -0400
Received: by mail-qt0-f179.google.com with SMTP id j58so9734981qtj.0
        for <linux-bcache@vger.kernel.org>; Fri, 27 Oct 2017 12:22:16 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1710271914140.24585@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Tang Junhui <tang.junhui@zte.com.cn>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org

Eric--

On Fri, Oct 27, 2017 at 12:17 PM, Eric Wheeler
<bcache@lists.ewheeler.net> wrote:
> Hi Tang,
>
> This is an important bugfix since v4.10, can you get a clean patch sent to
> the list?
>
> Michael, if Tang can get this in on time, can this squeeze this into v4.14
> before the rc's run out?

Isn't this handled by Coly's 1dbe32ad0a82f39c6dfb7 ?

Mike
