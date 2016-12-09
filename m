From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs-testing] BUG: unable to handle kernel paging request
 at 0000005780540006
Date: Fri, 9 Dec 2016 14:25:57 -0900
Message-ID: <20161209232557.elip24quin24awq5@kmo-pixel>
References: <b66c17f1-19d0-702f-f09e-acd6e5116587@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35772 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbcLIX0B (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Dec 2016 18:26:01 -0500
Received: by mail-pg0-f66.google.com with SMTP id p66so3621835pga.2
        for <linux-bcache@vger.kernel.org>; Fri, 09 Dec 2016 15:26:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <b66c17f1-19d0-702f-f09e-acd6e5116587@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "marcin@mejor.pl" <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Dec 09, 2016 at 11:08:05AM +0100, marcin@mejor.pl wrote:
> Hi all!
> 
> Kernel at:
> commit a3cccb56d861c0092be2b58cbaf7b44e298f59bc
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Thu Dec 8 14:41:14 2016 -0900
> 
>     bcache: increase default journal write delay for spinning rust
> 
> 
> Today I tried to use bcachefs as /home. After sometime, when I do backup
> of /home I got:
> 
> > Dec  9 10:44:09 localhost kernel: [ 3517.194588] BUG: unable to handle kernel paging request at 0000005780540006

Ok, I see what's wrong - fix is up in bcachefs-testing
