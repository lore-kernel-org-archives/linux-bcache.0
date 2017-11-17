From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Fri, 17 Nov 2017 13:38:12 +0100
Message-ID: <ba60f330-c32e-4adf-663f-c0182129586f@profihost.ag>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <dc6f513b-cca3-a37d-3379-2e12df21e825@suse.de>
 <CAPGwLLPmUiz-6xjur5jPAn1QLvkJY23QcsPCNvK+4+BVubWYnw@mail.gmail.com>
 <D393CD04-8C7A-4A8C-B23A-6C68D5544E34@profihost.ag>
 <CAPGwLLNTwZ1WrRVqwaLK5h8Ovj5SN5-Y-2qja843hwx2kJCAUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:41816 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755353AbdKQMiP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Nov 2017 07:38:15 -0500
In-Reply-To: <CAPGwLLNTwZ1WrRVqwaLK5h8Ovj5SN5-Y-2qja843hwx2kJCAUQ@mail.gmail.com>
Content-Language: de-DE
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Rui Hua <huarui.dev@gmail.com>
Cc: Coly Li <colyli@suse.de>, Coly Li <i@coly.li>, Michael Lyle <mlyle@lyle.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org


Am 17.11.2017 um 11:20 schrieb Rui Hua:
> Hi, Stefan
> 
> 2017-11-17 16:28 GMT+08:00 Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:
>> I‘m getting the same xfs error message under high load. Does this patch fix
>> it?
>>
> Did you applied the patch "bcache: only permit to recovery read error
> when cache device is clean" ?
> If you did, maybe this patch can fix it. And you'd better check
> /sys/fs/bcache/XXX/internal/cache_read_races in your environment,
> meanwhile, it should not be zero when you get that err message.
> 


Yes this patch is applied.

Stefan
