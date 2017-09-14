From: FERNANDO FREDIANI <fernando.frediani@upx.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 11:46:11 -0300
Message-ID: <CAD7b65Lcc+soTr2bLuCoseQR8CLfmSfXE-oXQUxvJMCxH+Znfg@mail.gmail.com>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
 <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li> <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
 <20170914164006.64488884@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:51614 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINOqM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 10:46:12 -0400
Received: by mail-wr0-f179.google.com with SMTP id z39so532108wrb.8
        for <linux-bcache@vger.kernel.org>; Thu, 14 Sep 2017 07:46:12 -0700 (PDT)
In-Reply-To: <20170914164006.64488884@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-bcache@vger.kernel.org

Not really mandatory but optional.

From bcache documentation:

"In the event of a data IO error on the flash it will try to recover by rea=
ding
from disk or invalidating cache entries.  For unrecoverable errors (meta da=
ta
or dirty data), caching is automatically disabled; if dirty data was presen=
t
in the cache it first disables writeback caching and waits for all dirty da=
ta
to be flushed."

Fernando

On 14/09/2017 11:40, Emmanuel Florac wrote:

Le Thu, 14 Sep 2017 10:10:09 -0300
FERNANDO FREDIANI <fernando.frediani@upx.com> =C3=A9crivait:

If the users reads a piece of data that is just writen to SSD
(unlikely) it should first and in any condition be commited to the
permanent storage and then read from there and cached in another area
of the SSD. Writaback cache is very volatile and lasts only a few
seconds while the data is not yet committed to permanent storage.

In fact multiple device suport is not implemented yet, that's why I
am asking it and comparing with other well technology as ZFS.

However nothing in bcache prevents you from using for instance a RAID
of SSDs as a cache device. Actually for write caching it's mandatory
IMO.
