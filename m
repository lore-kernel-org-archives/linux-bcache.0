From: Michael Lyle <mlyle@lyle.org>
Subject: Re: Enabling discard rendered caching device unuseable
Date: Tue, 7 Nov 2017 10:17:53 -0800
Message-ID: <CAJ+L6qeOVY_KofXsZKihHrbHaYzQTKYAh0Shm7Givj+f8=PiBg@mail.gmail.com>
References: <CAFvQSYTrzA=i6Xww3vGRs+Wu3sHg_hjXMY1JmEdfNb8hD2Phxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:47371 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758609AbdKGSRy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Nov 2017 13:17:54 -0500
Received: by mail-qk0-f179.google.com with SMTP id m189so154274qke.4
        for <linux-bcache@vger.kernel.org>; Tue, 07 Nov 2017 10:17:54 -0800 (PST)
In-Reply-To: <CAFvQSYTrzA=i6Xww3vGRs+Wu3sHg_hjXMY1JmEdfNb8hD2Phxw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-bcache@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-bcache@vger.kernel.org

Clemens--

I'm sorry for this experience; I've added discard to my list of things
to review.

I suggest avoiding discard for bcache; since the cache device grows
until it is nearly full and is kept in that state, there is little
benefit from it.

Mike

On Mon, Nov 6, 2017 at 2:04 AM, Clemens Eisserer <linuxhippy@gmail.com> wrote:
> Hi,
>
> After using bcache for 9 months without any issues, I discovered the
> "discard" flag for the caching device.
> Running 4.13.5 I gave it a try, however after reboot the caching
> device failed to register with:
>
> At reboot bcache failed with:
> prio_read() bad csum reading priorities
> prio_read() bad magic reading priorities
>
> The SSD used as caching device was a OCZ-OCTANE with the latest
> firmware, which worked (and works) flawlessly for years and has no
> SMART issues.
>
> Best regards, Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
