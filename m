From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [for-416 PATCH 1/2] bcache: Fix, improve efficiency of
 closure_sync()
Date: Fri, 5 Jan 2018 09:05:14 -0700
Message-ID: <cfee0947-24bd-c45a-5219-81ae6a208069@kernel.dk>
References: <20171230230934.910-1-mlyle@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:33466 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbeAEQFR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Jan 2018 11:05:17 -0500
Received: by mail-it0-f54.google.com with SMTP id o130so4935736itg.0
        for <linux-bcache@vger.kernel.org>; Fri, 05 Jan 2018 08:05:16 -0800 (PST)
In-Reply-To: <20171230230934.910-1-mlyle@lyle.org>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>

On 12/30/17 4:09 PM, Michael Lyle wrote:
> +void __closure_sync(struct closure *cl)
> +{
> +	struct closure_syncer s = { .task = current };
>  
> +	cl->s = &s;
> +	continue_at(cl, closure_sync_fn, NULL);
> +
> +	while (1) {
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +		smp_mb(); /* Ensure task state set before load of done flag */

That's why we have set_current_state().

-- 
Jens Axboe
