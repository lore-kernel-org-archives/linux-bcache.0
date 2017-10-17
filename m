From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] md: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 20:06:06 -0700
Message-ID: <390e7ce2-fda1-ad11-6c96-0ea44615c845@lyle.org>
References: <20171017000148.GA102867@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:56570 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757182AbdJQDGK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2017 23:06:10 -0400
Received: by mail-pf0-f195.google.com with SMTP id b85so292198pfj.13
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2017 20:06:10 -0700 (PDT)
In-Reply-To: <20171017000148.GA102867@beast>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Shaohua Li <shli@fb.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/16/2017 05:01 PM, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: linux-bcache@vger.kernel.org
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

This looks good to me-- I'm fine with Jens or someone else picking this
up directly, or would take a bcache-specific one to apply to my tree.

Reviewed-by: Michael Lyle <mlyle@lyle.org>

> [snip]
