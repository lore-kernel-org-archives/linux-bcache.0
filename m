From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs][branch:bcache-dev] BUG: unable to handle kernel
 paging request at
Date: Fri, 10 Mar 2017 11:31:11 -0900
Message-ID: <20170310203111.cpqqhr5dedigokqo@moria.home.lan>
References: <6a235744-9f0d-2a9c-b7ea-c0f7d732b238@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36213 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750897AbdCJUbX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Mar 2017 15:31:23 -0500
Received: by mail-pg0-f53.google.com with SMTP id g2so25337735pge.3
        for <linux-bcache@vger.kernel.org>; Fri, 10 Mar 2017 12:31:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <6a235744-9f0d-2a9c-b7ea-c0f7d732b238@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "marcin@mejor.pl" <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Fri, Mar 10, 2017 at 11:40:03AM +0100, marcin@mejor.pl wrote:
> Hi!
> commit e990d9cc
> 
> command:
> mount -t bcache -o verbose_fsck /dev/system10/bcache /mnt/test

heh, I just hit this one. Fix is up.
