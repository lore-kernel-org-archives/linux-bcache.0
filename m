From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Request For Suggestion: how to handle udevd timeout for bcache
 registration
Date: Thu, 23 Apr 2020 09:08:40 -0600
Message-ID: <140de6d9-b5ff-0736-ddbd-5b9e1ae70f5b@kernel.dk>
References: <7c92cd67-8e62-7d55-c520-345c30513bfa@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728921AbgDWPIn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Apr 2020 11:08:43 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480E9C08E934
        for <linux-bcache@vger.kernel.org>; Thu, 23 Apr 2020 08:08:43 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w4so6705778ioc.6
        for <linux-bcache@vger.kernel.org>; Thu, 23 Apr 2020 08:08:43 -0700 (PDT)
In-Reply-To: <7c92cd67-8e62-7d55-c520-345c30513bfa@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc: linux-block@vger.kernel.org

On 4/23/20 5:23 AM, Coly Li wrote:
> Hi folk,
> 
> I want to listen to your suggestion on how to handle the udevd timeout
> for bcache registration.
> 
> First of all let me introduce the background of this timeout problem.
> 
> Now the bcache registration is synchronized, the registering process
> will be blocked until the whole registration done. In boot up time, such
> registration can be initiated from a bcache udev rule. Normally it won't
> be problem, but for very large cached data size there might be a large
> internal btree on the cache device. During the registration checking all
> the btree nodes may take 50+ minutes as a udev task, it exceeds 180
> seconds timeout and udevd will kill it. The killing signal will make
> kthread_create() fail during bcache initialization, then the automatic
> bcache registration in boot up time will fail.
> 
> The above text describes the problem I need to solve: make boot up time
> automatic bache registration always success no mater how long it will take.
> 
> I know there are several solutions to solve such problem, I do
> appreciate if you may share the solution so that I may learn good ideas
> from them.
> 
> Thank you in advance for the information sharing of my request of
> suggestion.

The way I see it, you have only two choices:

1) Make the registration async (or lazy), so that starting the device is
   fast, but the btree verification happens on-demand or in the
   background.

2) Increase udev timeout.

That's about it, I don't think there's any clever tricks to be had, and
I definitely don't want to go down the path of trying to work around the
udev killing in the kernel.

-- 
Jens Axboe
