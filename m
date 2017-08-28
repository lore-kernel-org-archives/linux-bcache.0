From: Shaun S <personalspacecadet@gmail.com>
Subject: Bricked-ish Bcache Backing Disk
Date: Sun, 27 Aug 2017 21:00:02 -0700
Message-ID: <CAHnpKQXSHaEL3n5pJNAduM1J=+2SFZEz_h2a3kOzM7MhDvtWwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33016 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdH1EAD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Aug 2017 00:00:03 -0400
Received: by mail-yw0-f181.google.com with SMTP id s143so23127464ywg.0
        for <linux-bcache@vger.kernel.org>; Sun, 27 Aug 2017 21:00:03 -0700 (PDT)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

I need to recover a file from a bcache disk that won't mount, the
underlying fs is btrfs. I'd like to read the btrfs partition directly
by skipping the bcache data with dd skip=#, but I need to know how
much data to skip. Can anyone help me out?
