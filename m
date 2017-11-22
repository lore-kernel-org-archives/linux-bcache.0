From: Michael Lyle <mlyle@lyle.org>
Subject: Re: ont out of 6 bcache devices does not register automatically
Date: Wed, 22 Nov 2017 09:51:32 -0800
Message-ID: <f6c02ce5-eeff-955f-53a6-0db07aaecd08@lyle.org>
References: <3ebfa7f8-cef6-ca8f-a56f-14a6bafd5bc6@profihost.ag>
 <22a61b57-1fbf-5ec4-383c-13b2cb8eaaf2@coly.li>
 <5c8958c1-acfd-14c9-d29f-0726ca92bc1c@profihost.ag>
 <58151524-1294-2c8a-42a0-a5f21886625d@coly.li>
 <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:38310 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdKVRvf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Nov 2017 12:51:35 -0500
Received: by mail-pg0-f47.google.com with SMTP id s11so12883309pgc.5
        for <linux-bcache@vger.kernel.org>; Wed, 22 Nov 2017 09:51:35 -0800 (PST)
In-Reply-To: <6c624629-c528-fd92-420f-ea50c4e6e4c5@profihost.ag>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, Coly Li <i@coly.li>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>

Hi Coly, Stefan--

On 11/22/2017 05:14 AM, Stefan Priebe - Profihost AG wrote:
>> Hi Stefan,
>>
>> Hmm, I don't have idea here. Anyway, is the cache mode set as writeback?
>> Recently I post a patch to fix a potential deadlock between writeback
>> rate update kworker and register code, I am not sure whether it is
>> relative to your issue, but at least we can have a try. the patch title is:
>>  [RFC] bcache: fix a circular dead locking with dc->writeback_lock and
>> bch_register_lock
>>
>> Just for your information.
> 
> i can try that one - can you please resend? I can't find that mail and
> don't know how to grab that one our of the web html archives to apply
> correctly.
> 
> Stefan

I don't think there's any chance this patch will do anything.  If
there's a deadlock, the whole thing will become stuck forever and never
allow registration or progress on the device again-- which doesn't match
the symptoms here.

This probably relates to udev configuration in your environment somehow.

Mike
