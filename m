From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: set task state correctly in allocator_wait()
Date: Wed, 22 Nov 2017 09:57:40 -0800
Message-ID: <6ae16d24-d7da-ba48-ddc8-7d715930eb2b@lyle.org>
References: <20171122123349.74347-1-colyli@suse.de>
 <0c8e78ab-e369-a40c-ee02-6a6c8f3a5cdd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:44056 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbdKVR5m (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 12:57:42 -0500
Received: by mail-pg0-f49.google.com with SMTP id c123so12883323pga.11
        for <linux-bcache@vger.kernel.org>; Wed, 22 Nov 2017 09:57:42 -0800 (PST)
In-Reply-To: <0c8e78ab-e369-a40c-ee02-6a6c8f3a5cdd@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Hey everyone--

On 11/22/2017 06:10 AM, Hannes Reinecke wrote:
> _Actually_ there is a push to remove all kthreads in the kernel, as they
> don't play nice together with RT.
> So while you're at it, do you think it'd be possible to convert it to a
> workqueue? Sebastian will be happy to help you here, right, Sebastian?

I don't see a reason why moving this away from a thread would be
advantageous.  There's neither devastating complexity in the current
form nor a need for additional concurrency (at least right now).

As it turns out, we're broken for RT for other reasons, but that has to
do with our use of closures and releasing locks in different threads
from where they're allocated.  The natural answer is completions, but
that's not easily done with the current structure of the code.

This current code is neither a problem for RT nor for
performance/legibility on mainline.

Mike
