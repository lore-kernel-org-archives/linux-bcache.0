From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: [PATCH] bcache-tools udev fix for unnecessary re-registration of
 disks
Date: Tue, 29 Mar 2016 01:06:17 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603290104070.13440@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([71.19.153.34]:47412 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986AbcC2BGY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
	Mon, 28 Mar 2016 21:06:24 -0400
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-bcache@vger.kernel.org

On Mon, 7 Mar 2016, Marc MERLIN wrote:
> I'm not sure why it tried to register sdl2 then when it was already
> registered from boot. Did it time out and had to be registered again?

This is a bit ugly of a udev hack, but it prevents duplicate 
registrations.  I'm open to a better way if someone knows how to make udev 
behave:

diff --git a/69-bcache.rules b/69-bcache.rules
index 9cc7f0d..0efb66d 100644
--- a/69-bcache.rules
+++ b/69-bcache.rules
@@ -6,6 +6,9 @@ ACTION=="remove", GOTO="bcache_end"
 ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="bcache_end"
 KERNEL=="fd*|sr*", GOTO="bcache_end"
 
+IMPORT{program}="/bin/sh -c 'echo -n UDEV_PATH_ALREADY_REGISTERED=; /usr/bin/test -e /sys/$(/usr/sbin/udevadm info -n $tempnode -q path)/bcache && echo 1 || echo 0'"
+ENV{UDEV_PATH_ALREADY_REGISTERED}=="1", GOTO="bcache_end"
+
 # blkid was run by the standard udev rules
 # It recognised bcache (util-linux 2.24+)
 ENV{ID_FS_TYPE}=="bcache", GOTO="bcache_backing_found"
--
Eric Wheeler
