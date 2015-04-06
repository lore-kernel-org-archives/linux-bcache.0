From: arnaud gaboury <arnaud.gaboury@gmail.com>
Subject: Re: Issue when mkfs.btrfs on a bcached partition
Date: Mon, 6 Apr 2015 17:20:58 +0200
Message-ID: <CAK1hC9sLjRiamL0CZXGDS0qWLfMzgNoZNAbSX+iO41v+sN5ZsA@mail.gmail.com>
References: <CAK1hC9v+ghET3=XAStWzofF-4But=sGhFgA-jhHZOobe2jSEzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:36505 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbDFPU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 6 Apr 2015 11:20:59 -0400
Received: by lagv1 with SMTP id v1so21906117lag.3
        for <linux-bcache@vger.kernel.org>; Mon, 06 Apr 2015 08:20:58 -0700 (PDT)
In-Reply-To: <CAK1hC9v+ghET3=XAStWzofF-4But=sGhFgA-jhHZOobe2jSEzg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Sun, Apr 5, 2015 at 11:47 AM, arnaud gaboury
<arnaud.gaboury@gmail.com> wrote:
> Hi,
>
> Here is what I did:
>  # make-bcache -C /dev/sdb1
>  # echo "UUID" > /sys/block/bcache0/bcache/attach
> --------------------------------------
> $ lsblk -o
> .......................
> sdb                      sdb
> =E2=94=94=E2=94=80sdb1                   sdb1    bcache
>   =E2=94=94=E2=94=80bcache0              bcache0
> --------------------------------
> # mkfs.btrfs -L poppy-root /dev/sdb1
> /dev/sdb1 appears to contain an existing filesystem (bcache).
> Error: Use the -f option to force overwrite.
>
>
> Please may you tell what is wrong and how can I make btrfs on bcached=
 partition?

# mkfs.btrfs -L poppy-root  /dev/bcache0 is the solution
