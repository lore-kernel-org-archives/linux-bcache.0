From: Liang Chen <liangchen.linux@gmail.com>
Subject: Re: [PATCH] bcache: safeguard a dangerous addressing in closure_queue
Date: Fri, 13 Oct 2017 13:02:38 +0800
Message-ID: <CAKhg4tJTM9+R1z5NqgBQ9ix-T-C33_P5H-d5Q=cff3HAGcsZJA@mail.gmail.com>
References: <20171012143737.24577-1-liangchen.linux@gmail.com> <0b4be514-0ce8-efd9-4e17-8772729ac336@lyle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:45797 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdJMFCj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Oct 2017 01:02:39 -0400
In-Reply-To: <0b4be514-0ce8-efd9-4e17-8772729ac336@lyle.org>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Michael Lyle <mlyle@lyle.org>
Cc: linux-bcache@vger.kernel.org, Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@gmail.com>, linux-kernel@vger.kernel.org

On Fri, Oct 13, 2017 at 1:44 AM, Michael Lyle <mlyle@lyle.org> wrote:
> On 10/12/2017 07:37 AM, Liang Chen wrote:
>> The use of the union reduces the size of closure struct by taking advantage
>> of the current size of its members. The offset of func in work_struct equals
>> the size of the first three members, so that work.work_func will just
>> reference the forth member - fn.
>>
>> This is smart but dangerous. It can be broken if work_struct or the other
>> structs get changed, and can be a bit difficult to debug.
>>
>> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>
> So the objective here is to make sure that struct work_struct and the
> anonymous struct remain identical?  I agree that's a potential problem
> for future maintenance.
>
> Could we use BUILD_BUG_ON with offsets and sizes to do the same, to get
> compile-time checking and avoid doing anything at runtime (I know the
> compiler can usually omit the BUG but better to be safe)?  Otherwise a
> kernel that triggered this problem would compile, and it'd only be if
> someone actually used bcache that it would trigger.
>
> Mike

Yeah, the objective here is to make sure the offset of func and fn remains the
same so cl->work.func will just reference cl->fn.

Sure, BUILD_BUG_ON will do the work, and can capture the problem at compile
time. Thanks for the reminding! I will submit another patch soon.

Thanks,
Liang
