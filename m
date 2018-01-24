From: tang.junhui@zte.com.cn
Subject: Re: how to understand bcache
Date: Wed, 24 Jan 2018 17:34:15 +0800
Message-ID: <1516786455-29038-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:58582 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932606AbeAXJcu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Jan 2018 04:32:50 -0500
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: ponycheng0@gmail.com
Cc: colyli@suse.de, mlyle@lyle.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, tang.junhui@zte.com.cn

From: Tang Junhui <tang.junhui@zte.com.cn>

> On 24/01/2018 10:34 AM, Pony Cheng wrote:
> > Hi all,
> > 
> > I'm beginner of kernel module, and I'm reading bcache codebase now.
> > But I'm very confused about many details, such as b+tree and io path.
> > 
> > So, what should I do now, do you have some advices?
> 
> Hi Pony,
> 
> Read the code, through out your questions. If the question is
> easy/simple, you may have response.
> 
> Coly Li

It sounds interesting, hahahaha~~

you'd better to known how the data organized in disk,
and what is bkey, bset, btree node, and what erver else,
and think about deeply: If I am the author, how would I write
the code, and read the currently code, to find wether it written
as your thought, judge about is it your wrong or the author, Then 
you understood bcache, and bcache also understood you.

you also can ask our dear maintainer Mike, who knows all about bcache,
but sometiomes he is very busy, It is normally you would hear nothing 
from him for one weeks or two, sometimes maybe three, but never five, 
since the merge window comes.

Thanks,
Tang Junhui
