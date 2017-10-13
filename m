From: Alexandr Kuznetsov <progmachine@xenlab.one>
Subject: Re: bcache failure hangs something in kernel
Date: Fri, 13 Oct 2017 13:11:24 +0300
Message-ID: <95fd28e3-104c-e597-5dc0-bca1dbc92727@xenlab.one>
References: <efb67a88-3f4c-d268-3d2a-59c00824b5e7@xenlab.one>
 <b574aee6-1f6f-8eb3-d78a-ee3fd8f9bfb3@lyle.org>
 <b4cf93d3-7e15-9f20-941b-7f11269c510b@xenlab.one>
 <024c8d28-9ddb-09fe-c2b0-8a7d0aed493d@lyle.org>
 <f9afc17d-de8b-1d5e-bb34-260051aa2de1@xenlab.one>
 <d49c21f3-354b-675a-60d4-702a40e3c3c8@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from forward104o.mail.yandex.net ([37.140.190.179]:39320 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757823AbdJMKLe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 06:11:34 -0400
In-Reply-To: <d49c21f3-354b-675a-60d4-702a40e3c3c8@lyle.org>
Content-Language: ru
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>, linux-bcache@vger.kernel.org

>
> I'm sorry you've lost data.  I've run bcache and lvm a lot at scale and
> haven't seen anything like this, nor are there any other reports as far
> as I'm aware.  I am new as bcache maintainer but have a pretty high
> degree of confidence it doesn't overwrite its own superblocks randomly.
>
> If you come up with a repro I'll be glad to look at it.
>
> Mike
So, it's the first report of such a failure... Ok, when i reinstall 
system and i'll have free time, i will try to repoduce this situation, 
if it is not caused by random galactic rays.
Last question: bcache now used worldwide, and yet there is no 
consistency check&repair tool exist? I am not found answer fo this 
question. If it exist, it will help in failure situations with minor 
damages.
