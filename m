From: Rui Hua <huarui.dev@gmail.com>
Subject: Re: [PATCH] bcache: recover data from backing device when read
 request hit clean
Date: Fri, 17 Nov 2017 12:25:54 +0800
Message-ID: <CAPGwLLNyjjxKOXA3RCFGSi4p-ZWZ5T9ADWP6EAqrfL3oUvMbFQ@mail.gmail.com>
References: <CAPGwLLNwG+kLT9_QaCL5PBLS0a6K-x-iog+ON2pArUQWr1rWTg@mail.gmail.com>
 <1c715cc2-b656-36a8-4017-55052937df82@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:36354 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932695AbdKQE0P (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Nov 2017 23:26:15 -0500
In-Reply-To: <1c715cc2-b656-36a8-4017-55052937df82@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org

Hi, Michael--

Thanks for the quickly reply.

If the metadata on the cache device was NOT correctly read,
cached_dev_read_error() will not be called, so the recovery check will
not be executed. so this patch is safe.
s->iop.error was not set when faild to read metadata on the cache
device, so the  cached_dev_bio_complete() will be called instead of
cached_dev_read_error()

2017-11-17 12:02 GMT+08:00 Michael Lyle <mlyle@lyle.org>:
> Hi, Rui Hua--
>
> On 11/16/2017 07:51 PM, Rui Hua wrote:
>> In this patch, we use s->read_dirty_data to judge whether the read
>> request hit dirty data in cache device, it is safe to reread data from
>> the backing device when the read request hit clean data. This can not
>> only handle cache read race, but also recover data when failed read
>> request from cache device.
>
> I haven't read over all of this yet, to understand the read race.  But
> this change can't be safe-- read_dirty_data only is set to true if the
> metadata on the cache device is correctly read.  If that fails, the flag
> may not be set and we could read stale data on the backing device.
>
> Mike
