From: Pavel Goran <via-bcache@pvgoran.name>
Subject: Re: Bricked-ish Bcache Backing Disk
Date: Mon, 28 Aug 2017 12:21:46 +0700
Message-ID: <7152087.20170828122146@pvgoran.name>
References: <CAHnpKQXSHaEL3n5pJNAduM1J=+2SFZEz_h2a3kOzM7MhDvtWwQ@mail.gmail.com>
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from vostok.pvgoran.name ([71.19.149.48]:57747 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdH1F0u (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Aug 2017 01:26:50 -0400
In-Reply-To: <CAHnpKQXSHaEL3n5pJNAduM1J=+2SFZEz_h2a3kOzM7MhDvtWwQ@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Shaun S <linux-bcache@vger.kernel.org>

Hello Shaun,

Monday, August 28, 2017, 11:00:02 AM, you wrote:

> I need to recover a file from a bcache disk that won't mount, the
> underlying fs is btrfs. I'd like to read the btrfs partition directly
> by skipping the bcache data with dd skip=#, but I need to know how
> much data to skip. Can anyone help me out?

Bcache tools include a program called bcache-super-show, it shows various
values from the cache or backing device superblock. In particular, there is
the "dev.data.first_sector" value which is what you want.

In my case, it shows:

dev.data.first_sector   16

Which means that the underlying data begins from 16-sector (8-kilobyte) offset
of the backing device.

Pavel Goran
  
