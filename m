From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: bcache register fails due to blkid ID_FS_AMBIVALENT
Date: Mon, 21 Nov 2016 18:48:36 +0100
Message-ID: <adc6628e-268d-d0fa-e395-bbc65f378570@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:27113 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752279AbcKURsk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Nov 2016 12:48:40 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hello list,

one of my bcache devices fails, as the output of blkid from the bdev
device says:
# /sbin/blkid -o udev -p /dev/sdg1
ID_FS_AMBIVALENT=other:bcache other:xfs_external_log

has anybody an idea how to fix this?

A manual
echo /dev/sdg1 >/sys/fs/bcache/register

works fine.

Greets,
Stefan
