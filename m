From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Comm: bcache_allocato BUG: unable to handle kernel NULL pointer
 dereference at 00000000000006bc
Date: Sat, 14 Oct 2017 14:23:15 -0700
Message-ID: <2c3a76c1-3374-ac8d-5023-fd8809d399d2@lyle.org>
References: <CAGmahrSoEjp5Qh4P9OLk-x7W73F3FNbwc7x2wpChHq_Y_SSj=g@mail.gmail.com>
 <c1470bb5-413c-2cc9-0560-b90a3b577c99@coly.li>
 <CAGmahrQ=UhHOpwcRXgWqgyb6aWFt3FGn0vip630JSCq8cMH0CA@mail.gmail.com>
 <f0bd886e-b083-a07a-89c2-a8ade257aeef@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:49612 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdJNVXS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 14 Oct 2017 17:23:18 -0400
Received: by mail-pf0-f174.google.com with SMTP id l188so12961831pfc.6
        for <linux-bcache@vger.kernel.org>; Sat, 14 Oct 2017 14:23:18 -0700 (PDT)
In-Reply-To: <f0bd886e-b083-a07a-89c2-a8ade257aeef@coly.li>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>, Sverd Johnsen <sverd.johnsen@googlemail.com>
Cc: linux-bcache@vger.kernel.org

Hey Coly--

On 10/14/2017 09:22 AM, Coly Li wrote:
> On 2017/10/14 下午8:04, Sverd Johnsen wrote:
>> Yes. bcache-tools ships some udev rules associated helper utils that
>> are used here.
>>
> 
> Hi Sverd,
> 
> Is it possible for you to test the attached patch ? This is an effort to
> avoid NULL dereference issue, let's try whether it works.
> 
> Thanks in advance.
> 
> Coly Li

It looks like in the patch that you move some kobject_init's around and
it's a better factoring.  But for the sysfs to be accessed when the
structures aren't available, doesn't it have to be after the
kobject_adds, which is much later?

Isn't this reported issue is the thing that you fixed earlier in
"bcache: check ca->alloc_thread initialized before wake up it" ?

It seems like we have a lot of issues with bringing up devices and
tearing them down/detaching.

Mike
