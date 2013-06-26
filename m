From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: bcache / udev integration
Date: Thu, 27 Jun 2013 01:06:57 +0200
Message-ID: <51CB7411.1040208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hello,

The patches that add /dev/bcache/by-{uuid,label} symlinks to cached devices are over there:
- https://github.com/g2p/linux/commits/bcache-for-3.10
- https://github.com/g2p/bcache-tools/commits/master

Thanks,
Gabriel de Perthuis
