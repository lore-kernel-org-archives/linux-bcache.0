From: Michael Lyle <mlyle@lyle.org>
Subject: Re: bcache journal
Date: Tue, 30 Jan 2018 23:55:21 -0800
Message-ID: <fa369a50-679d-4d37-7a5d-5f9181bb8878@lyle.org>
References: <CAATtUKmyuZUXq0SLx6YmMJPWzFfw15cNm=EGZpD6pxeuHGqt+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:46752 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752886AbeAaHzY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Jan 2018 02:55:24 -0500
Received: by mail-io0-f175.google.com with SMTP id f34so14221608ioi.13
        for <linux-bcache@vger.kernel.org>; Tue, 30 Jan 2018 23:55:24 -0800 (PST)
In-Reply-To: <CAATtUKmyuZUXq0SLx6YmMJPWzFfw15cNm=EGZpD6pxeuHGqt+g@mail.gmail.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Pony Cheng <ponycheng0@gmail.com>, linux-bcache@vger.kernel.org

Hi Pony Cheng--

On 01/28/2018 11:23 PM, Pony Cheng wrote:
> Hi all:
>      I'm reading the source code of bcache, and I'm so confused about
> journal. Journal just use bucket of cache, why we need it, and what's
> the real purpose of journal in bcache. If we write to the bucket, do
> we need write it to journal first?

The purpose of the journal is to control write amplification from btree
node writes.  If we have 100 things to insert into the btree because
we're just caching new things, and this would touch 100 different btree
nodes, we can just write the new nodes to the journal in a single I/O
instead of doing 100 different updates.  Later, we can free the journal
pages by doing those updates, but hopefully be doing more than one
update to each btree node and significantly lessen the total amount of I/O.

> 
> How do you think of these?
> 
> Pony Cheng

Regards,

Mike
