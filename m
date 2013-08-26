From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: bcache-tools: minor change for bcache-register
Date: Mon, 26 Aug 2013 11:14:06 +0200
Message-ID: <521B1C5E.2090007@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

bcache-register is called from the provided udev rules in bcache-tools. 
During boot it seams like some devices are registered multiple times, 
which results in messages during boot. To suppress these messages I 
redirect them to /dev/null in the following patch:

--- bcache-tools-20130820/bcache-register.register      2013-08-20 
22:03:46.000000000 +0200
+++ bcache-tools-20130820/bcache-register       2013-08-25 
21:31:11.707823194 +0200
@@ -1,4 +1,9 @@
  #!/bin/sh
-modprobe -qba bcache
-test -f /sys/fs/bcache/register && echo "$1" > /sys/fs/bcache/register
+#
+# Utility script to be called from udev, so it's not monkey proof at 
all. It's
+# sole purpose is to load the bcache kernel module whenever a bcache 
device is
+# detected.
+#
+/usr/sbin/modprobe -qba bcache
+test -f /sys/fs/bcache/register && echo "$1" > /sys/fs/bcache/register 
2>/dev/null

I can imagine there's a more elegant solution, suggestions are welcome.

Rolf
