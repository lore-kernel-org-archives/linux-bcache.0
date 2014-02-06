From: Daniel Smedegaard Buus <danielbuus@gmail.com>
Subject: Md stripe on top of bcache (using EC2 SSDs + EBS)
Date: Thu, 6 Feb 2014 14:05:08 +0100
Message-ID: <CAHnuAezjBnitV_wQiPF7SS-2PgrYTPxw4CG+kTox-a8J-uG8mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36945 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaBFNFs (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Thu, 6 Feb 2014 08:05:48 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so2154729obc.1
        for <linux-bcache@vger.kernel.org>; Thu, 06 Feb 2014 05:05:48 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi :)

Sorry if this isn't the right place to ask questions like this, but
I'm having a bit of trouble getting information about this.

Thing is, I'm trying to set up bcache for an Amazon EC2 machine which
has two ephemeral SSDs. They're not very large, and I'm going to need
more space than what they provide, so I was thinking about using
bcache and use them together with larger (and much slower) EBS drives,
then add mdadm striping on top of that.

This works (I'm using kernel 3.13, by the way), but the performance is
pretty bad. I'm wondering about what the optimal settings would be for
such a setup. Both for the bcache backed devices, and for the md array
itself.

I'm thinking that the chunk size of the md array might negatively
affect the way bcache works, and that it might be better to set it to
something like 4k, assuming that that's what bcache works with
internally (the SSDs being 4k and so on)?

Any ideas?

Thanks in advance,
Daniel
