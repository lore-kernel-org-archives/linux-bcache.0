From: Huub Bouma <bouma-CuspTiYYhYk@public.gmane.org>
Subject: solved detecting bcache after wipefs
Date: Fri, 09 Aug 2013 12:23:36 +0200
Message-ID: <5204C328.6050107@w20e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi everyone,

I had an issue that the udev rule would not automatically register my
/dev/sdb1 (ssd) bcache block.

After searching the mailing archives I found a reference to using wipefs
before make-bcache, which worked wonderfully.

So it might be a good idea to put this in the user manual?

in my case the ssd partition is /dev/sdb1:

wipefs -a /dev/sdb1
make-bcache -C /dev/sdb1

Cheers, Huub
