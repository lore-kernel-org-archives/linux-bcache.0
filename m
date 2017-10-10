From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: fix race in setting bdev state
Date: Mon, 9 Oct 2017 21:14:34 -0700
Message-ID: <87d7ba70-35cd-0a05-250a-1af7526d66b6@lyle.org>
References: <1507604873-31352-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37574 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdJJEOh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Oct 2017 00:14:37 -0400
Received: by mail-pf0-f193.google.com with SMTP id z80so14000574pff.4
        for <linux-bcache@vger.kernel.org>; Mon, 09 Oct 2017 21:14:37 -0700 (PDT)
In-Reply-To: <1507604873-31352-1-git-send-email-tang.junhui@zte.com.cn>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn, colyli@suse.de
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Tang,

Thanks for the patch.

On 10/09/2017 08:07 PM, tang.junhui@zte.com.cn wrote:
> From: Tang Junhui <tang.junhui@zte.com.cn>
> 
> cached_dev_put() is called before setting and writing bdev to
> BDEV_STATE_CLEAN state, but after calling cached_dev_put(),
> detach work queue works, and bdev is also set to
> BDEV_STATE_NONE state in cached_dev_detach_finish(),
> it may cause race condition, and the state of bdev is uncertain.
> 
> Signed-off-by: Tang Junhui <tang.junhui@zte.com.cn>

How did you find this?  Did the race trigger at detach or was it through 
code inspection?

I need to analyze this more.  It looks correct on its own, but there are 
a lot of atomic variables and the way they are used is complicated.

I'm inclined to think that detach should traverse the writeback lock for 
safety.  It would be a lot less complicated to analyze what would 
happen.  What do you think?

Thanks,

Mike
