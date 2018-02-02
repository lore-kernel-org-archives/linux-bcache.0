From: Pony Cheng <ponycheng0@gmail.com>
Subject: Re: bcache journal
Date: Fri, 2 Feb 2018 10:18:39 +0800
Message-ID: <CAATtUKkoqg6h9OdxtK3jShvwR4aH55Z3yjOgkgdituJ5HnCaPA@mail.gmail.com>
References: <CAATtUKmyuZUXq0SLx6YmMJPWzFfw15cNm=EGZpD6pxeuHGqt+g@mail.gmail.com>
 <fa369a50-679d-4d37-7a5d-5f9181bb8878@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:43426 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754113AbeBBCSl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Feb 2018 21:18:41 -0500
Received: by mail-wr0-f172.google.com with SMTP id b52so775544wrd.10
        for <linux-bcache@vger.kernel.org>; Thu, 01 Feb 2018 18:18:40 -0800 (PST)
In-Reply-To: <fa369a50-679d-4d37-7a5d-5f9181bb8878@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org

OK, thank you very much.

2018-01-31 15:55 GMT+08:00 Michael Lyle <mlyle@lyle.org>:
> Hi Pony Cheng--
>
> On 01/28/2018 11:23 PM, Pony Cheng wrote:
>> Hi all:
>>      I'm reading the source code of bcache, and I'm so confused about
>> journal. Journal just use bucket of cache, why we need it, and what's
>> the real purpose of journal in bcache. If we write to the bucket, do
>> we need write it to journal first?
>
> The purpose of the journal is to control write amplification from btree
> node writes.  If we have 100 things to insert into the btree because
> we're just caching new things, and this would touch 100 different btree
> nodes, we can just write the new nodes to the journal in a single I/O
> instead of doing 100 different updates.  Later, we can free the journal
> pages by doing those updates, but hopefully be doing more than one
> update to each btree node and significantly lessen the total amount of I/O.
>
>>
>> How do you think of these?
>>
>> Pony Cheng
>
> Regards,
>
> Mike
