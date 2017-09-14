From: FERNANDO FREDIANI <fernando.frediani@upx.com>
Subject: Re: SSD usage for bcache - Read and Writeback
Date: Thu, 14 Sep 2017 12:11:35 -0300
Message-ID: <CAD7b65Ki79j1nW9W-o5vEZXdGrZe=rzb137fSbq0uWx=i9r=3w@mail.gmail.com>
References: <CAD7b65Ly7rEVyShjD=1NBsYBMiyQGXuzKv0h2Ys5KN=ghTJcaA@mail.gmail.com>
 <51852c79-bee0-19c3-92d8-6044f3e3e2a7@coly.li> <4a5bb8a9-3de9-bae9-abea-cfa014c87084@upx.com>
 <20170914164006.64488884@harpe.intellique.com> <CAD7b65Lcc+soTr2bLuCoseQR8CLfmSfXE-oXQUxvJMCxH+Znfg@mail.gmail.com>
 <20170914170400.3463da66@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:45665 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdINPLh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 14 Sep 2017 11:11:37 -0400
Received: by mail-wm0-f44.google.com with SMTP id g206so1382971wme.0
        for <linux-bcache@vger.kernel.org>; Thu, 14 Sep 2017 08:11:36 -0700 (PDT)
In-Reply-To: <20170914170400.3463da66@harpe.intellique.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-bcache@vger.kernel.org

There is something that ZFS does well and is very clever way to treat
this: when new data is written is is written to both the flash device
AND to the RAM Memory. Then when it's the time to flush it to the
permanent storage it reads that data from the RAM e not from the flash
(why read from a slower device if you have a fast one available). So
in this scenario if the flash devices fails you don't loose any data
as it still exists in memory.

The only possibility is when you have a power cut AND the flash device
fails at the same time which is very unlikely.

Therefore in my view there is only 1 justification to use a RAID-1 for
writeback: if you don't want to loose write performance if the flash
device fails until you are able to replace it.

Fernando


On 14/09/2017 12:04, Emmanuel Florac wrote:

Le Thu, 14 Sep 2017 11:46:11 -0300
FERNANDO FREDIANI <fernando.frediani@upx.com> =C3=A9crivait:

Not really mandatory but optional.

From bcache documentation:

"In the event of a data IO error on the flash it will try to recover
by reading from disk or invalidating cache entries.  For
unrecoverable errors (meta data or dirty data), caching is
automatically disabled; if dirty data was present in the cache it
first disables writeback caching and waits for all dirty data to be
flushed."

If the cache is dirty and has failed, your data is lost or corrupted
all the same. The way a SSD fails is usually one second it works, the
next second it's as dead as a rock. If you're using it as a write
cache, whatever amount of data is dirty is lost. If it's 8 GB, you've
lost your last 8 GB of writes, often very important filesystem metadata
and/or database journal, i.e. your data is completely hosed.

Don't use SSDs as write cache without RAID-1 (or use very expensive,
redundant NVMe SSDs only), unless your data isn't very important.
