From: Paul Clements <paul.clements@us.sios.com>
Subject: Re: [Nbd] bcache on NBD block devices
Date: Tue, 25 Feb 2014 11:37:23 -0500
Message-ID: <CAECXXi68Q=5aXQ_NnubkMNsGxPPefCiz77pnYthNU-Jk88qQeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:65319 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaBYQhY (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Tue, 25 Feb 2014 11:37:24 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so2986730pbb.28
        for <linux-bcache@vger.kernel.org>; Tue, 25 Feb 2014 08:37:23 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Juan Antonio Martinez <jantonio@dit.upm.es>
Cc: linux-bcache@vger.kernel.org

On Tue, Feb 25, 2014 at 9:40 AM, Juan Antonio Martinez
<jantonio@dit.upm.es> wrote:
>
> Hi all
>
> (This is my first post on this list. I'm still a novice on bcache and
> proper nettiquete on this list, so apologize for my mistakes)
>
> Scenario: several NBD LTSP Fat Clients on (a bit) obsolete hardware
> kernel 3.11.0-15 on Ubuntu 13.10
>
> /dev/sda1 as local cache device
> /dev/nbd1 as remote NBD backing bcache device
>
> - I've created and registered /dev/sda1 as cache device without problems
> - To create nbd file to be exported I've typed following sequence:
>
> # create an empty file
> root# dd if=/dev/zero of=bcache_test.img bs=1M count=64
> # use it as loop block device
> root# losetup /dev/loop0
> # make it a backing bcache device
> root# make-bcache -B /dev/loop0


have you tried doing this step from the client machine instead, i.e.:

make-bache -B /dev/nbd1

after the nbd connection is up? does that work?
