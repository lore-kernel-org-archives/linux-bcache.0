From: Will Tatam <will-eSrJ3h7o4/Lk1uMJSBkQmQ@public.gmane.org>
Subject: Kernel Compilation - As a module
Date: Wed, 01 Feb 2012 15:20:11 +0000
Message-ID: <4F29582B.4060900@netmindz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Is it possible to build bcache as a module for your current kernel ? The
code I checked out appeared to be an entire linux kernel tree from what
I could see at quick glance

When I've been building other stuff before, drbd, v2l-dvb etc I can just
build the extra modules provided I have the kernel headers (and
sometimes full source) for my running kernel

This is of course much faster, less disruptive and also allows you to do
things like build kmods

What would need to happen to make this possible, or am I just failing
into the common trap of not reviewing all the documentation proper to
asking a possibly simple question ?

-- 
Will Tatam
