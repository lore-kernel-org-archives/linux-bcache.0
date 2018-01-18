From: tang.junhui@zte.com.cn
Subject: Re: [PATCH v2 06/12] bcache: set error_limit correctly
Date: Thu, 18 Jan 2018 14:20:29 +0800
Message-ID: <1516256429-19225-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:37838 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752588AbeARGTC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 Jan 2018 01:19:02 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: colyli@suse.de
Cc: mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

Hello Coly:

>It is because of ca->set->error_decay. When error_decay is set, bcache
>tries to do an exponential decay for error count. That is, error numbers
>is decaying against the quantity of io count, this is to avoid long time
>accumulated errors exceeds error_limit and trigger bch_cache_set_error().
>
>The I/O error counter, uses most significant 12 bits to record real
>errors number. And too many I/Os may decay the errors number too fast,
>so left shit it by 20 bits to make sure there are still enough errors
>number after a while (e.g. the halflife).
>
>The we don't use the left shifting, when error_deay is set, and too many
>I/Os happen, after a small piece of time, number of I/O errors will be
>decayed too fast to reach error_limit. Therefore IMHO the left shifting
>is necessary.
>
>BTW, I doubt whether current exponential error decay in
>bch_count_io_errors() works properly. Because I don't catch the
>connection between IO counter (ca->io_count) and error counter
>(ca->io_errors). By default ca->set->error_decay is 0, so I doubt how
>many people use/test this piece of code. (Maybe I am wrong)

OK, LGTM.

Reviewed-by: Tang Junhui <tang.junhui@zte.com.cn>

And ping Mike?


Thanks,
Tang Junhui
