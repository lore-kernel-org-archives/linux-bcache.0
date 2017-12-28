From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: WAL or writeback journal implementation in userspace
Date: Fri, 29 Dec 2017 00:30:13 +0300
Message-ID: <CACaajQs+nObipKeELMy3spMhL2-y7p7dT-f+BShT5rCzFtqGJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:40482 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754237AbdL1Vaf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Dec 2017 16:30:35 -0500
Received: by mail-it0-f46.google.com with SMTP id f190so29907126ita.5
        for <linux-bcache@vger.kernel.org>; Thu, 28 Dec 2017 13:30:35 -0800 (PST)
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: linux-bcache@vger.kernel.org

Hi, sorry this is something like offtopic question, but related to bcache.
I have userspace server app that serves some virtual disk to client.
Virtual disk represented via fixed sized block 4mb. Each block have
uint64 identifier.
Client sends in write case block id, offset, data.
Server stores data on HDD.
I need to implement writeback mode using SSD. So, I need incoming
write request firstly write to SSD, and on each flush interval write
to HDD and purge from SSD.
Main problem to me - write request can overlap, so I need to merge 2
write to 1 single write request on HDD.
And secondly - I need to serve read request from SSD and HDD. And read
request can overlap data on SSD and HDD.
I know about bcache and loves it, but now I need pure userspace solution.
So I need help, what can I read and check in kernel to understand how
implement it?
I can use btree, leveldb and other stuff to solve my problem.
If somebody knows or can help, please do that :)).
Happy Holly days and New year!
