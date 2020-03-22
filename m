From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/7] bcache patches for Linux v5.7-rc1
Date: Sun, 22 Mar 2020 10:07:35 -0600
Message-ID: <61344bad-e454-1827-c0bc-038f7e73dc16@kernel.dk>
References: <20200322060305.70637-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34876 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVQHo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 Mar 2020 12:07:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id 7so5872830pgr.2
        for <linux-bcache@vger.kernel.org>; Sun, 22 Mar 2020 09:07:43 -0700 (PDT)
In-Reply-To: <20200322060305.70637-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 3/22/20 12:02 AM, Coly Li wrote:
> Hi Jens,
> 
> These are bcache patches for Linux v5.7-rc1.
> 
> The major change is to make bcache btree check and dirty secrtors
> counting being multithreaded, then the registration time can be
> much less. My first four patches are for this purpose.
> 
> Davidlohr Bueso contributes a patch to optimize barrier usage for
> atomic operations. By his inspiration I also compose a patch for
> the rested locations to change.
> 
> Takashi Iwai contributes a helpful patch to avoid potential
> buffer overflow in bcache sysfs code path.
> 
> Please take them, and thank you in advance.

Applied, thanks.

-- 
Jens Axboe
