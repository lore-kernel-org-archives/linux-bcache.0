From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Any way to allow contiguous writes to be cached?
Date: Tue, 1 Apr 2014 09:10:23 +0200
Message-ID: <CAHnuAezVv20jS48FXUU7meithjgoKdBVRRZNgGJMZcGAGYv2KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64668 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaDAHLE (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 1 Apr 2014 03:11:04 -0400
Received: by mail-oa0-f43.google.com with SMTP id eb12so10760700oac.16
        for <linux-bcache@vger.kernel.org>; Tue, 01 Apr 2014 00:11:03 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Amazon EC2, SSD devices on instances are wiped when a machine
crashes and between stop/start cycles.

Therefore, I'm using them with writethrough bcache in front of slower
EBS storage to ensure that my data survives such scenarios, while
still benefiting from (some of) the speed they provide.

My actual data set isn't expected to grow beyond the size that the
cache device offers any time soon, if ever, and so in my case, the
optimum behavior of bcache would be to not just cache random data, but
contiguous as well.

I realize that this isn't how bcache behaves, but I'm wondering if
there's any way to tell it to do so?

Thanks in advance,
Daniel :)
