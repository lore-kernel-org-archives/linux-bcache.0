From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: closures: move control bits one bit right
Date: Tue, 9 Jan 2018 12:19:15 -0700
Message-ID: <b88ff532-f66a-8dc3-db0c-cd207e5a3e3e@kernel.dk>
References: <20180109191323.5816-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:41791 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933798AbeAITTS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 9 Jan 2018 14:19:18 -0500
Received: by mail-ua0-f173.google.com with SMTP id x10so9929996ual.8
        for <linux-bcache@vger.kernel.org>; Tue, 09 Jan 2018 11:19:18 -0800 (PST)
In-Reply-To: <20180109191323.5816-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>

On 1/9/18 12:13 PM, Michael Lyle wrote:
> Otherwise, architectures that do negated adds of atomics (e.g. s390)
> to do atomic_sub fail in closure_set_stopped.

Applied, thanks for fixing that up.

-- 
Jens Axboe
