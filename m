From: Gabriel <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Don't register if a non-bcache superblock is found as well
Date: Sun, 21 Jul 2013 20:17:17 +0200
Message-ID: <1374430637-12954-1-git-send-email-g2p.code@gmail.com>
References: <ksh1nq$dvp$1@ger.gmane.org>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ksh1nq$dvp$1@ger.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Cyril B ." <cbay-SxHCd5+OuqTrt3ojHgZu+w@public.gmane.org>
Cc: Gabriel <g2p.code-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-bcache@vger.kernel.org

---
This should fix it.

Because the raid superblock is at the end of the device, bcache's
udev rules could detect a bcache device on the unassembled raid
member.  A better fix would be to merge probe-bcache into
util-linux's blkid.

 61-bcache.rules | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/61-bcache.rules b/61-bcache.rules
index 22c1a90..dd85e69 100644
--- a/61-bcache.rules
+++ b/61-bcache.rules
@@ -3,14 +3,19 @@
 
 SUBSYSTEM!="block", GOTO="bcache_end"
 ACTION=="remove", GOTO="bcache_end"
 
 # Backing devices: scan, symlink, register
+IMPORT{program}="/sbin/blkid -o udev $tempnode"
+# blkid and probe-bcache can disagree, in which case don't register
+ENV{ID_FS_TYPE}=="?*", ENV{ID_FS_TYPE}!="bcache", GOTO="bcache_backing_end"
+
 IMPORT{program}="/sbin/probe-bcache -o udev $tempnode"
 ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
 SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="bcache", \
         RUN+="bcache-register $tempnode"
+LABEL="bcache_backing_end"
 
 # Cached devices: symlink
 DRIVER=="bcache", ENV{CACHED_UUID}=="?*", \
         SYMLINK+="bcache/by-uuid/$env{CACHED_UUID}"
 DRIVER=="bcache", ENV{CACHED_LABEL}=="?*", \
-- 
1.8.3.3.758.g90e98ff
