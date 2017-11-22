From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 12:23:01 +0100
Message-ID: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:53077 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751556AbdKVLXD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 06:23:03 -0500
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hello,

i've 6 bcache blk devices attached to 3 caching ssds (2 each). One fails
to register automatically at boot time.

After reboot i always need to execute:
echo /dev/sdf1 >/sys/fs/bcache/register

to bring up the bcache device.

Any idea?

Greets,
Stefan

Register happens through the following udev file:
# register bcache devices as they come up
# man 7 udev for syntax

SUBSYSTEM!="block", GOTO="bcache_end"
ACTION=="remove", GOTO="bcache_end"

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
RUN+="bcache-register $tempnode"
LABEL="bcache_backing_end"

# Cached devices: symlink
DRIVER=="bcache", ENV{CACHED_UUID}=="?*", \
        SYMLINK+="bcache/by-uuid/$env{CACHED_UUID}"
DRIVER=="bcache", ENV{CACHED_LABEL}=="?*", \
        SYMLINK+="bcache/by-label/$env{CACHED_LABEL}"

LABEL="bcache_end"
