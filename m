From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [RFC] bcache: fix a circular dead locking with dc->writeback_lock
 and bch_register_lock
Date: Sat, 18 Nov 2017 09:01:11 -0800
Message-ID: <a64160cc-f008-3732-4c95-818368614cbb@lyle.org>
References: <20171118081415.49669-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:33292 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424334AbdKRRBN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Nov 2017 12:01:13 -0500
Received: by mail-pf0-f178.google.com with SMTP id a84so4208447pfl.0
        for <linux-bcache@vger.kernel.org>; Sat, 18 Nov 2017 09:01:13 -0800 (PST)
In-Reply-To: <20171118081415.49669-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc: linux-block@vger.kernel.org

Coly--

It's a real circular lock dep between registration (a very rare
operation) and writeback rate calculation (a fairly rare operation).
While it's definitely a real issue, it's a very unlikely one to be
actually encountered.

(Encountering it requires the every-5-second periodic task of
calculating writeback to be running, between writeback lock and register
lock [a pretty short window], and then for the user to register a new
cached volume)

This particular issue was introduced in a8394090a9129b40f9 ("bcache:
correct cache_dirty_target in __update_writeback_rate()") as part of
4.14. I'm concerned that if we keep putting in small local patches like
this (especially to lock ordering or registration/deregistration
behavior) that we're just moving problems around.

I'm planning on working on the writeback lock this cycle to make it less
contended.  As part of this I plan to audit overall lock order, and to
broaden use of the registration lock to better control reg/dereg
ordering.  That is, there's already going to be a lot of change in this
path and I hope to catch/fix a lot of issues like this.

Mike
