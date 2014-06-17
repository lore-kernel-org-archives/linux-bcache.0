From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 22s! [bcache_gc:....]
Date: Tue, 17 Jun 2014 23:46:56 +0400
Message-ID: <CACaajQuAYyp6CzhoF-fmF_aA99uLzxmb0G5b6fWXA1d7YVNVvQ@mail.gmail.com>
References: <539F4414.7070509@nethuis.nl> <CACaajQsy2m32kLUtEFFs-+6iD5WDKWD7cwaNhbTYFv3d_C-X+w@mail.gmail.com>
 <53A08EA5.4000003@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36994 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713AbaFQTrM (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 17 Jun 2014 15:47:12 -0400
Received: by mail-qc0-f176.google.com with SMTP id w7so9358454qcr.35
        for <linux-bcache@vger.kernel.org>; Tue, 17 Jun 2014 12:47:11 -0700 (PDT)
In-Reply-To: <53A08EA5.4000003@kieser.ca>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: Pim van den Berg <pim.vandenberg@nethuis.nl>, linux-bcache@vger.kernel.org

2014-06-17 22:53 GMT+04:00 Peter Kieser <peter@kieser.ca>:
> FYI, Kent Overstreet (maintainer of bcache) recommends 3.14 to fix bcache
> issues.


Hm. Why not backport patches for regressions to all stable lts
kernels? (3.10, 3.12)

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
