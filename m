From: Marc MERLIN <marc@merlins.org>
Subject: Re: make-bcache bug?
Date: Sun, 14 May 2017 11:01:27 -0700
Message-ID: <20170514180126.yk7oip3d5yrddjie@merlins.org>
References: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:32982 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753424AbdENSBb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 May 2017 14:01:31 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:50716 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1d9xpg-0007zl-1l
        for <linux-bcache@vger.kernel.org>; Sun, 14 May 2017 11:01:30 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1d9xpf-0006yn-6j
        for linux-bcache@vger.kernel.org; Sun, 14 May 2017 11:01:27 -0700
Content-Disposition: inline
In-Reply-To: <20170514175840.s3l6p4zjxnf2brm6@merlins.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

On Sun, May 14, 2017 at 10:58:40AM -0700, Marc MERLIN wrote:
> bcache-tools (1.0.8-2+b1)
> 
> gargamel:~# make-bcache  -C /dev/sde2
> Already a bcache device on /dev/sde2, overwrite with --wipe-bcache
> gargamel:~# make-bcache  --wipe-bcache -C /dev/sde2 
> Device /dev/sde2 already has a non-bcache superblock, remove it using wipefs and wipefs -a
> 
> /dev/sde2 is an old bcache I'm reformatting.
> The first message is correct
> The 2nd one is not "/dev/sde2 already has a non-bcache superblock"
> 
> Clearly it can't have a bcache and not a bcache superblock, right?
 
Interesting, same problem/bug with -B:
gargamel:~# make-bcache -B /dev/md8 
Already a bcache device on /dev/md8, overwrite with --wipe-bcache
gargamel:~# make-bcache --wipe-bcache -B /dev/md8 
Device /dev/md8 already has a non-bcache superblock, remove it using wipefs and wipefs -a

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
