From: shiva rkreddy <shiva.rkreddy@gmail.com>
Subject: ceph : bcache register blocked
Date: Tue, 31 Jan 2017 22:13:02 -0600
Message-ID: <CAPntomAEZSnTr33AbPOLgaeXMVTraxCzd7_Fyq-4v7bmBLKdSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:36504 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdBAENI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Jan 2017 23:13:08 -0500
Received: by mail-yw0-f177.google.com with SMTP id v200so54595834ywc.3
        for <linux-bcache@vger.kernel.org>; Tue, 31 Jan 2017 20:13:03 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: "ceph-users@ceph.com" <ceph-users@ceph.com>, linux-bcache@vger.kernel.org

Greetings to all!

I'm experimenting bcache with sas disks as backing devices and nvme as
cache. The backing devices are used as ceph osd mount points.
I was able to make them part of ceph cluster and have the ceph mount
points added to fstab using the bcache uuid.

These bcache backing devices are disappearing after rebooting the host
that has these devices. dmesg shows, bcache_allocto blocked and later
bcache-register blocked.
bcache cache device is registered successfully though.

Digged the mailing list and couldn't find consumable information. Did
anyone encounter this problem ? Any thoughts on troubleshooting ..

Appreciate your help!

dmesg link: https://pastebin.osuosl.org/44846/
