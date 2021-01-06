Return-Path: <linux-bcache-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8D7C433DB
	for <linux-bcache@archiver.kernel.org>; Wed,  6 Jan 2021 18:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A42D22B4B
	for <linux-bcache@archiver.kernel.org>; Wed,  6 Jan 2021 18:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbhAFSbF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-bcache@archiver.kernel.org>);
        Wed, 6 Jan 2021 13:31:05 -0500
Received: from mail.eclipso.de ([217.69.254.104]:58220 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAFSbF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Jan 2021 13:31:05 -0500
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 082135C5
        for <linux-bcache@vger.kernel.org>; Wed, 06 Jan 2021 19:30:24 +0100 (CET)
Date:   Wed, 06 Jan 2021 19:30:24 +0100
MIME-Version: 1.0
Message-ID: <2d981576325bec349ea63861f65668e0@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: multiple caches code is being removed, what is the recommended
        alternative?
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

­Hi All,

I recently saw a series of patches to remove multiple caches code [1] For me, having one large mirrored write cache is desirable, so I can make this structure:

+--------------------------------------------------------------------------+
|                         btrfs raid 1 (2 copies) /mnt                     |
+--------------+--------------+--------------+--------------+--------------+
| /dev/bcache0 | /dev/bcache1 | /dev/bcache2 | /dev/bcache3 | /dev/bcache4 |
+--------------+--------------+--------------+--------------+--------------+
|                   Mirrored  Writeback Cache (SSD)                        |
|                         /dev/sda3 and /dev/sda4                          |
+--------------+--------------+--------------+--------------+--------------+
| Data         | Data         | Data         | Data         | Data         |
| /dev/sda8    | /dev/sda9    | /dev/sda10   | /dev/sda11   | /dev/sda12   |
+--------------+--------------+--------------+--------------+--------------+

This way I don't have to worry about data loss when one of the SSD's or one of the hard drives fails, and I have maximum performance for the least amount of drives.

With the code for multiple caches removed, what is the recommended way forward?
What is the best way to use 2 SSD's with different size and speed, while keeping enough redundancy to survive a single drive failure?

[1] https://lore.kernel.org/linux-bcache/20200822114536.23491-1-colyli@suse.de/T/#t

---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!


