From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: bcache using in case of 5 hdd disks
Date: Tue, 28 Jan 2014 16:31:09 +0400
Message-ID: <CACaajQuXsapq1Vn1jrGK1qZ8HKgW0mRb5vmEqgwKmUHga=1i6Q@mail.gmail.com>
References: <CACaajQvHG=Y-ZywBYi6sNbxEDb1wXOWYLsLJGyNLSL84PYHgxQ@mail.gmail.com>
 <c25cf68c80584a4a80e6adf3395738b9@navex1.navixia.local> <CF0D5CD2.128C0%rolf@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:57130 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1MbZ (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 07:31:25 -0500
Received: by mail-qc0-f176.google.com with SMTP id e16so394543qcx.35
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jan 2014 04:31:25 -0800 (PST)
In-Reply-To: <CF0D5CD2.128C0%rolf@rolffokkens.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rolf Fokkens <rolf@rolffokkens.nl>
Cc: Patrick Zwahlen <paz@navixia.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

2014-01-28 Rolf Fokkens <rolf@rolffokkens.nl>
>
> Op 27/01/14 21:38 schreef Patrick Zwahlen <paz@navixia.com>:
>
> >
> >My understanding is that a single "cacheset" (in your case, your SSD) can
> >be
> >shared between multiple backing devices.
> >
> >You should be able to attach a single cacheset's UUID to multiple devices.
> >
> >Can anyone else confirm ?
>
> Yep, confirmed!
>
> Rolf


Can you explain for me how can i do that?


-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
