From: Konstantin Shalygin <k0ste@k0ste.ru>
Subject: Re: lock, Workqueue: bcache bch_data_insert_keys [bcache]
Date: Sat, 8 Jul 2017 18:43:55 +0700
Message-ID: <bb530062-3c6a-5166-c7aa-1bd3fa72c5ab@k0ste.ru>
References: <4e51563b-bb3d-efcc-0f84-76572c87c352@k0ste.ru>
 <alpine.LRH.2.11.1707071710550.17052@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from k0ste.ru ([212.20.43.218]:46624 "EHLO k0ste.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751706AbdGHLoA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 8 Jul 2017 07:44:00 -0400
In-Reply-To: <alpine.LRH.2.11.1707071710550.17052@mail.ewheeler.net>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org

Eric, thanks. I was apply this patch on 4.11.9.

I hope that I will not stumble upon this lock again.


On 07/08/2017 12:16 AM, Eric Wheeler wrote:
> Hi Konstantin,
>
> Try this patch:
>
> https://www.spinics.net/lists/stable/msg178933.html

-- 
Best regards,
Konstantin Shalygin
