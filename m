From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: bcache-tools: changes to make the udev rules work
Date: Mon, 26 Aug 2013 11:23:32 +0200
Message-ID: <521B1E94.8090802@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

When making bcache tools run on Fedora I had to make some small tweaks 
on the udev rules file:

- first trying with blkid doesn't work, because it doesn't know about bcache
- full pathnames are needed, also for bcache-register because udev 
doesn't include /sbin and /usr/sbin in PATH.

This is the diff:

--- bcache-tools-20130820/61-bcache.rules.rules    2013-08-20 
22:03:46.000000000 +0200
+++ bcache-tools-20130820/61-bcache.rules    2013-08-25 
15:53:32.690312711 +0200
@@ -5,14 +5,14 @@
  ACTION=="remove", GOTO="bcache_end"

  # Backing devices: scan, symlink, register
-IMPORT{program}="/sbin/blkid -o udev $tempnode"
+#IMPORT{program}="/usr/sbin/blkid -o udev $tempnode"
  # blkid and probe-bcache can disagree, in which case don't register
-ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache", GOTO="bcache_backing_end"
+#ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache", 
GOTO="bcache_backing_end"

-IMPORT{program}="/sbin/probe-bcache -o udev $tempnode"
+IMPORT{program}="/usr/sbin/probe-bcache -o udev $tempnode"
  ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
  SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="bcache", \
-        RUN+="bcache-register $tempnode"
+        RUN+="/usr/lib/udev/bcache-register $tempnode"
  LABEL="bcache_backing_end"

  # Cached devices: symlink

Any feedback is welcome,

Rolf
