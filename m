From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: bcache using in case of 5 hdd disks
Date: Tue, 28 Jan 2014 13:11:33 +0100
Message-ID: <CF0D5CD2.128C0%rolf@rolffokkens.nl>
References: <CACaajQvHG=Y-ZywBYi6sNbxEDb1wXOWYLsLJGyNLSL84PYHgxQ@mail.gmail.com>
 <c25cf68c80584a4a80e6adf3395738b9@navex1.navixia.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38980 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbaA1MLi (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 28 Jan 2014 07:11:38 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so192217eaj.15
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jan 2014 04:11:37 -0800 (PST)
In-Reply-To: <c25cf68c80584a4a80e6adf3395738b9@navex1.navixia.local>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Patrick Zwahlen <paz@navixia.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Op 27/01/14 21:38 schreef Patrick Zwahlen <paz@navixia.com>:

>
>My understanding is that a single "cacheset" (in your case, your SSD) can
>be 
>shared between multiple backing devices.
>
>You should be able to attach a single cacheset's UUID to multiple devices.
>
>Can anyone else confirm ?

Yep, confirmed!

Rolf
