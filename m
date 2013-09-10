From: Rolf Fokkens <rolf-6w2rdlBuEQTpMFipWq+H6g@public.gmane.org>
Subject: Updated package for Fedora
Date: Tue, 10 Sep 2013 20:22:21 +0200
Message-ID: <522F635D.4030905@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-bcache@vger.kernel.org

Hi!

I updated the Fedora 20 & rawhide package for bcache-tools:

https://admin.fedoraproject.org/updates/bcache-tools-0-0.11.20130909git.fc20

It's an update to the latest git / gist sources for bcache-tools an 
bcache-status. Some of the patches it includes to make it run on Fedora 
are explained below.

Rolf

bcache-tools-20130827-udevfix.patch
=======================
On Fedora only 'early' udev rules files run /usr/sbin/blkid and the rest 
of the rules files use the results. This patch removes the call to 
/usr/sbin/blkid and (more important) makes sure that probe-bcache does 
not print overlapping variable names. This is needed until util-linux 
itself supports bcache, after that there's no need to call  
probe-bcaches at all.

--- bcache-tools-20130827/61-bcache.rules.orig    2013-09-06 
08:54:07.656978850 +0200
+++ bcache-tools-20130827/61-bcache.rules    2013-09-06 
08:57:09.769768802 +0200
@@ -5,13 +5,12 @@
  ACTION=="remove", GOTO="bcache_end"

  # Backing devices: scan, symlink, register
-IMPORT{program}="/sbin/blkid -o udev $tempnode"
  # blkid and probe-bcache can disagree, in which case don't register
  ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache", 
GOTO="bcache_backing_end"

  IMPORT{program}="/sbin/probe-bcache -o udev $tempnode"
-ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
-SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="bcache", \
+ENV{BCACHE_ID_FS_UUID_ENC}=="?*", 
SYMLINK+="disk/by-uuid/$env{BCACHE_ID_FS_UUID_ENC}"
+SUBSYSTEM=="block", ACTION=="add|change", 
ENV{BCACHE_ID_FS_TYPE}=="bcache", \
          RUN+="bcache-register $tempnode"
  LABEL="bcache_backing_end"

--- bcache-tools-20130827/probe-bcache.c.orig    2013-09-06 
08:52:28.743089432 +0200
+++ bcache-tools-20130827/probe-bcache.c    2013-09-06 
08:53:44.046005241 +0200
@@ -61,9 +61,9 @@
          uuid_unparse(sb.uuid, uuid);

          if (udev)
-            printf("ID_FS_UUID=%s\n"
-                   "ID_FS_UUID_ENC=%s\n"
-                   "ID_FS_TYPE=bcache\n",
+            printf("BCACHE_ID_FS_UUID=%s\n"
+                   "BCACHE_ID_FS_UUID_ENC=%s\n"
+                   "BCACHE_ID_FS_TYPE=bcache\n",
                     uuid, uuid);
          else
              printf("%s: UUID=\"\" TYPE=\"bcache\"\n", uuid);



bcache-tools-20130827-register.patch
=======================
Fedora needs full path names to call /sbin/ binaries from udev, this is 
fixed in this patch. Also errors are suppressed when a device is 
registered twice.

--- bcache-tools-20130827.orig/bcache-register    2013-08-26 
23:46:19.000000000 +0200
+++ bcache-tools-20130827/bcache-register    2013-08-27 
08:49:59.924940825 +0200
@@ -1,4 +1,9 @@
  #!/bin/sh
-modprobe -qba bcache
-test -f /sys/fs/bcache/register_quiet && echo "$1" > 
/sys/fs/bcache/register_quiet
+#
+# Utility script to be called from udev, so it's not monkey proof at 
all. It's
+# sole purpose is to load the bcache kernel module whenever a bcache 
device is
+# detected.
+#
+/sbin/modprobe -qba bcache
+test -f /sys/fs/bcache/register_quiet && echo "$1" > 
/sys/fs/bcache/register_quiet 2>/dev/null
