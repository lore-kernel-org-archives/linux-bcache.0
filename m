From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: Re: Re: [PATCH] bcache: gc does not work when triggering by
 manualcommand
Date: Tue, 20 Jun 2017 21:54:56 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1706202153540.17052@mail.ewheeler.net>
References: 201706090859585160191@zte.com.cn,d36c9169-0a60-a0c6-3ac6-5c783176b17f@coly.li,201706091425519399444@zte.com.cn <201706091441562879991@zte.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:44516 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751926AbdFTVy6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Jun 2017 17:54:58 -0400
In-Reply-To: <201706091441562879991@zte.com.cn>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: tang.junhui@zte.com.cn
Cc: i@coly.li, linux-bcache@vger.kernel.org

On Fri, 9 Jun 2017, tang.junhui@zte.com.cn wrote:

> 
> We can remove the function wake_up_gc_force(), and make the patch more elegant, I will send you a new patch
> later.

Hi Tang,

Checking in: Did you already write a v2 for the trigger_gc fix?  I've not 
seen it yet.

-Eric



--
Eric Wheeler


> 
> 
> 
