From: Liang Chen <liangchen.linux@gmail.com>
Subject: Re: [PATCH] bcache: avoid a dangerous addressing in closure_queue
Date: Thu, 6 Jul 2017 08:18:02 +0800
Message-ID: <CAKhg4tLchH_+sR7VXq=hR7tHU_NRsrsxk6PVTfYx1-B5pA0W+w@mail.gmail.com>
References: <1499259199-15161-1-git-send-email-liangchen.linux@gmail.com> <20170705193143.GA1050@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35083 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbdGFASE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jul 2017 20:18:04 -0400
In-Reply-To: <20170705193143.GA1050@infradead.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, colyli@suse.de, bcache@linux.ewheeler.net

I had the same feeling, and was reluctant to do so. The reason for making this
change was that current code implicitly converts work_func_t to closure_fn, and
it also depends on the offset and size of a few struct not being changed. So the
patch was introduced essentially to solve that, and keep the impact small
meanwhile.

But as you pointed out, explicit casting is still bad too (was hoping it can be
considered less bad at this situation). I will think of a better idea
to handle this
issue unless people agree that the current behaviour is safe.
