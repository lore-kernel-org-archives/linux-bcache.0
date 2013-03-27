From: Gabriel de Perthuis <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Resizing a backing device
Date: Wed, 27 Mar 2013 19:13:52 +0000 (UTC)
Message-ID: <kivgdg$5fp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hola,

Is there a way to notify bcache that a backing device has been resized?

I've tried to do it from sysfs, but after stopping the backing device it
disappears from sysfs and I can't start it again, at least not without
unregistering entirely (which as I understand it will wipe the cached 
data).  A live method would be much better.
