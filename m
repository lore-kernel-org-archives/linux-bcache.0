From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH v2] bcache: explicitly destroy mutex while exiting
Date: Tue, 10 Oct 2017 08:44:23 -0700
Message-ID: <c06f2a04-3654-0bb9-f07d-ee6d2b27868d@lyle.org>
References: <20171010090049.6596-1-liangchen.linux@gmail.com>
 <01f432e8-950a-fc9f-150d-0b51fa9e7559@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:45856 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdJJPoZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Oct 2017 11:44:25 -0400
Received: by mail-pf0-f173.google.com with SMTP id d28so2922745pfe.2
        for <linux-bcache@vger.kernel.org>; Tue, 10 Oct 2017 08:44:25 -0700 (PDT)
In-Reply-To: <01f432e8-950a-fc9f-150d-0b51fa9e7559@coly.li>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, Liang Chen <liangchen.linux@gmail.com>, linux-bcache@vger.kernel.org
Cc: kent.overstreet@gmail.com, linux-kernel@vger.kernel.org

On 10/10/2017 05:25 AM, Coly Li wrote:
> On 2017/10/10 下午5:00, Liang Chen wrote:
>> mutex_destroy does nothing most of time, but it's better to call
>> it to make the code future proof and it also has some meaning
>> for like mutex debug.
>>
>> As Coly pointed out in a previous review, bcache_exit() may not be
>> able to handle all the references properly if userspace registers
>> cache and backing devices right before bch_debug_init runs and
>> bch_debug_init failes later. So not exposing userspace interface
>> until everything is ready to avoid that issue.
>>
>> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> 
> Hi Liang,
> 
> No more comment from me, it looks good. Thanks.
> 
> Reviewed-by: Coly Li <colyli@suse.de>

Looks good to me too.

Reviewed-by: Michael Lyle <mlyle@lyle.org>
