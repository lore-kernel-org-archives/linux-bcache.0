From: Slava Pestov <sp@datera.io>
Subject: Re: 3.18.1 + latest bcache-dev
Date: Sun, 28 Dec 2014 20:05:28 -0800
Message-ID: <CACHGV4K8aK8=isPftZLsMHCqUf31t1B=kFXDUD1PFCKzDC-D=g@mail.gmail.com>
References: <20141228023534.GA25860@cuci.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:59121 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaL2EFa (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Sun, 28 Dec 2014 23:05:30 -0500
Received: by mail-la0-f48.google.com with SMTP id gf13so10480370lab.21
        for <linux-bcache@vger.kernel.org>; Sun, 28 Dec 2014 20:05:28 -0800 (PST)
In-Reply-To: <20141228023534.GA25860@cuci.nl>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: linux-bcache@vger.kernel.org

Hi Stephen,

The bcache-dev branch has on-disk format changes that require a new
bcache-tools. I'm not sure where Kent posts the source for that.

On Sat, Dec 27, 2014 at 6:35 PM, Stephen R. van den Berg <srb@cuci.nl> wrote:
> Now I tried this:
> Combine 3.18.1 and rebase all the patches from bcache-dev onto that.
> But, in trying that, I get a consistent:
>
> register_bcache() error opening /dev/sdb3: Invalid superblock: member info area missing
>
> Anything I overlooked?   The bcache-tools are straight from git too.
> --
> Stephen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
