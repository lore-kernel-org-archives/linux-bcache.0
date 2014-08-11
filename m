From: =?UTF-8?B?SmVzw7pzIEfDs21leg==?= <jgomo3@gmail.com>
Subject: Boot proccess messed up after dist-upgrade from Ubuntu 14.04 to 14.04.1
Date: Mon, 11 Aug 2014 12:53:25 -0430
Message-ID: <CAO9z-97N5vc2E90Tz-hk6OX6-4JfeLK7iRkAFvffFWZB0bThEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:52019 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaHKRXq (ORCPT
	<rfc822;linux-bcache@vger.kernel.org>);
	Mon, 11 Aug 2014 13:23:46 -0400
Received: by mail-yh0-f53.google.com with SMTP id c41so6499421yho.26
        for <linux-bcache@vger.kernel.org>; Mon, 11 Aug 2014 10:23:45 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hello!

I'm using bcache for root in Ubuntu 14.04.

After dist-upgrade to 14.04.1, a BusyBox shell appears instead.

I tried set rootdelay with various values, but it doesn't work neither.

Also, There is not a /dev/bcache0 in the BusyBox.

With a liveCD, I mounted  /dev/bcache0 and the /boot partition to
check for references to the uuid of /dev/bcache0 in /etc/fstab and
/boot/grub/grub.cfg and are ok.

Last, "grub-install"ed but nothing works.

Any Idea?.
