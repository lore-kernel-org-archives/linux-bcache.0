From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Writeback efficiency -- proposal
Date: Wed, 20 Sep 2017 08:42:53 -0700
Message-ID: <CAJ+L6qfusuW-S7zofY46Ed1Yz9iRBExA-0ZceXBhd39cosudrg@mail.gmail.com>
References: <CAJ+L6qe6=KTXFhss5rfa7g=UCMhp6wwCQ+qL_YZDJq+vWn=PNA@mail.gmail.com>
 <20170920140612.mcdn6roycndrcpml@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:49323 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdITPmz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Sep 2017 11:42:55 -0400
Received: by mail-qk0-f179.google.com with SMTP id u67so3108862qkg.6
        for <linux-bcache@vger.kernel.org>; Wed, 20 Sep 2017 08:42:54 -0700 (PDT)
In-Reply-To: <20170920140612.mcdn6roycndrcpml@kmo-pixel>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org

On Wed, Sep 20, 2017 at 7:06 AM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> The main thing to be careful about is anything you do that increases scanning
> for dirty data has the potential to cause problems by starving foreground writes
> via the writeback lock.
>
> If you or others are going to be working on this code, trying to improve that
> locking would probably be very worthwhile...

Kent--

This is a very good point.  Hopefully the approach I've got where at
most the work is doubled (and happens less frequently) isn't too bad
on this scale.  I will look at making that locking more granular, too,
though. :D

Thanks,

Mike
