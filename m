From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [bcachefs] problem with `bcache fsck`
Date: Thu, 16 Mar 2017 15:57:16 -0800
Message-ID: <20170316235651.oehere2zxhewbbdh@moria.home.lan>
References: <6aaaad468dd77840265bcd9f31f1878a@mejor.pl>
 <20170316203455.jgl6ovsrve55fnxi@moria.home.lan>
 <f7e0b5acca043eff08a55f424470221d@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:32933 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752075AbdCQAF6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Mar 2017 20:05:58 -0400
Received: by mail-pf0-f178.google.com with SMTP id w189so31490890pfb.0
        for <linux-bcache@vger.kernel.org>; Thu, 16 Mar 2017 17:05:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <f7e0b5acca043eff08a55f424470221d@mejor.pl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marcin <marcin@mejor.pl>
Cc: linux-bcache@vger.kernel.org

On Thu, Mar 16, 2017 at 11:07:20PM +0100, Marcin wrote:
> If I add bcachefs to fstab openrc expects userland fsck to works this is why
> I tried it to use.

Fsck should be fixed now

> There is no new commit, I'm at
> commit 7274700edcf99ab67d4f72eca4f07d0220b9abae
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Tue Mar 14 21:07:39 2017 -0800
> 
>     bcache: fix device hot add

Ok, you're good then (at least re: the buffered reads bug)

> I suspect that problem is due to using  --metadata_replicas=2. If you have a
> some spare time please try fileystsem formated with this parameters:
> # bcache format --compression_type=gzip --metadata_replicas=2
> --data_checksum_type=crc64 --metadata_checksum_type=crc64 --tier=2 /dev/sde1
> --tier=3 /dev/sdd1

Alright, will do

> You have implemented too many features, everyone find something usefull for
> self and want to have it. You should implement only writing and reading
> to/from files;)

Heh :)

> Btw:
> # curl https://evilpiepirate.org/git/bcache-tools.git/
> curl: (51) SSL: no alternative certificate subject name matches target host
> name 'evilpiepirate.org'

Works for me now - I was updating SSL certs and some other stuff earlier
though, I might have broken it temporarily then
