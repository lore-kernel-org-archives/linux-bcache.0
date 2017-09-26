From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH 04/12] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 26 Sep 2017 12:55:54 -0700
Message-ID: <CAJ+L6qc1KAMrj6bpp2R7A=O1HmT=Gq_Wt6f4LVc6rAxQ=O8kwQ@mail.gmail.com>
References: <20170906062602.50497-1-colyli@suse.de> <20170906062602.50497-5-colyli@suse.de>
 <CAJ+L6qfHB7vAAXUrnjXUQqLE6k+v4yukL58DDzRBBKA+aONLmA@mail.gmail.com> <1433ecdd-3394-c65f-9588-4d2a20df25d5@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35768 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965209AbdIZTzz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2017 15:55:55 -0400
Received: by mail-qk0-f195.google.com with SMTP id o77so7499184qke.2
        for <linux-bcache@vger.kernel.org>; Tue, 26 Sep 2017 12:55:55 -0700 (PDT)
In-Reply-To: <1433ecdd-3394-c65f-9588-4d2a20df25d5@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Eric Wheeler <bcache@lists.ewheeler.net>, Byungchul Park <byungchul.park@lge.com>, Kent Overstreet <kent.overstreet@gmail.com>

Thanks everyone--

Yes, this looks good to me and works in testing.

Mike

On Tue, Sep 26, 2017 at 12:46 AM, Coly Li <i@coly.li> wrote:
> On 2017/9/26 =E4=B8=8B=E5=8D=8812:38, Michael Lyle wrote:
>> I believe this introduces a critical bug.
>>
>> cl->list is used to link together the llists for both things waiting,
>> and for things that are being woken.
>>
>> If a closure that is woken decides to wait again, it will corrupt the
>> llist that __closure_wake_up is using.
>>
>> The previous iteration structure gets the next element of the list
>> before waking and is therefore safe.
>
>
> Hi Michael and Byungchul,
>
> This is my fault to suggest Byungchul to change his correct patch into
> wrong one. But it's good to learn such an implicit race behind bcache
> code. I just post a patch to explain how this race may happen and
> corrupt the reverse list iteration. Could you please to review the fix ?
>
> And thanks to Michael again to catch this bug.
>
> --
> Coly Li
