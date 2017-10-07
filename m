From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: rewrite multiple partitions support
Date: Sun, 8 Oct 2017 06:01:23 +0800
Message-ID: <4f51c027-608d-4941-ab07-67f0e886f9b9@suse.de>
References: <20170909184147.10458-1-colyli@suse.de>
 <CAJ+L6qc6xReHHwHnZx6oRL_H3u2JCEY+zaBhJ88-tzUrHhZUMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36853 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751823AbdJGWBg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 7 Oct 2017 18:01:36 -0400
In-Reply-To: <CAJ+L6qc6xReHHwHnZx6oRL_H3u2JCEY+zaBhJ88-tzUrHhZUMg@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

On 2017/10/8 上午5:42, Michael Lyle wrote:
> Indeed fixes a bug where minors and indices are interchanged on
> cleanup-- good catch.  Factoring out the index conversion is nice.
> 

Hi Mike,

> Hopefully no one is adversely affected by the stride change (16->128)
> and different naming, but they should be using udev + labels/uuids
> anyways.
> 

Yes, I hope so, too.

> Reviewed-by: Michael Lyle <mlyle@lyle.org>
> 

Thanks for the review. We have one more code reviewer, yeah!

Coly Li
