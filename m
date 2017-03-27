From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: journal replay at each boot problematic?
Date: Mon, 27 Mar 2017 13:33:57 +0200
Message-ID: <CAFvQSYSTFPu9yPj-i2E+G53V_Auet8WTQk9q1vAUFQZe=VUWjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:36500 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbdC0LfC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Mar 2017 07:35:02 -0400
Received: by mail-pg0-f49.google.com with SMTP id g2so37174856pge.3
        for <linux-bcache@vger.kernel.org>; Mon, 27 Mar 2017 04:34:08 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi,

I am using bcache in writeback-mode for a very slow (~100kb/s write
speed) backing device.

At each boot I see messages like the following:
> bcache: bch_journal_replay() journal replay done, 2297 keys in 86 entries, seq 71136

Are these messages indicating an unclean shutdown / some kind of
rollback operation - or is it part of "normal" bcache initialization?

Thank you in advance, Clemens
