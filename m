From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: bcache by-label / by-uuid symlinks missing after upgrade from debian
 wheezy to jessie
Date: Mon, 14 Nov 2016 15:33:38 +0100
Message-ID: <18d55c8c-c9c3-fad1-0ab5-f23a42f8187b@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:11221 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752123AbcKNOjF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 14 Nov 2016 09:39:05 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>

Hello,

after upgrading from debian wheezy to jessie i no longer have the
/dev/bcache/by-uuid | by-label entries on my system.

I already google'd around but didn't find a solution.

# ls -la /dev/bcache*
brw-rw---- 1 root disk 254, 0 Nov 14 15:25 /dev/bcache0
brw-rw---- 1 root disk 254, 1 Nov 14 15:10 /dev/bcache1
brw-rw---- 1 root disk 254, 2 Nov 14 15:10 /dev/bcache2
brw-rw---- 1 root disk 254, 3 Nov 14 15:10 /dev/bcache3

# cat /lib/udev/rules.d/69-bcache.rules
# register bcache devices as they come up
# man 7 udev for syntax

SUBSYSTEM!="block", GOTO="bcache_end"
ACTION=="remove", GOTO="bcache_end"
ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="bcache_end"
KERNEL=="fd*|sr*", GOTO="bcache_end"

# blkid was run by the standard udev rules
# It recognised bcache (util-linux 2.24+)
ENV{ID_FS_TYPE}=="bcache", GOTO="bcache_backing_found"
# It recognised something else; bail
ENV{ID_FS_TYPE}=="?*", GOTO="bcache_backing_end"

# Backing devices: scan, symlink, register
IMPORT{program}="probe-bcache -o udev $tempnode"
ENV{ID_FS_TYPE}!="bcache", GOTO="bcache_backing_end"
ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"

LABEL="bcache_backing_found"
RUN{builtin}+="kmod load bcache"
RUN+="bcache-register $tempnode"
LABEL="bcache_backing_end"

# Cached devices: symlink
DRIVER=="bcache", ENV{CACHED_UUID}=="?*", \
        SYMLINK+="bcache/by-uuid/$env{CACHED_UUID}"
DRIVER=="bcache", ENV{CACHED_LABEL}=="?*", \
        SYMLINK+="bcache/by-label/$env{CACHED_LABEL}"

LABEL="bcache_end"

I've no idea why those symlinks are not created but i'm also not a udev
expert.

Has anybody seen this before?

Greets,
Stefan
