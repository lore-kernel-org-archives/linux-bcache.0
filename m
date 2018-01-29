From: Pony Cheng <ponycheng0@gmail.com>
Subject: bcache journal
Date: Mon, 29 Jan 2018 15:23:12 +0800
Message-ID: <CAATtUKmyuZUXq0SLx6YmMJPWzFfw15cNm=EGZpD6pxeuHGqt+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39882 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbeA2HXN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jan 2018 02:23:13 -0500
Received: by mail-wr0-f193.google.com with SMTP id f6so4340725wra.6
        for <linux-bcache@vger.kernel.org>; Sun, 28 Jan 2018 23:23:13 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi all:
     I'm reading the source code of bcache, and I'm so confused about
journal. Journal just use bucket of cache, why we need it, and what's
the real purpose of journal in bcache. If we write to the bucket, do
we need write it to journal first?

How do you think of these?

Pony Cheng

Thanks.
