From: Liang C <liangchen.linux@gmail.com>
Subject: Re: [PATCH v2] bcache: explicitly destroy mutex while exiting
Date: Mon, 30 Oct 2017 20:33:32 +0800
Message-ID: <CAKhg4tKcO-DEjnhS6tasSrXd9TwuLaOxgYdPEo9FbgLpBH8ZBA@mail.gmail.com>
References: <20171010090049.6596-1-liangchen.linux@gmail.com>
 <01f432e8-950a-fc9f-150d-0b51fa9e7559@coly.li> <c06f2a04-3654-0bb9-f07d-ee6d2b27868d@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:56022 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbdJ3Mde (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Oct 2017 08:33:34 -0400
In-Reply-To: <c06f2a04-3654-0bb9-f07d-ee6d2b27868d@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: Coly Li <i@coly.li>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Michael,
Would you please to include this patch in your tree for the next
release? It seems passed the review. Thank you.

Thanks,
Liang

On Tue, Oct 10, 2017 at 11:44 PM, Michael Lyle <mlyle@lyle.org> wrote:
> On 10/10/2017 05:25 AM, Coly Li wrote:
>> On 2017/10/10 =E4=B8=8B=E5=8D=885:00, Liang Chen wrote:
>>> mutex_destroy does nothing most of time, but it's better to call
>>> it to make the code future proof and it also has some meaning
>>> for like mutex debug.
>>>
>>> As Coly pointed out in a previous review, bcache_exit() may not be
>>> able to handle all the references properly if userspace registers
>>> cache and backing devices right before bch_debug_init runs and
>>> bch_debug_init failes later. So not exposing userspace interface
>>> until everything is ready to avoid that issue.
>>>
>>> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>>
>> Hi Liang,
>>
>> No more comment from me, it looks good. Thanks.
>>
>> Reviewed-by: Coly Li <colyli@suse.de>
>
> Looks good to me too.
>
> Reviewed-by: Michael Lyle <mlyle@lyle.org>
>
